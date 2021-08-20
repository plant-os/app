import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/pages/edit_task/edit_task_bloc.dart';
import 'package:plantos/src/pages/edit_task/edit_task_page.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';
import 'package:collection/collection.dart';

import 'schedule_details_bloc.dart';

/// TODO: Documentation.
class ScheduleDetailsPage extends StatefulWidget {
  @override
  ScheduleDetailsPageState createState() => ScheduleDetailsPageState();
}

class ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _startDayController = TextEditingController();

  Loading? _loading;

  late ScheduleDetailsBloc bloc;

  void _onTextFieldChanged() {
    bloc.add(ScheduleDetailsTextFieldChangedEvent(
      name: _nameController.text,
      startDay: _startDayController.text,
    ));
  }

  void _savePressed() {
    bloc.add(ScheduleDetailsPressedEvent());
  }

  void _addTaskPressed() async {
    var result = await showDialog<Task>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<EditTaskBloc>(
        create: (_) => EditTaskBloc(null),
        child: EditTaskPage(),
      ),
    );
    if (result == null) {
      // User cancelled.
    } else {
      bloc.add(ScheduleDetailsAddTaskEvent(result));
    }
  }

  void _editTaskPressed(int index, Task t) async {
    var result = await showDialog<Task>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<EditTaskBloc>(
        create: (_) => EditTaskBloc(t),
        child: EditTaskPage(),
      ),
    );
    if (result == null) {
      // User cancelled.
    } else {
      bloc.add(ScheduleDetailsEditTaskEvent(result, index));
    }
  }

  void _deleteTaskPressed(int index) {
    bloc.add(ScheduleDetailsDeleteTaskEvent(index));
  }

  void _blocListener(BuildContext context, ScheduleDetailsState state) {
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
    bloc = BlocProvider.of<ScheduleDetailsBloc>(context);
    bloc.add(ScheduleDetailsLoadedEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDayController.dispose();
    super.dispose();
  }

  Widget _buildTask(Task t, int index) {
    return Row(children: [
      Text("${t.hours}:${t.minutes}"),
      Text("${t.action}"),
      Text("${t.ec}"),
      Text("${t.duration}"),
      SizedBox(
        height: 50,
        child: FormButton(
          text: 'Edit',
          onPressed: () => _editTaskPressed(index, t),
        ),
      ),
      SizedBox(
        height: 50,
        child: FormButton(
          text: 'Delete',
          onPressed: () => _deleteTaskPressed(index),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          body: BlocListener<ScheduleDetailsBloc, ScheduleDetailsState>(
            listener: _blocListener,
            child: BlocBuilder<ScheduleDetailsBloc, ScheduleDetailsState>(
              builder: (_, state) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Schedule"),
                      FormTextField(
                        hintText: 'Name',
                        controller: _nameController,
                        onChanged: _onTextFieldChanged,
                        keyboardType: TextInputType.text,
                      ),
                      FormTextField(
                        hintText: 'Start Day',
                        controller: _startDayController,
                        onChanged: _onTextFieldChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Column(
                        children: state.tasks
                            .mapIndexed((i, t) => _buildTask(t, i))
                            .toList(),
                      ),
                      FormButton(
                        text: 'Add Task',
                        onPressed: _addTaskPressed,
                      ),
                      FormButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop()),
                      FormButton(
                        text: 'Save',
                        onPressed: state.isValid ? _savePressed : null,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
