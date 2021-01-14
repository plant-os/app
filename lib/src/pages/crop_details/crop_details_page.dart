import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop_page.dart';
import 'package:plantos/src/themes/colors.dart';

import 'crop_details_bloc.dart';

/// CropDetailsPage is a widget that displays the settings, schedules and
/// upcoming actions for a particular crop.
class CropDetailsPage extends StatefulWidget {
  @override
  CropDetailsPageState createState() => CropDetailsPageState();
}

class CropDetailsPageState extends State<CropDetailsPage> {
  CropDetailsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CropDetailsBloc>(context);
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  String convertDate(Timestamp startDateTimestamp) {
    DateTime startDate = startDateTimestamp.toDate();
    var formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    return formattedStartDate;
  }

  String cropStateIndicator(CropState state) {
    if (state.vegetative) {
      return "Vegetative";
    } else if (state.budding) {
      return "Budding";
    } else if (state.flowering) {
      return "Flowering";
    } else if (state.harvested) {
      return "Harvested";
    } else if (state.ripening) {
      return "Ripening";
    }
    return "Not Specified";
  }

  static Widget repeatsBuilder(Schedule schedule) {
    String days = "";
    if (schedule.repeat.monday == true) {
      days = days + "Mon ";
    }
    if (schedule.repeat.tuesday == true) {
      days = days + "Tue ";
    }
    if (schedule.repeat.wednesday == true) {
      days = days + "Wed ";
    }
    if (schedule.repeat.thursday == true) {
      days = days + "Thur ";
    }
    if (schedule.repeat.friday == true) {
      days = days + "Fri ";
    }
    if (schedule.repeat.saturday == true) {
      days = days + "Sat ";
    }
    if (schedule.repeat.sunday == true) {
      days = days + "Sun";
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Center(
          child: Text(
        days,
        style: TextStyle(
          color: whiteColor,
        ),
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

  Widget upcomingActionsBuilder(List<ActionRepeat> actionRepeats) {
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return Column(
      children: actionRepeats.map(
        (action) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    action.action,
                    style: TextStyle(fontSize: 15, color: blackColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  f.format(action.time.toDate()),
                  style: TextStyle(fontSize: 15, color: blackColor),
                ),
                action.canceled == false
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () => bloc.add(
                                ClickChangeActionStatusEvent(action: action)),
                            child: CircleAvatar(
                              backgroundColor: blueColor,
                              radius: 16,
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            "Cancelled",
                            style: TextStyle(fontSize: 15, color: blackColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () => bloc.add(
                                  ClickChangeActionStatusEvent(action: action)),
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 16,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  Widget buildSchedule(Schedule schedule) {
    var content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          schedule.action.fertigation ? "Fertigation" : "Irrigation",
          style: TextStyle(color: whiteColor),
        ),
        Expanded(child: repeatsBuilder(schedule)),
        Row(
          children: [
            Text(
              DateFormat.jm().format(schedule.time.toDate()),
              style: TextStyle(color: whiteColor),
            ),
          ],
        ),
      ],
    );

    return Column(
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: blueColor,
                        border: Border.all(
                          color: blueColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: content,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox.fromSize(size: Size.fromHeight(10.0)),
      ],
    );
  }

  Widget buildCropSheet(LoadedState state) {
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          state.crop.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        IconButton(
            icon: Icon(
              Icons.edit,
              color: blackColor,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCropPage(bloc.cropsService,
                      bloc.authService, bloc.userService, state.crop),
                ),
              );
            }),
      ],
    );

    var overview = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "EC",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              state.crop.ec,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: blackColor),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Start Date",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              convertDate(state.crop.startDate),
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: blackColor),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "State",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              cropStateIndicator(state.crop.cropState),
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: blackColor),
            ),
          ],
        )
      ],
    );

    var schedules = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Schedules",
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: blackColor),
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Column(
        children: state.crop.schedules
            .map((schedule) => buildSchedule(schedule))
            .toList(),
      )
    ]);

    var actions = Column(children: [
      Row(
        children: [
          Text(
            "Upcoming Actions",
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: blackColor),
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      state.actionRepeats.length > 0
          ? upcomingActionsBuilder(state.actionRepeats)
          : Center(
              child: CircularProgressIndicator(),
            )
    ]);

    return Column(
      children: [
        header,
        SizedBox(
          height: 30,
        ),
        overview,
        SizedBox(
          height: 30,
        ),
        schedules,
        SizedBox(
          height: 30,
        ),
        actions,
      ],
    );
  }

  Widget buildLoadingState(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildLoadedState(BuildContext context, LoadedState state) {
    return Scaffold(
      // backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: blackColor,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/crop.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: whiteColor,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: buildCropSheet(state),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropDetailsBloc, CropDetailsState>(
      builder: (context, state) {
        if (state is LoadedState) {
          return buildLoadedState(context, state);
        } else if (state is LoadingState) {
          return buildLoadingState(context);
        } else {
          throw Exception("unhandled state");
        }
      },
    );
  }
}
