import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer.dart';
import 'package:plantos/src/pages/grow/grow_bloc.dart';
import 'package:plantos/src/pages/grow/grow_page.dart';
import 'package:plantos/src/pages/grows/grows_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
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
  Loading? _loading;

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
    return Row(
      children: [
        Text(grow.name),
        TextButton(
          child: Text("edit"),
          onPressed: () => _handleEditGrow(grow),
        ),
      ],
    );
  }

  void _blocListener(BuildContext context, GrowsState state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.error.isNotEmpty) {
      _loading?.close();
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.grows
                              .map((grow) => _buildGrowRow(grow))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextButton(
                      onPressed: () => _showNewGrowDialog(),
                      child: Text("+ New Grow"),
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
