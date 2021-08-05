import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crop_details/crop_details_bloc.dart';
import 'package:plantos/src/pages/crop_details/crop_details_page.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop_page.dart';
import 'package:plantos/src/themes/colors.dart';
import '../../models/crop.dart';
import 'crops_bloc.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Image.asset("assets/hamburger.png"));
  }
}

class CropsPage extends StatefulWidget {
  @override
  _CropsPageState createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  late CropsBloc _cropsBloc;

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
                _cropsBloc.authService, _cropsBloc.userService, crop),
            child: CropDetailsPage(),
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
                      "Day ${_cropsBloc.convertDate(crop.startDate!)}",
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
                      crop.name!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      crop.ec!,
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
                      _cropsBloc.cropStateIndicator(crop.cropState!),
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

  Widget cropsTabViewPage(CropsStateDone state, BuildContext context) {
    const nameStyle = TextStyle(
        color: Color(0xFF28183D),
        fontSize: 18,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const emailStyle = TextStyle(
        color: Color(0x8028183d),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.normal);

    const menuTextStyle = TextStyle(
        color: Color(0xff938B9E),
        fontSize: 18,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const titleTextStyle = TextStyle(
        color: Color(0xff1D1F21),
        fontSize: 26,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF9F9F9),
        leading: Hamburger(),
        title: Image.asset("assets/logo/withtext.png",
            width: 115.0, height: 27.14),
      ),
      drawer: Drawer(
        elevation: 0,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21),
                child: Row(children: [
                  Center(
                      child: Image.asset("assets/user.png",
                          width: 52, height: 52)),
                  SizedBox(width: 22),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Adam Sydanus", style: nameStyle),
                      Text("adam@plant-os.com", style: emailStyle)
                    ],
                  )
                ]),
              ),
            ),
            SizedBox(height: 19),
            Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21),
                child: Divider(
                  color: Color(0xffEBEBEB),
                )),
            // SizedBox(height: 19),
            Padding(
                padding:
                    const EdgeInsets.only(left: 43.0, right: 21, top: 20.0),
                child: GestureDetector(
                    onTap: () {
                      // TODO: Do this properly.
                      FirebaseAuth.instance.signOut();

                      // Then close the drawer
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      // );
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/icon/logout.png"),
                        SizedBox(width: 18),
                        Text('Logout', style: menuTextStyle)
                      ],
                    ))),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Text(
                  "Crop Manager",
                  style: titleTextStyle,
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
                                builder: (_) => EditCropPage(
                                    _cropsBloc.cropsService,
                                    _cropsBloc.authService,
                                    _cropsBloc.userService,
                                    null)),
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
          return cropsTabViewPage(state, context);
        } else {
          return loadingPage();
        }
      },
    );
  }
}
