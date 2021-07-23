import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/add_schedule/add_schedule.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  AddSchedulePageState createState() => AddSchedulePageState();
}

class AddSchedulePageState extends State<AddSchedulePage> {
  Schedule schedule = Schedule(Timestamp.now(), CropAction(false, false),
      Repeat(false, false, false, false, false, false, false));
  late Loading _loading;
  late AddScheduleBloc bloc;

  void _onScheduleFieldChanged() {
    bloc.add(ScheduleFieldChangedEvent(schedule));
  }

  void _blocListener(context, state) {
    if (state.isLoading)
      _loading = Loading(context);
    else if (state.isSuccess) {
      _loading.close();
    } else if (state.error.isNotEmpty) {
      _loading.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    }
  }

  void _addSchedulePressed(AddScheduleState state) {
    Navigator.pop(context, state.schedule);
  }

  void toggle(String action) {
    if (action == "irrigation") {
      schedule.action?.irrigation = true;
      schedule.action?.fertigation = false;
    } else if (action == "fertigation") {
      schedule.action?.fertigation = true;
      schedule.action?.irrigation = false;
    }
    _onScheduleFieldChanged();
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AddScheduleBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget toggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
            onPressed: () {
              toggle("irrigation");
              setState(() {});
            },
            child: Text(
              "Irrigation",
              style: TextStyle(color: whiteColor),
            ),
            color: schedule.action?.irrigation == true ? blueColor : greyColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        SizedBox(
          width: 20.0,
        ),
        RaisedButton(
          onPressed: () {
            toggle("fertigation");
            setState(() {});
          },
          child: Text(
            "Fertigation",
            style: TextStyle(color: whiteColor),
          ),
          color: schedule.action?.fertigation == true ? blueColor : greyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ],
    );
  }

  void toggleRepeat(String day) {
    if (day == "Monday") {
      schedule.repeat!.monday = !schedule.repeat!.monday;
    } else if (day == "Tuesday") {
      schedule.repeat!.tuesday = !schedule.repeat!.tuesday;
    } else if (day == "Wednesday") {
      schedule.repeat!.wednesday = !schedule.repeat!.wednesday;
    } else if (day == "Thursday") {
      schedule.repeat!.thursday = !schedule.repeat!.thursday;
    } else if (day == "Friday") {
      schedule.repeat!.friday = !schedule.repeat!.friday;
    } else if (day == "Saturday") {
      schedule.repeat!.saturday = !schedule.repeat!.saturday;
    } else if (day == "Sunday") {
      schedule.repeat!.sunday = !schedule.repeat!.sunday;
    }
    setState(() {});
    _onScheduleFieldChanged();
  }

  Widget repeatMaker(String day, bool indicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(builder: (context) {
          if (day == "Monday") {
            return Text(
              "Every Monday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Tuesday") {
            return Text(
              "Every Tuesday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Wednesday") {
            return Text(
              "Every Wednesday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Thursday") {
            return Text(
              "Every Thursday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Friday") {
            return Text(
              "Every Friday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Saturday") {
            return Text(
              "Every Saturday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else if (day == "Sunday") {
            return Text(
              "Every Sunday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            );
          } else {
            return Container();
          }
        }),
        CircleAvatar(
          backgroundColor: indicator == true ? blueColor : greyColor,
          radius: 20,
          child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.done),
              color: Colors.white,
              iconSize: 20,
              onPressed: () {
                toggleRepeat(day);
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // iconTheme: IconThemeData(
          //   color: blackColor,
          // ),
          title: Text(
            "Schedule",
            // style: TextStyle(
            //     fontWeight: FontWeight.bold, fontSize: 20, color: blackColor),
          ),
          // backgroundColor: whiteColor,
        ),
        body: BlocListener<AddScheduleBloc, AddScheduleState>(
            listener: _blocListener,
            child: BlocBuilder<AddScheduleBloc, AddScheduleState>(
                builder: (_, state) => SafeArea(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30, top: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(children: [
                            toggleButtons(),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      TimeOfDay? selectedTime =
                                          await showTimePicker(
                                        initialTime: TimeOfDay.fromDateTime(
                                            state.schedule!.time!.toDate()),
                                        context: context,
                                      );
                                      // showTimePicker returns null if the user cancels the dialog.
                                      if (selectedTime != null) {
                                        bloc.add(EditTimeEvent(selectedTime));
                                      }
                                    },
                                    color: whiteColor,
                                    child: Text(
                                      DateFormat.jm()
                                          .format(schedule.time!.toDate()),
                                      style: TextStyle(
                                          color: blueColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: blueColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox.fromSize(size: Size.fromHeight(40.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                repeatMaker("Monday", schedule.repeat!.monday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Tuesday", schedule.repeat!.tuesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Wednesday", schedule.repeat!.wednesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Thursday", schedule.repeat!.thursday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker("Friday", schedule.repeat!.friday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Saturday", schedule.repeat!.saturday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker("Sunday", schedule.repeat!.sunday),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            SizedBox.fromSize(
                              size: Size.fromHeight(25.0),
                            ),
                            SizedBox.fromSize(
                              size: Size.fromHeight(25.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox.fromSize(
                                  size: Size.fromHeight(15.0),
                                ),
                              ],
                            ),
                            SizedBox.fromSize(
                              size: Size.fromHeight(25.0),
                            ),
                            FormButton(
                                text: 'Add Schedule',
                                onPressed: () {
                                  if (state.isValid) {
                                    _addSchedulePressed(state);
                                  }
                                }),
                            SizedBox(height: 20),
                          ]),
                        ),
                      ),
                    )))));
  }
}
