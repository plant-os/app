import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/schedule.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/pages/schedule/schedule_bloc.dart';
import 'package:plantos/src/pages/schedule/schedule_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/widgets/card_element.dart';
import 'package:plantos/src/widgets/hamburger.dart';
import 'package:plantos/src/widgets/new_button.dart';

import 'program\_bloc.dart';

/// TODO: Documentation.
class ProgramPage extends StatefulWidget {
  const ProgramPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  late ProgramBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<ProgramBloc>(context);

    // Fetch the schedules.
    bloc.add(ProgramLoadEvent());
  }

  Future<void> _showCreateScheduleDialog(Program p) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(p.id, null, null),
        child: SchedulePage(),
      ),
    );
  }

  void _handleEditSchedule(Program p, Schedule s) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(p.id, s.id, s),
        child: SchedulePage(),
      ),
    );
  }

  void _handleDeleteSchedule(Program p, Schedule s) {
    bloc.add(ProgramDeleteScheduleEvent(s.id!));
  }

  Widget buildSchedule(Program p, Schedule s) {
    return CardElement(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.name),
            SizedBox(height: 4),
            Row(children: [
              Image.asset("assets/icon/clock.png", width: 10, height: 10),
              SizedBox(width: 4),
              Text(
                "Start day: ${s.startDay}",
                style: TextStyle(
                  color: Color(0xff9f9f9f),
                  fontSize: 13,
                  fontFamily: "Work Sans",
                  fontWeight: FontWeight.normal,
                ),
              )
            ]),
          ]),
      onEditPressed: () => _handleEditSchedule(p, s),
      onDeletePressed: () => _handleDeleteSchedule(p, s),
    );
  }

  Widget schedulesList(ProgramState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff28183d),
        ),
        title: Image.asset("assets/logo/withtext.png",
            width: 115.0, height: 27.14),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Program ${state.program.name}", style: titleStyle),
              SizedBox(height: 22),
              state.schedules.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 17),
                      child: Text(
                          "No schedules added for this program.\n\nClick New Schedule in order to add a schedule. You can add different schedules for each week the crop is growing to adjust the EC throughout the grow."),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.schedules
                              .map((e) => buildSchedule(state.program, e))
                              .toList(),
                        ),
                      ),
                    ),
              NewButton(
                onPressed: () async {
                  await _showCreateScheduleDialog(state.program);
                },
                child: Text("New Schedule"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramBloc, ProgramState>(
      builder: (context, state) {
        // TODO: Error handling.
        // TODO: Loading screen.
        return schedulesList(state, context);
      },
    );
  }
}
