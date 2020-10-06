import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:rxdart/subjects.dart';
import '../../models/crop.dart';

class CropsPage extends StatefulWidget {
  @override
  _CropsPageState createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  TabController tabController;
  CropsBloc _cropsBloc;

  @override
  void dispose() {
    super.dispose();
    _cropsBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cropsBloc = BlocProvider.of<CropsBloc>(context);
    tabController = TabController(length: 2, vsync: this);
  }

  Widget cardsContainer(BehaviorSubject<List<Crop>> cropsList) {
    return StreamBuilder<List<Crop>>(
      stream: cropsList,
      initialData: [],
      builder: (context, snapshot) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
                children: snapshot.data
                    .map((crop) => cropCard(
                        crop.name, crop.startDate, crop.ec, crop.cropState))
                    .toList()),
          ),
        );
      },
    );
  }

  Widget cropCard(String cropName, Timestamp startDateTimestamp, String ec,
      CropState cropState) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: blueColor,
            border: Border.all(
              color: blueColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 30, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day ${_cropsBloc.convertDate(startDateTimestamp)}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text("EC", style: TextStyle(fontSize: 16))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 0, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cropName,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ec,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 0, bottom: 18),
              child: Row(
                children: [
                  Text(
                    _cropsBloc.cropStateIndicator(cropState),
                    style: TextStyle(fontSize: 16, color: greyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.8,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(children: [
                        Row(
                          children: [
                            StreamBuilder<String>(
                              stream: _cropsBloc.username,
                              builder: (context, snapshot) {
                                return Text(
                                  "Hey ${snapshot.data}!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                );
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Text(
                                "Your Crops",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              )
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TabBar(
                        unselectedLabelColor: blackColor,
                        labelColor: blackColor,
                        indicatorColor: blackColor,
                        tabs: [
                          Tab(
                            text: "Ongoing",
                          ),
                          Tab(
                            text: "Past",
                          ),
                        ],
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, right: 40),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    cardsContainer(_cropsBloc.cropsListOngoing),
                    cardsContainer(_cropsBloc.cropsListPast)
                  ],
                  controller: tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
