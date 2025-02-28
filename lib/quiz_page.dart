import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guess_the_country/countries/countries.dart';
import 'package:guess_the_country/config/common/common_utils.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  final Set<String> countriesSet = {};

  @override
  void initState() {
    super.initState();
    _getRandomCountry();
  }

  _getRandomCountry() {
    try {
      final int random = Random().nextInt(252);
      dev.log("random_number: ${random}");
      countriesSet.add(countriesArray[random]);
    } catch(error) {
      dev.log("get_random_country: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              80.ph,
              Container(
                color: Colors.red,
                width: double.infinity,
                height: 200.h,
                child: SvgPicture.asset(
                  "assets/flags/${countriesSet.first.toLowerCase()}.svg",
                  fit: BoxFit.contain,
                ),
              ),
              30.ph,
              Text("${countriesJson[countriesSet.first]}")
            ],
          ),
        ),
      ),
    );
  }
}