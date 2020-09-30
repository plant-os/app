import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';

class CropsPage extends StatefulWidget {
  @override
  CropsPageState createState() => CropsPageState();
}

class CropsPageState extends State<CropsPage> {
  CropsBloc _cropsBloc;

  @override
  void initState() {
    super.initState();
    _cropsBloc = BlocProvider.of<CropsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
