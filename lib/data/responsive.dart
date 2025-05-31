import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isMobile(context) => MediaQuery.sizeOf(context).width < 650;

  static bool isTablet(context) =>
      MediaQuery.sizeOf(context).width >= 650 &&
      MediaQuery.sizeOf(context).width < 1100;

  static bool isWindow(context) => MediaQuery.sizeOf(context).width >= 1100;
}
