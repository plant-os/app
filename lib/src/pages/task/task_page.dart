import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

import 'task_bloc.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    Key? key,
  }) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _ecController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  late TaskBloc bloc;

  String dropdownValue = 'Irrigation';

  List<String> spinnerItems = [
    'Irrigation',
    'Fertigation',
  ];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TaskBloc>(context);
    bloc.add(TaskLoadedEvent());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _ecController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _blocListener(BuildContext context, TaskState state) {
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
    bloc.add(TaskTextFieldChangedEvent(
      hours: _hoursController.text,
      minutes: _minutesController.text,
      ec: _ecController.text,
      duration: _durationController.text,
    ));
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

  Widget buildForm(TaskState state) {
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
                  keyboardType: TextInputType.number,
                ),
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
                      bloc.add(TaskActionChangedEvent(data));
                      setState(() {
                        dropdownValue = data;
                      });
                    }
                  },
                  items: spinnerItems
                      .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
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
                SecondaryButton(
                  text: 'Save',
                  onPressed: state.isValid ? _savePressed : null,
                ),
                SecondaryButton(
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
    return BlocListener<TaskBloc, TaskState>(
      listener: _blocListener,
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          print("state is $state");
          if (state is TaskState) {
            return buildForm(state);
          }
          throw "Unhandled state";
        },
      ),
    );
  }
}
