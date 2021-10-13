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

  String mapStateEnumToText(int state) {
    switch (state) {
      case 0:
        return "Inactive";
      case 1:
        return "Filling";
      case 2:
        return "Mixing";
      case 3:
        return "Fertigation";
      case 4:
        return "Fertigation";
      case 5:
        return "Irrigation";
      case 6:
        return "Irrigation";
      default:
        return "Unknown";
    }
  }

  Widget _buildDeviceRow(DevicesState state, Device device) {
    var lastSeenSecondsAgo =
        state.now.difference(device.latestUpdateTime.toDate()).inSeconds;
    print("lastSeenSecondsAgo is $lastSeenSecondsAgo");

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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          device.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Work Sans",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      lastSeenSecondsAgo > 30
                          ? Image.asset("assets/icon/offline.png",
                              width: 56, height: 17)
                          : Image.asset("assets/icon/online.png",
                              width: 51, height: 17),
                    ],
                  ),
                  // SizedBox(height: 7),
                  Row(
                    children: [
                      Image.asset("assets/icon/transmit.png",
                          width: 15, height: 10),
                      SizedBox(width: 7),
                      Text(
                        device.registryId,
                        style: TextStyle(
                          color: Color(0xFF1FAD84),
                          fontFamily: "Work Sans",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("•",
                            style: TextStyle(
                              color: Color(0xFFC4C4C4),
                            )),
                      ),
                      Text(
                        mapStateEnumToText(device.state?.state ?? 0),
                        style: TextStyle(
                          color: Color(0xFF9F9F9F),
                          fontFamily: "Work Sans",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
            print(state);
            return SafeArea(
              child: Padding(
                padding: standardPagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Devices", style: titleStyle),
                    Expanded(
                      child: state.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: EdgeInsets.only(top: 22),
                              child: Column(
                                children: state.devices
                                    .map((grow) => _buildDeviceRow(state, grow))
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
