import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/edit_schedule/edit_schedule_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditSchedulePage extends StatefulWidget {
  final Schedule _initialSchedule;

  EditSchedulePage(this._initialSchedule);

  @override
  EditSchedulePageState createState() => EditSchedulePageState();
}

class EditSchedulePageState extends State<EditSchedulePage> {
  Loading _loading;
  EditScheduleBloc bloc;

  // void _onScheduleFieldChanged() {
  //   bloc.add(EditScheduleFieldChangedEvent(schedule: widget.schedule));
  // }

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

  void _addSchedulePressed() {
    Navigator.pop(context, bloc.state.schedule);
  }

  @override
  void initState() {
    super.initState();
    bloc = new EditScheduleBloc(widget._initialSchedule);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget toggleButtons(EditScheduleState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
            onPressed: () => bloc.add(SetActionEvent(false)),
            child: Text(
              "Irrigation",
              style: TextStyle(color: whiteColor),
            ),
            color: state.schedule.action.irrigation ? blueColor : greyColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        SizedBox(
          width: 20.0,
        ),
        RaisedButton(
          onPressed: () => bloc.add(SetActionEvent(true)),
          child: Text(
            "Fertigation",
            style: TextStyle(color: whiteColor),
          ),
          color: state.schedule.action.fertigation ? blueColor : greyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ],
    );
  }

  void toggleRepeat(String day) {
    if (day == "Monday") {
      widget.schedule.repeat.monday = !widget.schedule.repeat.monday;
    } else if (day == "Tuesday") {
      widget.schedule.repeat.tuesday = !widget.schedule.repeat.tuesday;
    } else if (day == "Wednesday") {
      widget.schedule.repeat.wednesday = !widget.schedule.repeat.wednesday;
    } else if (day == "Thursday") {
      widget.schedule.repeat.thursday = !widget.schedule.repeat.thursday;
    } else if (day == "Friday") {
      widget.schedule.repeat.friday = !widget.schedule.repeat.friday;
    } else if (day == "Saturday") {
      widget.schedule.repeat.saturday = !widget.schedule.repeat.saturday;
    } else if (day == "Sunday") {
      widget.schedule.repeat.sunday = !widget.schedule.repeat.sunday;
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
        backgroundColor: whiteColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: blackColor,
          ),
          title: Text(
            "Schedule",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: blackColor),
          ),
          backgroundColor: whiteColor,
        ),
        body: BlocListener<EditScheduleBloc, EditScheduleState>(
            listener: _blocListener,
            child: BlocBuilder<EditScheduleBloc, EditScheduleState>(
                builder: (_, state) => SafeArea(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30, top: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(children: [
                            toggleButtons(state),
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
                                      TimeOfDay selectedTime =
                                          await showTimePicker(
                                        initialTime: TimeOfDay.fromDateTime(
                                            state.schedule.time.toDate()),
                                        context: context,
                                      );
                                      // showTimePicker returns null if the user cancels the dialog.
                                      if (selectedTime != null) {
                                        bloc.add(EditTimeEvent(selectedTime));
                                      }
                                    },
                                    color: whiteColor,
                                    child: Text(
                                      DateFormat.jm().format(
                                          widget.schedule.time.toDate()),
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
                                repeatMaker(
                                    "Monday", widget.schedule.repeat.monday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Tuesday", widget.schedule.repeat.tuesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker("Wednesday",
                                    widget.schedule.repeat.wednesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker("Thursday",
                                    widget.schedule.repeat.thursday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Friday", widget.schedule.repeat.friday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker("Saturday",
                                    widget.schedule.repeat.saturday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                repeatMaker(
                                    "Sunday", widget.schedule.repeat.sunday),
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
                                text: 'Save',
                                onPressed:
                                    state.isValid ? _addSchedulePressed : null),
                            SizedBox(height: 20),
                          ]),
                        ),
                      ),
                    )))));
  }
}
