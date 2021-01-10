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

  void _addSchedulePressed(EditScheduleState state) {
    Navigator.pop(context, state.schedule);
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

  Widget buildDayRow(String day, bool indicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Every $day",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        CircleAvatar(
          backgroundColor: indicator ? blueColor : greyColor,
          radius: 20,
          child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.done),
              color: Colors.white,
              iconSize: 20,
              onPressed: () => bloc.add(ToggleRepeatEvent(day))),
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
            value: bloc,
            listener: _blocListener,
            child: BlocBuilder<EditScheduleBloc, EditScheduleState>(
                value: bloc,
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
                                      DateFormat.jm()
                                          .format(state.schedule.time.toDate()),
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
                                buildDayRow(
                                    "Monday", state.schedule.repeat.monday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow(
                                    "Tuesday", state.schedule.repeat.tuesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow("Wednesday",
                                    state.schedule.repeat.wednesday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow(
                                    "Thursday", state.schedule.repeat.thursday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow(
                                    "Friday", state.schedule.repeat.friday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow(
                                    "Saturday", state.schedule.repeat.saturday),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildDayRow(
                                    "Sunday", state.schedule.repeat.sunday),
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
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text("Save",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor)),
                              onPressed: state.isValid
                                  ? () {
                                      if (state.isValid) {
                                        _addSchedulePressed(state);
                                      } else {
                                        print("invalid");
                                      }
                                    }
                                  : null,
                            )
                          ]),
                        ),
                      ),
                    )))));
  }
}
