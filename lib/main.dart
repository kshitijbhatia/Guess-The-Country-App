import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guess_the_country/config/theme/theme.dart';
import 'package:guess_the_country/quiz_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeData(),
          debugShowCheckedModeBanner: false,
          home: const QuizPage(),
        );
      },
    );
  }
}