import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/pages/crop_details/crop_details_page.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop_bloc.dart';
import 'package:plantos/src/pages/edit_schedule/edit_schedule_page.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

/// EditCropPage is a widget that provides the functionality for editing crop
/// information.
class EditCropPage extends StatefulWidget {
  final Crop? initialCrop;

  EditCropPage(this.initialCrop);

  @override
  EditCropPageState createState() => EditCropPageState();
}

class EditCropPageState extends State<EditCropPage> {
  late EditCropBloc bloc;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ecController = TextEditingController();
  Loading? _loading;

  @override
  void initState() {
    super.initState();
    bloc = new EditCropBloc(widget.initialCrop);

    if (widget.initialCrop != null) {
      _nameController.text = widget.initialCrop!.name!;
      _ecController.text = widget.initialCrop!.ec!;
    }

    _nameController.addListener(() {
      bloc.add(ChangeNameEvent(_nameController.text));
    });

    _ecController.addListener(() {
      bloc.add(ChangeEcEvent(_ecController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ecController.dispose();
    bloc.dispose();
    super.dispose();
  }

  String cropStateToString(CropState state) {
    if (state.budding == true) {
      return "Budding";
    } else if (state.vegetative == true) {
      return "Vegetative";
    } else if (state.flowering == true) {
      return "Flowering";
    } else if (state.ripening == true) {
      return "Ripening";
    } else if (state.harvested == true) {
      return "Harvested";
    } else {
      return "Vegetative";
    }
  }

  void _blocListener(BuildContext context, EditCropState state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.isSuccess) {
      _loading?.close();
      SnackbarWithColor(
          color: greenColor,
          context: context,
          text: 'Crop was successfully edited.');
      Navigator.pop(context, state.crop);
    } else if (state.error.isNotEmpty) {
      _loading?.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    }
  }

  void _selectDate(BuildContext context, EditCropState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.crop.startDate == null
          ? DateTime.now()
          : state.crop.startDate!.toDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      bloc.add(SetStartDateEvent(picked));
    }
  }

  Widget scheduleBuilder(int index, Schedule schedule) {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              var updatedSchedule = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditSchedulePage(schedule),
                  ));
              if (updatedSchedule != null) {
                bloc.add(ChangeScheduleEvent(index, updatedSchedule));
              }
            },
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: blueColor,
                            border: Border.all(
                              color: blueColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              schedule.action!.fertigation == true
                                  ? Text(
                                      "Fertigation",
                                      style: TextStyle(color: whiteColor),
                                    )
                                  : Text("Irrigation",
                                      style: TextStyle(color: whiteColor)),
                              CropDetailsPageState.repeatsBuilder(schedule),
                              Row(
                                children: [
                                  Text(
                                    DateFormat.jm()
                                        .format(schedule.time!.toDate()),
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
                Positioned(
                  child: GestureDetector(
                    onTap: () => bloc.add(RemoveScheduleEvent(index)),
                    child: Icon(
                      Icons.cancel,
                      size: 18,
                      color: whiteColor,
                    ),
                  ),
                  top: 3,
                  right: 6,
                )
              ],
            )),
        SizedBox.fromSize(size: Size.fromHeight(10.0)),
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
          "Edit Crop",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: blackColor),
        ),
        backgroundColor: whiteColor,
      ),
      body: BlocListener<EditCropBloc, EditCropState>(
        bloc: bloc,
        listener: _blocListener,
        child: BlocBuilder<EditCropBloc, EditCropState>(
          bloc: bloc,
          builder: (_, state) {
            List<Widget> schedules = [];

            for (int i = 0; i < state.crop.schedules!.length; i++) {
              schedules.add(scheduleBuilder(i, state.crop.schedules![i]));
            }

            // Show a loading spinner if we're waiting for the device list.
            if (state.devices == null) {
              return SafeArea(
                  child: Center(child: CircularProgressIndicator()));
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Crop Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox.fromSize(size: Size.fromHeight(15.0)),
                          FormTextField(
                            hintText: 'Brinjal',
                            controller: _nameController,
                          ),
                        ],
                      ),
                      SizedBox.fromSize(size: Size.fromHeight(25.0)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "EC",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox.fromSize(size: Size.fromHeight(15.0)),
                          FormTextField(
                            hintText: '1.6',
                            controller: _ecController,
                          ),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size.fromHeight(25.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox.fromSize(size: Size.fromHeight(15.0)),
                          Container(
                            height: 51.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context, state),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7.0),
                                      child: Text(
                                        state.crop.startDate == null
                                            ? "select date"
                                            : DateFormat('yyyy-MM-dd').format(
                                                state.crop.startDate!.toDate()),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size.fromHeight(25.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Crop State",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox.fromSize(size: Size.fromHeight(15.0)),
                          DropdownButton<String>(
                              value: cropStateToString(state.crop.cropState!),
                              items: <String>[
                                'Vegetative',
                                'Budding',
                                'Flowering',
                                'Ripening',
                                'Harvested'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: blackColor),
                                  ),
                                );
                              }).toList(),
                              dropdownColor: blueColor,
                              onChanged: (value) {
                                if (value != null) {
                                  bloc.add(ChangeCropStateEvent(value));
                                }
                              }),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size.fromHeight(25.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Device",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox.fromSize(size: Size.fromHeight(15.0)),
                          DropdownButton<String>(
                              value: state.crop.sensorDeviceId,
                              items: state.devices!.map((Device value) {
                                return DropdownMenuItem<String>(
                                  value: value.id,
                                  child: Text(
                                    value.description ?? "plantOS Device",
                                    style: TextStyle(color: blackColor),
                                  ),
                                );
                              }).toList(),
                              dropdownColor: blueColor,
                              onChanged: (value) {
                                if (value != null) {
                                  bloc.add(ChangeDeviceIdEvent(value));
                                }
                              }),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size.fromHeight(25.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Schedule",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: CircleAvatar(
                                  backgroundColor: blueColor,
                                  radius: 20,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.add),
                                    color: Colors.white,
                                    iconSize: 20,
                                    onPressed: () async {
                                      Schedule newSchedule =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditSchedulePage(
                                              Schedule(
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          0),
                                                  CropAction.of("Fertigation"),
                                                  Repeat(
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false,
                                                      false))),
                                        ),
                                      );
                                      if (newSchedule != null) {
                                        bloc.add(AddScheduleEvent(newSchedule));
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox.fromSize(
                            size: Size.fromHeight(15.0),
                          ),
                          Column(children: schedules)
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size.fromHeight(25.0),
                      ),
                      FormButton(
                          text: 'Save',
                          onPressed: state.isValid
                              ? () => bloc.add(ClickSubmitEditCropEvent())
                              : null),
                      SizedBox(height: 20),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
