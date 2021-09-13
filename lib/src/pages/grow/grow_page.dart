import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/dialog_form.dart';
import 'package:plantos/src/widgets/field_box.dart';
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
  Loading? _loading;

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
    if (state.isLoading) {
      print("creating loading dialog widget");
      _loading = Loading(context);
    } else if (!state.isLoading && _loading != null) {
      print("cancelling loading dialog widget");
      _loading?.close();
      _loading = null;
    }

    if (state.error.isNotEmpty) {
      print("showing error message: ${state.error}");
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          state.error,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ));
    } else if (state.isFetched) {
      _nameController.text = state.grow.name;

      // Ensure the bloc has the latest values.
      _onTextFieldChanged();
    } else if (state.isSuccess) {
      print("state.isSuccess - popping context");
      Navigator.pop(context);
    }
  }

  void _onTextFieldChanged() {
    bloc.add(GrowTextFieldChangedEvent(
      name: _nameController.text,
    ));
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

  void _onChangePlotSelection(int? plot) {
    print("selected $plot");
    if (plot != null) {
      bloc.add(GrowPlotChangedEvent(plot: plot));
    }
  }

  void _onPressDatePicker(GrowState state) async {
    var result = await showDatePicker(
      context: context,
      initialDate: state.grow.startDate == null
          ? DateTime.now()
          : DateTime(state.grow.startDate!.year, state.grow.startDate!.month,
              state.grow.startDate!.day),
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2031, 1, 1),
    );
    print("got: $result");
    if (result != null) {
      bloc.add(GrowStartDateChangedEvent(
          startDate: LocalDate(
              year: result.year, month: result.month, day: result.day)));
    }
  }

  Program? lookupProgram(GrowState state) {
    var it =
        state.programs.where((element) => element.id == state.grow.programId);
    if (it.isEmpty) {
      return null;
    }
    return it.first;
  }

  Device? lookupDevice(GrowState state) {
    var it =
        state.devices.where((element) => element.id == state.grow.deviceId);
    if (it.isEmpty) {
      return null;
    }
    return it.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GrowBloc, GrowState>(
      listener: _blocListener,
      child: BlocBuilder<GrowBloc, GrowState>(
        builder: (context, state) {
          print("state is $state");
          return DialogForm(
            header: Text("New Grow", style: dialogHeaderStyle),
            onPressedSave: () => bloc.add(GrowPressedEvent()),
            isValid: state.isValid,
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Name", style: labelStyle),
                  ),
                  FieldBox(
                    child: FormTextField(
                      hintText: 'Name',
                      controller: _nameController,
                      onChanged: _onTextFieldChanged,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Program", style: labelStyle),
                  ),
                  FieldBox(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: DropdownButton<Program>(
                          isExpanded: true, // fill width
                          icon: Image.asset("assets/icon/arrow_down.png",
                              width: 12, height: 6),
                          value: lookupProgram(state),
                          onChanged: _onChangeProgramSelection,
                          items: state.programs
                              .map<DropdownMenuItem<Program>>(
                                  (value) => DropdownMenuItem<Program>(
                                        value: value,
                                        child: Text(value.name),
                                      ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Device", style: labelStyle),
                  ),
                  FieldBox(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: DropdownButton<Device>(
                          isExpanded: true, // fill width
                          icon: Image.asset("assets/icon/arrow_down.png",
                              width: 12, height: 6),
                          value: lookupDevice(state),
                          onChanged: _onChangeDeviceSelection,
                          items: state.devices
                              .map<DropdownMenuItem<Device>>(
                                  (value) => DropdownMenuItem<Device>(
                                        value: value,
                                        child: Text(value.description),
                                      ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Plot", style: labelStyle),
                  ),
                  FieldBox(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: DropdownButton<int>(
                          isExpanded: true, // fill width
                          icon: Image.asset("assets/icon/arrow_down.png",
                              width: 12, height: 6),
                          value: state.grow.plot,
                          onChanged: _onChangePlotSelection,
                          items: List.generate(
                              2,
                              (index) => DropdownMenuItem<int>(
                                    value: index,
                                    child: Text("$index"),
                                  )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Start Date", style: labelStyle),
                  ),
                  GestureDetector(
                    onTap: () => _onPressDatePicker(state),
                    child: FieldBox(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.grow.startDate == null
                                ? ""
                                : DateFormat.yMd('en_MY').format(DateTime(
                                    state.grow.startDate!.year,
                                    state.grow.startDate!.month,
                                    state.grow.startDate!.day))),
                            Image.asset("assets/icon/calendar.png",
                                width: 16, height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
