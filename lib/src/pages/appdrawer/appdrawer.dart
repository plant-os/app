import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appdrawer_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late AppDrawerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AppDrawerBloc>(context);
    _bloc.add(AppDrawerStartedEvent());
  }

  Future<void> _showErrorDialog(BuildContext context, String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _blocListener(BuildContext context, AppDrawerState state) async {
    if (state.error != "") {
      await _showErrorDialog(context, state.error);
      // Close the AppDrawer, we can't display the content anyway.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppDrawerBloc, AppDrawerState>(
      listener: (context, state) => _blocListener(context, state),
      child: BlocBuilder<AppDrawerBloc, AppDrawerState>(
        builder: (context, state) {
          print(state);
          if (state.isLoading) {
            return Container();
          } else if (state.isFetched) {
            return buildMenu(state, context);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildMenu(AppDrawerState state, BuildContext context) {
    const nameStyle = TextStyle(
        color: Color(0xFF28183D),
        fontSize: 18,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const emailStyle = TextStyle(
        color: Color(0x8028183d),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.normal);

    const menuTextStyle = TextStyle(
        color: Color(0xff938B9E),
        fontSize: 18,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 21, right: 21, top: 29),
          child: Column(
            children: [
              Row(children: [
                Center(
                  child: ClipOval(
                    child: Container(
                      width: 52,
                      height: 52,
                      color: Color(0xff1FAD84),
                    ),
                  ),
                ),
                SizedBox(width: 22),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.user!.name, style: nameStyle),
                      Text(state.user!.email, style: emailStyle)
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 19),
              Divider(
                color: Color(0xffEBEBEB),
              ),
              SizedBox(height: 19),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/grows", (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/grows.png",
                          width: 20, height: 20),
                      SizedBox(width: 18),
                      Text('Grows', style: menuTextStyle)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  // TODO
                  // Navigator.of(context).pushNamedAndRemoveUntil("/devices", (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/devices.png",
                          width: 20, height: 20),
                      SizedBox(width: 18),
                      Text('Devices', style: menuTextStyle)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/programs", (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/programs.png",
                          width: 20, height: 20),
                      SizedBox(width: 18),
                      Text('Programs', style: menuTextStyle)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil("/settings", (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/settings.png",
                          width: 20, height: 20),
                      SizedBox(width: 18),
                      Text('Settings', style: menuTextStyle)
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _bloc.add(AppDrawerPressLogoutEvent());

                  // Then close the drawer
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/logout.png",
                          width: 20, height: 20),
                      SizedBox(width: 18),
                      Text('Logout', style: menuTextStyle)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
