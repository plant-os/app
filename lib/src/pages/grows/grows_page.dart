import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/grows/grows_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/widgets/hamburger.dart';

/// [GrowsPage] renders the list of crops that are currently being grown. This
/// list of crops is used to control the device settings and is how the
/// schedules are applied to devices.
class GrowsPage extends StatefulWidget {
  const GrowsPage({Key? key}) : super(key: key);

  @override
  _GrowsPageState createState() => _GrowsPageState();
}

class _GrowsPageState extends State<GrowsPage> {
  late GrowsBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<GrowsBloc>(context);
    bloc.add(GrowsInitialFetchEvent());
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
      body: BlocBuilder<GrowsBloc, GrowsState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: standardPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grows", style: titleStyle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
