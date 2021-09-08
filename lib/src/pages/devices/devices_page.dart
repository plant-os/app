import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/device/device_bloc.dart';
import 'package:plantos/src/pages/device/device_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/hamburger.dart';
import 'package:sprintf/sprintf.dart';

import 'devices_bloc.dart';

/// [DevicesPage] renders the list of devices owned by the current user.
class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late DevicesBloc bloc;
  Loading? _loading;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<DevicesBloc>(context);
    bloc.add(DevicesInitialFetchEvent());
  }

  Future<void> _handleEditDevice(Device device) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeviceBloc>(
        create: (_) => DeviceBloc(device.id, device.deviceId),
        child: DevicePage(),
      ),
    );
  }

  Widget _buildDeviceRow(Device device) {
    return Padding(
      padding: EdgeInsets.only(bottom: 17),
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 28, right: 18, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        // height: 77,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.deviceZone,
                    style: TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    sprintf("EC : %0.2f", [device.state?.ec ?? 0]),
                    style: TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    sprintf(
                        "Humidity : %0.0f%%", [device.state?.humidity ?? 0]),
                    style: TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    sprintf("Temperature (air/water) : %0.1f / %0.1f", [
                      device.state?.temperature ?? 0,
                      device.state?.rtd ?? 0
                    ]),
                    style: TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleEditDevice(device),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset("assets/icon/ellipsis.png",
                      width: 14, height: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DevicesState state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.error.isNotEmpty) {
      _loading?.close();
      _loading = null;
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
      _loading = null;
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
      body: BlocListener<DevicesBloc, DevicesState>(
        listener: (context, state) => _blocListener(context, state),
        child: BlocBuilder<DevicesBloc, DevicesState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: standardPagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Devices", style: titleStyle),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 22),
                        child: Column(
                          children: state.devices
                              .map((grow) => _buildDeviceRow(grow))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
