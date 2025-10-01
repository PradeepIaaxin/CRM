import 'package:flutter/material.dart';

class Space {
  static SizedBox height(BuildContext context, double value) {
    double screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight >= 1000) {
      return SizedBox(height: value + 6); // Tablet / Large Screen
    } else {
      return SizedBox(height: value); // Mobile
    }
  }

  static SizedBox width(BuildContext context, double value) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1000) {
      return SizedBox(width: value + 6); // Tablet / Large Screen
    } else {
      return SizedBox(width: value); // Mobile
    }
  }

  static SizedBox h5(BuildContext context) => height(context, 5);
  static SizedBox h10(BuildContext context) => height(context, 10);
  static SizedBox h15(BuildContext context) => height(context, 15);
  static SizedBox h20(BuildContext context) => height(context, 20);
  static SizedBox h25(BuildContext context) => height(context, 25);
  static SizedBox h30(BuildContext context) => height(context, 30);

  static SizedBox w5(BuildContext context) => width(context, 5);
  static SizedBox w10(BuildContext context) => width(context, 10);
  static SizedBox w15(BuildContext context) => width(context, 15);
  static SizedBox w20(BuildContext context) => width(context, 20);
  static SizedBox w25(BuildContext context) => width(context, 25);
  static SizedBox w30(BuildContext context) => width(context, 30);
}
