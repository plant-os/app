import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/themes/colors.dart';

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

  Widget cardsContainer() {
    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         cropCard(),
    //         cropCard(),
    //         cropCard(),
    //         cropCard(),
    //       ],
    //     ),
    //   ),
    // );
    return StreamBuilder(
        stream: _cropsBloc.cropsList,
        builder: (context, snapshot) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(children: snapshot.data.map((crop) => cropCard())),
            ),
          );
        });
  }

  Widget cropCard() {
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
                    "Day 30",
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
                    "Brinjal",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text("1.6",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 0, bottom: 18),
              child: Row(
                children: [
                  Text(
                    "Flowering",
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
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 30, right: 30),
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
                      )
                    ],
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [cardsContainer(), Text('Person')],
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
