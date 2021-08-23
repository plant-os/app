import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/program/program_bloc.dart';
import 'package:plantos/src/pages/program/program_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/widgets/hamburger.dart';

import 'programs_bloc.dart';
import 'widgets/create_program_dialog.dart';

/// TODO: Documentation.
class ProgramsPage extends StatefulWidget {
  const ProgramsPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  late ProgramsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ProgramsBloc>(context);
    bloc.add(ProgramsInitialFetchEvent());
  }

  Widget loadingPage() {
    return SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildProgram(Program program) {
    return Row(children: [
      Text(program.name),
      TextButton(
        child: Text("edit"),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BlocProvider<ProgramBloc>(
            create: (_) => ProgramBloc(program.id, program),
            child: ProgramPage(),
          ),
        )),
      ),
      TextButton(
        child: Text("delete"),
        onPressed: () => bloc.add(ProgramsDeleteEvent(program.id)),
      ),
    ]);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => CreateProgramDialog(),
    );
  }

  Widget programsList(ProgramsState state, BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: standardPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Programs", style: titleStyle),
            SingleChildScrollView(
              child: Column(
                children: state.programs.map((e) => buildProgram(e)).toList(),
              ),
            ),
            TextButton(
              onPressed: () async {
                var result = await _showMyDialog();
              },
              child: Text("+ New Program"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("building ProgramsPage");
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: Hamburger(),
        ),
        title: Image.asset("assets/logo/withtext.png",
            width: 115.0, height: 27.14),
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context, state) {
          // TODO: Handle error in state.
          if (state.isLoading) {
            return loadingPage();
          } else {
            return programsList(state, context);
          }
        },
      ),
    );
  }
}
