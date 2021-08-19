import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/schedule_details/schedule_details_bloc.dart';
import 'package:plantos/src/pages/schedule_details/schedule_details_page.dart';

import 'program_details_bloc.dart';

class ProgramDetails extends StatefulWidget {
  const ProgramDetails({Key? key}) : super(key: key);

  @override
  _ProgramDetailsState createState() => _ProgramDetailsState();
}

class _ProgramDetailsState extends State<ProgramDetails> {
  late ProgramDetailsBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<ProgramDetailsBloc>(context);

    // Fetch the schedules.
    bloc.add(ProgramDetailsLoadEvent());
  }

  Future<void> _showMyDialog(Program p) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleDetailsBloc>(
          create: (_) => ScheduleDetailsBloc(p.id, null, null),
          child: ScheduleDetailsPage()),
    );
  }

  Widget loadingPage() {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }

  Widget errorPage(ProgramDetailsStateError state) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(state.error),
        ),
      ),
    );
  }

  void _handleEditSchedule(Program p, Schedule s) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleDetailsBloc>(
          create: (_) => ScheduleDetailsBloc(p.id, s.id, s),
          child: ScheduleDetailsPage()),
    );
  }

  void _handleDeleteSchedule(Program p, Schedule s) {
    bloc.add(ProgramDetailsDeleteScheduleEvent(s.id!));
  }

  Widget buildSchedule(Program p, Schedule s) {
    return Row(children: [
      Text(s.name),
      TextButton(
          child: Text("edit"), onPressed: () => _handleEditSchedule(p, s)),
      TextButton(
          child: Text("delete"), onPressed: () => _handleDeleteSchedule(p, s)),
    ]);
  }

  Widget schedulesList(ProgramDetailsStateDone state, BuildContext context) {
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
              child: Text("+ New Schedule"))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramDetailsBloc, ProgramDetailsState>(
      builder: (context, state) {
        if (state is ProgramDetailsStateDone) {
          print("ProgramDetailsStateDone");
          print(state);
          return schedulesList(state, context);
        } else if (state is ProgramDetailsStateLoading) {
          print("ProgramDetailsStateLoading");
          return loadingPage();
        } else if (state is ProgramDetailsStateError) {
          print("ProgramDetailsStateError");
          return errorPage(state);
        }
        throw "Unhandled state";
      },
    );
  }
}
