import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/dialog_form.dart';
import 'package:plantos/src/widgets/form_button.dart';

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

  Future<void> _showError(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      _showError(state.error);
    }
  }

  Widget _buildState(BuildContext context, DeviceState state) {
    if (state.device?.state == null) {
      return Text("no device state information");
    }

    DeviceStateModel s = state.device!.state!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("A empty : " + (!s.i0 ? "true" : "false")),
              Text("B empty : " + (!s.i1 ? "true" : "false")),
              Text("MT full : " + (s.i2 ? "true" : "false")),
              Text("MT empty : " + (!s.i3 ? "true" : "false")),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("pressure pump : " + (s.o0 ? "on" : "off")),
              Text("dosing A : " + (s.o1 ? "on" : "off")),
              Text("dosing B : " + (s.o2 ? "on" : "off")),
              Text("PB egress : " + (s.o3 ? "open" : "closed")),
              Text("PA egress : " + (s.o4 ? "open" : "closed")),
              Text("MT ingress : " + (s.o5 ? "open" : "closed")),
              Text("MT egress : " + (s.o6 ? "open" : "closed")),
              Text("water egress : " + (s.o7 ? "open" : "closed")),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDebugActions(BuildContext context, DeviceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "Centrifugal Pump on",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_p1_on")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "Centrifugal Pump off",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_p1_off")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "dosing pump 1 on",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_d1_on")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "dosing pump 1 off",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_d1_off")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "dosing pump 2 on",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_d2_on")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "dosing pump 2 off",
              onPressed: () => bloc.add(DevicePressedCommandEvent("qc_d2_off")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v5 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v5_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v5 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v5_close")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v4 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v4_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v4 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v4_close")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v3 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v3_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v3 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v3_close")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v2 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v2_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v2 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v2_close")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v1 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v1_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v1 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v1_close")),
            ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "v0 open",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v0_open")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "v0 closed",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_v0_close")),
            ))
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, DeviceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "Irrigation A",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_irrigation_a")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "Irrigation B",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_irrigation_b")),
            ))
          ],
        ), // irr a, b
        SizedBox(height: 5),
        PrimaryButton(
          text: "Fill Tank",
          onPressed: () => bloc.add(DevicePressedCommandEvent("qc_fill_tank")),
        ), // filling
        SizedBox(height: 5),
        PrimaryButton(
          text: "Mix",
          onPressed: () => bloc.add(DevicePressedCommandEvent("qc_mixing")),
        ), // mixing
        SizedBox(height: 5),
        PrimaryButton(
          text: "Dose",
          onPressed: () => bloc.add(DevicePressedCommandEvent("qc_dose")),
        ), // dosing
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: PrimaryButton(
              text: "Fertigation A",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_fertigation_a")),
            )),
            SizedBox(width: 7),
            Expanded(
                child: PrimaryButton(
              text: "Fertigation B",
              onPressed: () =>
                  bloc.add(DevicePressedCommandEvent("qc_fertigation_b")),
            ))
          ],
        ), // irr a, b
        SizedBox(height: 5),
        PrimaryButton(
          text: "Stop",
          onPressed: () => bloc.add(DevicePressedCommandEvent("qc_off")),
        ), // stop
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceBloc, DeviceState>(
      listener: _blocListener,
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          print("state is $state");
          return DialogForm(
            header:
                Text(state.device?.deviceZone ?? "", style: dialogHeaderStyle),
            onPressedSave: () {},
            isValid: true,
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("State", style: labelStyle),
                  ),
                  _buildState(context, state),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 9),
                    child: Text("Actions", style: labelStyle),
                  ),
                  _buildActions(context, state),
                  _buildDebugActions(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
