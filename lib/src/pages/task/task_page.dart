import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/dialog_form.dart';
import 'package:plantos/src/widgets/field_box.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

import 'task_bloc.dart';

/// TaskPage displays a form for adding a task to a schedule. This is a single
/// repeated action that is taken by the device at a specified time each day.
/// It's either an irrigation cycle or a fertigation cycle.
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

  String dropdownValue = 'irrigation';

  List<String> spinnerItems = [
    'irrigation',
    'fertigation',
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
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 9),
            child: Text("Hours (hour of day, 0-23)", style: labelStyle),
          ),
          FieldBox(
            child: FormTextField(
              hintText: 'Hours',
              controller: _hoursController,
              onChanged: _onTextFieldChanged,
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 9),
            child: Text("Minutes (0-59)", style: labelStyle),
          ),
          FieldBox(
            child: FormTextField(
              hintText: 'Minutes',
              controller: _minutesController,
              onChanged: _onTextFieldChanged,
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 9),
            child: Text("Action", style: labelStyle),
          ),
          FieldBox(
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Image.asset("assets/icon/arrow_down.png",
                      width: 12, height: 6),
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
              ),
            ),
          ),
          state.showEc
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("EC", style: labelStyle),
                  ),
                  FieldBox(
                    child: FormTextField(
                      hintText: 'EC',
                      controller: _ecController,
                      onChanged: _onTextFieldChanged,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ])
              : Container(),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 9),
            child: Text("Duration (seconds)", style: labelStyle),
          ),
          FieldBox(
            child: FormTextField(
              hintText: 'Duration',
              controller: _durationController,
              onChanged: _onTextFieldChanged,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: _blocListener,
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) => DialogForm(
          header: Text("New Task", style: dialogHeaderStyle),
          onPressedSave: state.isValid ? _savePressed : null,
          child: buildForm(state),
        ),
      ),
    );
  }
}
