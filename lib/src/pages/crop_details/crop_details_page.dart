import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/crop_details/crop_details.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop_bloc.dart';
import 'package:plantos/src/themes/colors.dart';

class CropDetailsPage extends StatefulWidget {
  final Crop crop;
  CropDetailsPage(this.crop);

  @override
  CropDetailsPageState createState() => CropDetailsPageState();
}

class CropDetailsPageState extends State<CropDetailsPage> {
  CropDetailsBloc cropDetailsBloc;

  @override
  void initState() {
    super.initState();
    cropDetailsBloc = BlocProvider.of<CropDetailsBloc>(context);
  }

  @override
  void dispose() {
    cropDetailsBloc.close();
    super.dispose();
  }

  void _changeActionStatusPressed(ActionRepeat action) {
    cropDetailsBloc.add(ClickChangeActionStatusEvent(action: action));
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

  Widget repeatsBuilder(Schedule schedule) {
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
    return SizedBox(
      width: 120,
      child: Text(days,
          style: TextStyle(
            color: whiteColor,
          ),
          overflow: TextOverflow.ellipsis),
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
                  width: 70,
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
                            onTap: () {
                              _changeActionStatusPressed(action);
                            },
                            child: CircleAvatar(
                              backgroundColor: blueColor,
                              radius: 20,
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              "Cancelled",
                              style: TextStyle(fontSize: 15, color: blackColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                _changeActionStatusPressed(action);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 20,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 30,
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

  Widget scheduleBuilder(Schedule schedule) {
    return Column(
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: blueColor,
                        border: Border.all(
                          color: blueColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          schedule.action.fertigation == true
                              ? Text(
                                  "Fertigation",
                                  style: TextStyle(color: whiteColor),
                                )
                              : Text("Irrigation",
                                  style: TextStyle(color: whiteColor)),
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
                      ),
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

  Widget loadingPage() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropDetailsBloc, CropDetailsState>(
      builder: (context, state) {
        if (state is CropDetailsStateDone) {
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: blackColor,
              ),
              backgroundColor: whiteColor,
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
                      padding: const EdgeInsets.only(top: 200.0),
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.crop.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: blackColor,
                                      ),
                                      onPressed: () async {
                                        var updatedCrop = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<EditCropBloc>(
                                              create: (_) => EditCropBloc(
                                                  cropDetailsBloc.cropsService,
                                                  cropDetailsBloc.authService,
                                                  cropDetailsBloc.userService),
                                              child: EditCropPage(widget.crop),
                                            ),
                                          ),
                                        );
                                        if (updatedCrop != null) {
                                          cropDetailsBloc
                                              .generateActionRepeats();
                                          setState(() {});
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        widget.crop.ec,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: blackColor),
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
                                        convertDate(widget.crop.startDate),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: blackColor),
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
                                        cropStateIndicator(
                                            widget.crop.cropState),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: blackColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Schedule",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: blackColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: widget.crop.schedules
                                    .map(
                                        (schedule) => scheduleBuilder(schedule))
                                    .toList(),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Upcoming Actions",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: blackColor),
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
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return loadingPage();
        }
      },
    );
  }
}
