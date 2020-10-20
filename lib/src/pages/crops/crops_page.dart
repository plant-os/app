import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/add_crop/add_crop_bloc.dart';
import 'package:plantos/src/pages/add_crop/add_crop_page.dart';
import 'package:plantos/src/pages/crop_details/crop_details.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/themes/colors.dart';
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

  Widget cardsContainer(List<Crop> cropsList) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            children: cropsList
                .map(
                  (crop) => cropCard(crop),
                )
                .toList()),
      ),
    );
  }

  Widget cropCard(Crop crop) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<CropDetailsBloc>(
            create: (_) => CropDetailsBloc(_cropsBloc.cropsService,
                _cropsBloc.authService, _cropsBloc.userService),
            child: CropDetailsPage(crop),
          ),
        ),
      ),
      child: Padding(
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
                      "Day ${_cropsBloc.convertDate(crop.startDate)}",
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
                      crop.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      crop.ec,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
                      _cropsBloc.cropStateIndicator(crop.cropState),
                      style: TextStyle(fontSize: 16, color: greyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cropsTabViewPage(state) {
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
                        Row(children: [
                          Text(
                            "Hey ${state.currentUser.name}!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ]),
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
                        backgroundColor: blueColor,
                        radius: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider<AddCropBloc>(
                                create: (_) => AddCropBloc(
                                    _cropsBloc.cropsService,
                                    _cropsBloc.authService,
                                    _cropsBloc.userService),
                                child: AddCropPage(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    cardsContainer(state.ongoingCrops),
                    cardsContainer(state.pastCrops)
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
    return BlocBuilder<CropsBloc, CropsState>(
      builder: (context, state) {
        if (state is CropsStateDone) {
          return cropsTabViewPage(state);
        } else {
          return loadingPage();
        }
      },
    );
  }
}
