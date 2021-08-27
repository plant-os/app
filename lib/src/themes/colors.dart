import 'package:flutter/material.dart';

Color blueColor = Color(0xff33A1E3);
Color blackColor = Color(0xff000000);
Color greyColor = Colors.grey[350]!;
Color lightGreyColor = Color(0xffC6C6C6);
Color whiteColor = Color(0xffffffff);
Color greenColor = Color(0xff17b484);
Color darkBlueColor = Color(0xff28173d);

const titleStyle = TextStyle(
  color: Color(0xff28183d),
  fontSize: 25,
  fontFamily: "Work Sans",
  fontWeight: FontWeight.w600,
);

const dialogHeaderStyle = TextStyle(
  color: Color(0xff28183d),
  fontSize: 18,
  fontFamily: "Work Sans",
  fontWeight: FontWeight.w600,
);

const textStyle = TextStyle(
    color: Color(0xff28183d),
    fontSize: 13,
    fontFamily: "Work Sans",
    fontWeight: FontWeight.normal);

const textLinkStyle = TextStyle(
    color: Color(0xff6e6e6e),
    fontSize: 14,
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w500);

const textLinkHighlightStyle = TextStyle(
    color: Color(0xff1FAD84),
    fontSize: 14,
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w500);

const labelStyle = TextStyle(
    color: Color(0xff28183d),
    fontSize: 14,
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w500);

const btnLabelStyle = TextStyle(
    color: Color(0xffffffff),
    fontSize: 14,
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w500);

var textFieldDecoration = InputDecoration(
  isCollapsed: true,
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
  hintText: '',
  isDense: true,
);

const standardPagePadding = EdgeInsets.only(left: 20, right: 20, top: 10);
