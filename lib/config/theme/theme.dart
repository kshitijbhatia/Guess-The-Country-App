import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData themeData() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.light(),
    textTheme: TextTheme(
      labelMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", fontSize: 18.sp),
      headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "Ubuntu", fontSize: 56.sp),
      titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", fontSize: 20.sp),
    )
  );
}