import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/dialog_form.dart';

import 'device_bloc.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({
    Key? key,
  }) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Loading? _loading;

  late DeviceBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<DeviceBloc>(context);
    bloc.add(DeviceStartedEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _blocListener(BuildContext context, DeviceState state) {
    if (state.isLoading) {
      print("creating loading dialog widget");
      _loading = Loading(context);
    } else if (!state.isLoading && _loading != null) {
      print("cancelling loading dialog widget");
      _loading?.close();
      _loading = null;
    }

    if (state.error.isNotEmpty) {
      print("showing error message: ${state.error}");
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          state.error,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceBloc, DeviceState>(
      listener: _blocListener,
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          print("state is $state");
          return DialogForm(
            header: Text("New Device", style: dialogHeaderStyle),
            onPressedSave: () {},
            isValid: true,
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
