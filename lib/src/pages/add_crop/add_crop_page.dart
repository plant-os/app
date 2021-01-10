import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/add_crop/add_crop_bloc.dart';
import 'package:plantos/src/pages/add_schedule/add_schedule.dart';
import 'package:plantos/src/pages/crop_details/crop_details_page.dart';
import 'package:plantos/src/pages/edit_schedule/edit_schedule.dart';
import 'package:plantos/src/pages/edit_schedule/edit_schedule_bloc.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:intl/intl.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

class AddCropPage extends StatefulWidget {
  @override
  AddCropPageState createState() => AddCropPageState();
}

class AddCropPageState extends State<AddCropPage> {
  Crop crop = Crop(
      name: "",
      fertigationCrop: true,
      ec: "",
      cropState: CropState(
          vegetative: true,
          budding: false,
          flowering: false,
          ripening: false,
          harvested: false),
      startDate: Timestamp.now(),
      schedules: []);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ecController = TextEditingController();
  String dropDownValueString = "Vegetative";
  Loading _loading;
  AddCropBloc addCropsBloc;

  void _onCropFieldChanged() {
    crop.ec = _ecController.text;
    crop.name = _nameController.text;
    addCropsBloc.add(CropFieldChangedEvent(crop: crop));
  }

  void removeSchedule(Schedule schedule) {
    crop.schedules = crop.schedules
        .where((cropSchedule) => schedule != cropSchedule)
        .toList();
    _onCropFieldChanged();
  }

  void toggleCropState() {
    if (dropDownValueString == "Vegetative") {
      crop.cropState = CropState(
          vegetative: true,
          budding: false,
          flowering: false,
          ripening: false,
          harvested: false);
    } else if (dropDownValueString == "Budding") {
      crop.cropState = CropState(
          vegetative: false,
          budding: true,
          flowering: false,
          ripening: false,
          harvested: false);
    } else if (dropDownValueString == "Flowering") {
      crop.cropState = CropState(
          vegetative: false,
          budding: false,
          flowering: true,
          ripening: false,
          harvested: false);
    } else if (dropDownValueString == "Ripening") {
      crop.cropState = CropState(
          vegetative: false,
          budding: false,
          flowering: false,
          ripening: true,
          harvested: false);
    } else if (dropDownValueString == "Harvested") {
      crop.cropState = CropState(
          vegetative: false,
          budding: false,
          flowering: false,
          ripening: false,
          harvested: true);
    }
    _onCropFieldChanged();
  }

  void _blocListener(context, state) {
    if (state.isLoading)
      _loading = Loading(context);
    else if (state.isSuccess) {
      _loading.close();
      SnackbarWithColor(
          color: greenColor,
          context: context,
          text: 'Crop was successfully created.');
      Navigator.pop(context);
    } else if (state.error.isNotEmpty) {
      _loading.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    }
  }

  void _addCropPressed() {
    addCropsBloc.add(ClickSubmitAddCropEvent());
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: crop.startDate.toDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != crop.startDate.toDate())
      setState(() {
        crop.startDate = Timestamp.fromDate(picked);
      });
    _onCropFieldChanged();
  }

  @override
  void initState() {
    super.initState();
    addCropsBloc = BlocProvider.of<AddCropBloc>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ecController.dispose();
    super.dispose();
  }

  Widget scheduleBuilder(Schedule schedule) {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              schedule = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditSchedulePage(schedule)));
              setState(() {});
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
                              schedule.action.fertigation == true
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
                                        .format(schedule.time.toDate()),
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
                    onTap: () {
                      removeSchedule(schedule);
                      setState(() {});
                    },
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
          "Add Crop",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: blackColor),
        ),
        backgroundColor: whiteColor,
      ),
      body: BlocListener<AddCropBloc, AddCropState>(
        listener: _blocListener,
        child: BlocBuilder<AddCropBloc, AddCropState>(
          builder: (_, state) => SafeArea(
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
                          onChanged: () => _onCropFieldChanged(),
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
                          onChanged: () => _onCropFieldChanged(),
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
                                  onTap: () => _selectDate(context),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(crop.startDate.toDate()),
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
                            value: dropDownValueString,
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
                              dropDownValueString = value;
                              toggleCropState();

                              setState(() {});
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
                                    Schedule newSchedule = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BlocProvider<AddScheduleBloc>(
                                          create: (_) => AddScheduleBloc(
                                              addCropsBloc.cropsService),
                                          child: AddSchedulePage(),
                                        ),
                                      ),
                                    );
                                    if (newSchedule != null) {
                                      crop.schedules.add(newSchedule);
                                      _onCropFieldChanged();
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox.fromSize(
                          size: Size.fromHeight(15.0),
                        ),
                        Column(
                            children: crop.schedules
                                .map((schedule) => scheduleBuilder(schedule))
                                .toList())
                      ],
                    ),
                    SizedBox.fromSize(
                      size: Size.fromHeight(25.0),
                    ),
                    FormButton(
                        text: 'Add Crop',
                        onPressed: state.isValid ? _addCropPressed : null),
                    SizedBox(height: 20),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
