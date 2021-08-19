import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

import 'edit_task_bloc.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key? key}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _ecController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  late EditTaskBloc bloc;

  String dropdownValue = 'Irrigation';

  List<String> spinnerItems = [
    'Irrigation',
    'Fertigation',
  ];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditTaskBloc>(context);
    bloc.add(EditTaskLoadedEvent());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _ecController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _blocListener(BuildContext context, EditTaskState state) {
    if (state.error.isNotEmpty) {
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    } else if (state.isFetched) {
      _hoursController.text = "${state.initial!.hours}";
      _minutesController.text = "${state.initial!.minutes}";
      _ecController.text = "${state.initial!.ec}";
      _durationController.text = "${state.initial!.duration}";

      dropdownValue = "${state.initial!.action}";

      // Ensure the bloc has the latest values.
      _onTextFieldChanged();
    }
  }

  void _onTextFieldChanged() {
    bloc.add(EditTaskTextFieldChangedEvent(
        hours: _hoursController.text,
        minutes: _minutesController.text,
        ec: _ecController.text,
        duration: _durationController.text));
  }

  void _savePressed() {
    // Return the updated task to the caller.
    var got = bloc.task();
    print("returning $got");
    Navigator.of(context).pop(got);
  }

  void _cancelPressed() {
    // Return null to the caller to signal no changes.
    Navigator.of(context).pop(null);
  }

  Widget buildForm(EditTaskState state) {
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
                    hintText: 'Hours',
                    controller: _hoursController,
                    onChanged: _onTextFieldChanged,
                    keyboardType: TextInputType.number),
                FormTextField(
                  hintText: 'Minutes',
                  controller: _minutesController,
                  onChanged: _onTextFieldChanged,
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? data) {
                    print("selected $data");
                    if (data != null) {
                      bloc.add(EditTaskActionChangedEvent(data));
                      setState(() {
                        dropdownValue = data;
                      });
                    }
                  },
                  items: spinnerItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                FormTextField(
                  hintText: 'EC',
                  controller: _ecController,
                  onChanged: _onTextFieldChanged,
                  keyboardType: TextInputType.number,
                ),
                FormTextField(
                  hintText: 'Duration',
                  controller: _durationController,
                  onChanged: _onTextFieldChanged,
                  keyboardType: TextInputType.number,
                ),
                FormButton(
                    text: 'Save',
                    onPressed: state.isValid ? _savePressed : null),
                FormButton(text: 'Cancel', onPressed: _cancelPressed)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTaskBloc, EditTaskState>(
        listener: _blocListener,
        child: BlocBuilder<EditTaskBloc, EditTaskState>(
          builder: (context, state) {
            print("state is $state");
            if (state is EditTaskState) {
              return buildForm(state);
            }
            throw "Unhandled state";
          },
        ));
  }
}
