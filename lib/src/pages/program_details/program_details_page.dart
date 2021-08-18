import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

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
    bloc.add(LoadProgramDetailsEvent());
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

  Widget errorPage(ProgramDetailsStateError state) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(state.error),
        ),
      ),
    );
  }

  Widget buildProgram(Program p) {
    return Row(children: [
      Text(p.name),
      TextButton(
          child: Text("edit"),
          onPressed: () {
            // TODO: Modal that edits the schedules.
          }),
      TextButton(child: Text("delete"), onPressed: () {}),
    ]);
  }

  Widget schedulesList(ProgramDetailsStateDone state, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: state.programs.map((e) => buildProgram(e)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramDetailsBloc, ProgramDetailsState>(
      builder: (context, state) {
        if (state is ProgramDetailsStateDone) {
          return schedulesList(state, context);
        } else if (state is ProgramDetailsStateLoading) {
          return loadingPage();
        } else if (state is ProgramDetailsStateError) {
          return errorPage(state);
        }
        throw "Unhandled state";
      },
    );
  }
}
