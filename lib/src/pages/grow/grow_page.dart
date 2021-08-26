import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

import 'grow_bloc.dart';

class GrowPage extends StatefulWidget {
  const GrowPage({
    Key? key,
  }) : super(key: key);

  @override
  _GrowPageState createState() => _GrowPageState();
}

class _GrowPageState extends State<GrowPage> {
  TextEditingController _nameController = TextEditingController();

  late GrowBloc bloc;

  String dropdownValue = 'Irrigation';

  List<String> spinnerItems = [
    'Irrigation',
    'Fertigation',
  ];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<GrowBloc>(context);
    bloc.add(GrowStartedEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _blocListener(BuildContext context, GrowState state) {
    if (state.error.isNotEmpty) {
      print("showing error message: ${state.error}");
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   backgroundColor: Colors.red,
      //   content: Text(
      //     state.error,
      //     style: TextStyle(fontSize: 16, color: Colors.white),
      //   ),
      // ));
    } else if (state.isFetched) {
      _nameController.text = state.grow.name;

      // Ensure the bloc has the latest values.
      _onTextFieldChanged();
    }
  }

  void _onTextFieldChanged() {
    bloc.add(GrowTextFieldChangedEvent(
      name: _nameController.text,
    ));
  }

  void _savePressed() {
    bloc.add(GrowPressedEvent());
  }

  void _cancelPressed() {
    // Return null to the caller to signal no changes.
    Navigator.of(context).pop(null);
  }

  void _onChangeProgramSelection(Program? program) {
    print("selected $program");
    if (program != null) {
      bloc.add(GrowProgramChangedEvent(program: program));
    }
  }

  void _onChangeDeviceSelection(Device? device) {
    print("selected $device");
    if (device != null) {
      bloc.add(GrowDeviceChangedEvent(device: device));
    }
  }

  Widget buildForm(GrowState state) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormTextField(
                  hintText: 'Name',
                  controller: _nameController,
                  onChanged: _onTextFieldChanged,
                  keyboardType: TextInputType.text,
                ),
                DropdownButton<Program>(
                  value: state.grow.programId == null
                      ? null
                      : state.programs.singleWhere(
                          (element) => element.id == state.grow.programId),
                  onChanged: _onChangeProgramSelection,
                  items: state.programs
                      .map<DropdownMenuItem<Program>>(
                          (value) => DropdownMenuItem<Program>(
                                value: value,
                                child: Text(value.name),
                              ))
                      .toList(),
                ),
                DropdownButton<Device>(
                  value: state.grow.deviceId == null
                      ? null
                      : state.devices.singleWhere(
                          (element) => element.id == state.grow.deviceId),
                  onChanged: _onChangeDeviceSelection,
                  items: state.devices
                      .map<DropdownMenuItem<Device>>(
                          (value) => DropdownMenuItem<Device>(
                                value: value,
                                child: Text(value.description),
                              ))
                      .toList(),
                ),
                GestureDetector(
                    onTap: () async {
                      var result = await showDatePicker(
                        context: context,
                        initialDate: state.grow.startDate == null
                            ? DateTime.now()
                            : DateTime(
                                state.grow.startDate!.year,
                                state.grow.startDate!.month,
                                state.grow.startDate!.day),
                        firstDate: DateTime(2021, 1, 1),
                        lastDate: DateTime(2031, 1, 1),
                      );
                      print("got: $result");
                      if (result != null) {
                        bloc.add(GrowStartDateChangedEvent(
                            startDate: LocalDate(
                                year: result.year,
                                month: result.month,
                                day: result.day)));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.white,
                      child: Text(state.grow.startDate == null
                          ? ""
                          : DateFormat.yMd('en_MY').format(DateTime(
                              state.grow.startDate!.year,
                              state.grow.startDate!.month,
                              state.grow.startDate!.day))),
                    )),
                FormButton(
                  text: 'Save',
                  onPressed: state.isValid ? _savePressed : null,
                ),
                FormButton(
                  text: 'Cancel',
                  onPressed: _cancelPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GrowBloc, GrowState>(
      listener: _blocListener,
      child: BlocBuilder<GrowBloc, GrowState>(
        builder: (context, state) {
          print("state is $state");
          return buildForm(state);
        },
      ),
    );
  }
}
