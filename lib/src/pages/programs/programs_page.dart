import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/program/program_bloc.dart';
import 'package:plantos/src/pages/program/program_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/card_element.dart';
import 'package:plantos/src/widgets/hamburger.dart';
import 'package:plantos/src/widgets/new_button.dart';

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
  Loading? _loading;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ProgramsBloc>(context);
    bloc.add(ProgramsInitialFetchEvent());
  }

  void _editProgramPressed(Program program) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider<ProgramBloc>(
        create: (_) => ProgramBloc(program.id, program),
        child: ProgramPage(),
      ),
    ));
  }

  void _deleteProgramPressed(Program program) {
    bloc.add(ProgramsDeleteEvent(program.id));
  }

  Widget buildProgram(Program program) {
    return CardElement(
      child: Text(program.name),
      onEditPressed: () => _editProgramPressed(program),
      onDeletePressed: () => _deleteProgramPressed(program),
    );
  }

  Future<void> _showCreateProgramDialog() async {
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 22),
                child: Column(
                  children: state.programs.map((e) => buildProgram(e)).toList(),
                ),
              ),
            ),
            NewButton(
              child: Text("New Program"),
              onPressed: _showCreateProgramDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ProgramsState state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.error.isNotEmpty) {
      _loading?.close();
      print("showing error message: ${state.error}");
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          state.error,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ));
    } else {
      _loading?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<ProgramsBloc, ProgramsState>(
        listener: (context, state) => _blocListener(context, state),
        child: BlocBuilder<ProgramsBloc, ProgramsState>(
          builder: (context, state) {
            return programsList(state, context);
          },
        ),
      ),
    );
  }
}
