import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/program_details/program_details_bloc.dart';
import 'package:plantos/src/pages/program_details/program_details_page.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:provider/provider.dart';

import 'programs_bloc.dart';

class CreateProgramDialog extends StatefulWidget {
  final ProgramsService svc;

  const CreateProgramDialog({Key? key, required ProgramsService svc})
      : svc = svc,
        super(key: key);

  @override
  _CreateProgramDialogState createState() => _CreateProgramDialogState();
}

class _CreateProgramDialogState extends State<CreateProgramDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() {
    //   final String text = _controller.text;
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Program'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Name'),
            TextField(controller: _controller),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () async {
            print("Create program with name: ${_controller.text}");
            var ref = await widget.svc.add(_controller.text);

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => BlocProvider<ProgramDetailsBloc>(
                    create: (_) => ProgramDetailsBloc(ref.id, ref),
                    child: ProgramDetails())));
          },
        ),
      ],
    );
  }
}

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({Key? key}) : super(key: key);

  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  late ProgramsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ProgramsBloc>(context);
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

  Widget errorPage(ProgramsStateError state) {
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
            bloc.add(EditProgramEvent(p.id));

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => BlocProvider<ProgramDetailsBloc>(
                    create: (_) => ProgramDetailsBloc(p.id, p),
                    child: ProgramDetails())));
          }),
      TextButton(
          child: Text("delete"),
          onPressed: () {
            bloc.add(DeleteProgramEvent(p.id));
          }),
    ]);
  }

  Future<void> _showMyDialog() async {
    var svc = Provider.of<ProgramsService>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CreateProgramDialog(svc: svc);
      },
    );
  }

  Widget programsList(ProgramsStateDone state, BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        SingleChildScrollView(
          child: Column(
            children: state.programs.map((e) => buildProgram(e)).toList(),
          ),
        ),
        TextButton(
            onPressed: () async {
              bloc.add(NewProgramEvent());

              var result = await _showMyDialog();
            },
            child: Text("+ New Program"))
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramsBloc, ProgramsState>(
      builder: (context, state) {
        if (state is ProgramsStateDone) {
          return programsList(state, context);
        } else if (state is ProgramsStateLoading) {
          return loadingPage();
        } else if (state is ProgramsStateError) {
          return errorPage(state);
        }
        throw "Unhandled state";
      },
    );
  }
}
