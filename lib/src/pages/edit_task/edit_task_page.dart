import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_task_bloc.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late EditTaskBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<EditTaskBloc>(context);
  }

  Widget loadingPage() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        if (state is EditTaskState) {
          return Container();
        }
        throw "Unhandled state";
      },
    );
  }
}
