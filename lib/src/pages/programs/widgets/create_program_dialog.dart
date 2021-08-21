import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/program/program_bloc.dart';
import 'package:plantos/src/pages/program/program_page.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

class CreateProgramDialog extends StatefulWidget {
  const CreateProgramDialog({Key? key}) : super(key: key);

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
            var authService = AuthService();
            var auth = await authService.getCurrentUser();
            var userService = UserService();
            var user = await userService.getCurrentUserDetails(auth!.email!);
            var programsService = ProgramsService();
            print("Create program with name: ${_controller.text}");
            var program =
                await programsService.add(user.company!.id, _controller.text);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider<ProgramBloc>(
                  create: (_) => ProgramBloc(program.id, program),
                  child: ProgramPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
