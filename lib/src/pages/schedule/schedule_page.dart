import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/pages/task/task_bloc.dart';
import 'package:plantos/src/pages/task/task_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/dialog_form.dart';
import 'package:plantos/src/widgets/field_box.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';
import 'package:collection/collection.dart';
import 'package:sprintf/sprintf.dart';

import 'schedule_bloc.dart';

/// TODO: Documentation.
class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _startDayController = TextEditingController();

  Loading? _loading;

  late ScheduleBloc bloc;

  void _onTextFieldChanged() {
    bloc.add(ScheduleTextFieldChangedEvent(
      name: _nameController.text,
      startDay: _startDayController.text,
    ));
  }

  void _savePressed() {
    bloc.add(SchedulePressedEvent());
  }

  void _addTaskPressed() async {
    var result = await showDialog<Task>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<TaskBloc>(
        create: (_) => TaskBloc(null),
        child: TaskPage(),
      ),
    );
    if (result == null) {
      // User cancelled.
    } else {
      bloc.add(ScheduleAddTaskEvent(result));
    }
  }

  void _editTaskPressed(int index, Task t) async {
    var result = await showDialog<Task>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<TaskBloc>(
        create: (_) => TaskBloc(t),
        child: TaskPage(),
      ),
    );
    if (result == null) {
      // User cancelled.
    } else {
      bloc.add(ScheduleEditTaskEvent(result, index));
    }
  }

  void _deleteTaskPressed(int index) {
    bloc.add(ScheduleDeleteTaskEvent(index));
  }

  void _blocListener(BuildContext context, ScheduleState state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.isSuccess) {
      _loading?.close();
      Navigator.of(context).pop();
    } else if (state.error.isNotEmpty) {
      _loading?.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    } else if (state.isFetched) {
      _nameController.text = state.initial!.name;
      _startDayController.text = "${state.initial!.startDay}";

      // Trigger a text field changed event so the bloc has the same values as the text fields we've just filled.
      _onTextFieldChanged();
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ScheduleBloc>(context);
    bloc.add(ScheduleLoadedEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDayController.dispose();
    super.dispose();
  }

  Widget _buildTask(Task t, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("${sprintf("%02d:%02d", [t.hours, t.minutes])}"),
      SizedBox(width: 4),
      Text(t.action == "irrigation" ? "Irrigation" : "Fertigation"),
      SizedBox(width: 4),
      Text(t.ec > 0 ? "ec:${t.ec}" : ""),
      SizedBox(width: 4),
      Text("${t.duration}s"),
      Spacer(),
      Row(children: [
        GestureDetector(
          onTap: () => _editTaskPressed(index, t),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/edit.png", width: 23, height: 23),
          ),
        ),
        GestureDetector(
          onTap: () => _deleteTaskPressed(index),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
            child: Image.asset("assets/icon/bin.png", width: 23, height: 23),
          ),
        ),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: _blocListener,
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (_, state) => DialogForm(
          header: Text("New Schedule", style: dialogHeaderStyle),
          onPressedSave: state.isValid ? _savePressed : null,
          child: Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Column(
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
                  child: Text("Start Day", style: labelStyle),
                ),
                FieldBox(
                  child: FormTextField(
                    hintText: 'Start Day',
                    controller: _startDayController,
                    onChanged: _onTextFieldChanged,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 9),
                  child: Text("Tasks", style: labelStyle),
                ),
                state.tasks.isEmpty
                    ? Text(
                        "No tasks. Click Add Task to trigger irrigation or fertigation at a specific time of day.")
                    : Column(
                        children: state.tasks
                            .mapIndexed((i, t) => _buildTask(t, i))
                            .toList(),
                      ),
                SizedBox(height: 14),
                SecondaryButton(
                  text: '+ Add Task',
                  onPressed: state.tasks.length < 15 ? _addTaskPressed : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
