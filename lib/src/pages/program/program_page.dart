import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/schedule/schedule_bloc.dart';
import 'package:plantos/src/pages/schedule/schedule_page.dart';

import 'program\_bloc.dart';

/// TODO: Documentation.
class ProgramPage extends StatefulWidget {
  const ProgramPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  late ProgramBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<ProgramBloc>(context);

    // Fetch the schedules.
    bloc.add(ProgramLoadEvent());
  }

  Future<void> _showMyDialog(Program p) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(p.id, null, null),
        child: SchedulePage(),
      ),
    );
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

  void _handleEditSchedule(Program p, Schedule s) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(p.id, s.id, s),
        child: SchedulePage(),
      ),
    );
  }

  void _handleDeleteSchedule(Program p, Schedule s) {
    bloc.add(ProgramDeleteScheduleEvent(s.id!));
  }

  Widget buildSchedule(Program p, Schedule s) {
    return Row(
      children: [
        Text(s.name),
        TextButton(
          child: Text("edit"),
          onPressed: () => _handleEditSchedule(p, s),
        ),
        TextButton(
          child: Text("delete"),
          onPressed: () => _handleDeleteSchedule(p, s),
        ),
      ],
    );
  }

  Widget schedulesList(ProgramState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: SafeArea(
        child: Column(children: [
          SingleChildScrollView(
            child: Column(
              children: state.schedules
                  .map((e) => buildSchedule(state.program, e))
                  .toList(),
            ),
          ),
          TextButton(
            onPressed: () async {
              var result = await _showMyDialog(state.program);
            },
            child: Text("+ New Schedule"),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramBloc, ProgramState>(
      builder: (context, state) {
        // TODO: Error handling.
        if (state.isLoading) {
          return loadingPage();
        }
        return schedulesList(state, context);
      },
    );
  }
}
