import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/grow/grow_bloc.dart';
import 'package:plantos/src/pages/grow/grow_page.dart';
import 'package:plantos/src/pages/grows/grows_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/widgets/hamburger.dart';
import 'package:plantos/src/widgets/new_button.dart';

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

  Future<void> _showNewGrowDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<GrowBloc>(
        create: (_) => GrowBloc(Grow.initial()),
        child: GrowPage(),
      ),
    );
  }

  Future<void> _handleEditGrow(Grow grow) async {
    print("edit grow");
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<GrowBloc>(
        create: (_) => GrowBloc(grow),
        child: GrowPage(),
      ),
    );
  }

  Widget _buildGrowRow(Grow grow) {
    return Padding(
      padding: EdgeInsets.only(bottom: 17),
      child: Container(
        padding: EdgeInsets.only(left: 28, right: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        height: 77,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grow.name,
                    style: TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text("Plot #${grow.plot}",
                      style: TextStyle(
                        fontFamily: "Work Sans",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleEditGrow(grow),
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

  void _blocListener(BuildContext context, GrowsState state) {
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
      body: BlocListener<GrowsBloc, GrowsState>(
        listener: (context, state) => _blocListener(context, state),
        child: BlocBuilder<GrowsBloc, GrowsState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: standardPagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Grows", style: titleStyle),
                    Expanded(
                      child: state.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: EdgeInsets.only(top: 22),
                              child: Column(
                                children: state.grows
                                    .map((grow) => _buildGrowRow(grow))
                                    .toList(),
                              ),
                            ),
                    ),
                    SizedBox(height: 30),
                    NewButton(
                      onPressed: () => _showNewGrowDialog(),
                      child: Text("New Grow"),
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
