import 'package:flutter/material.dart';
import 'package:plantos/src/services/programs_service.dart';

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
