import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guess_the_country/config/common/common_utils.dart';
import 'package:guess_the_country/controllers/quiz_controller.dart';
import 'dart:developer' as dev;
import 'package:guess_the_country/main.dart';

import 'package:guess_the_country/countries/countries.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> with TickerProviderStateMixin {
  String correctCountry = "";

  late final AnimationController countDownController;
  late final Animation<double> countDownAnimation;

  late final Map<int, AnimationController> correctAnsController = {};
  late final Map<int, Animation<double>> correctAnsScaleAnimation = {};
  late final Map<int, Animation<Color?>> correctAnsColorAnimation = {};

  late final Map<int, AnimationController> wrongAnsController = {};
  late final Map<int, Animation<Color?>> wrongAnsColorAnimation = {};
  late final Map<int, Animation<double>> wrongAnsPosAnimation = {};

  @override
  void initState() {
    super.initState();
    _initCountDownAnimation();
    _initCorrectAnswerAnimation();
    _initWrongAnswerAnimation();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getRandomCountries();
    },);
  }

  void _initCountDownAnimation() {
    countDownController = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    countDownAnimation = Tween<double>(begin: prefs!.getDouble("screen_width"), end: 0).animate(countDownController);
    countDownController.addListener(() {
      if(countDownController.isCompleted) {
        _getRandomCountries();
      }
    },);
  }

  void _initCorrectAnswerAnimation() {
    for(int i = 0;i < 4;i++) {
      correctAnsController[i] = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
      correctAnsScaleAnimation[i] = Tween<double>(begin: 1.0, end: 1.05).animate(correctAnsController[i]!);
      correctAnsColorAnimation[i] = ColorTween(begin: const Color(0xFFffe700), end: const Color(0xFF74ee15)).animate(correctAnsController[i]!);

      correctAnsController[i]!.addListener(() {
        if(correctAnsController[i]!.isCompleted) {
          Future.delayed(const Duration(seconds: 1), () {
            _getRandomCountries();
            correctAnsController[i]!.reset();
          },);
        }
      },);
    }
  }

  void _initWrongAnswerAnimation() {
    for(int index = 0;index<4;index++) {
      wrongAnsController[index] = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
      wrongAnsColorAnimation[index] = ColorTween(begin: const Color(0xFFffe700), end: const Color(0xFFFF0000)).animate(wrongAnsController[index]!);
      wrongAnsPosAnimation[index] = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1,),
        TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 1,),
        TweenSequenceItem(tween: Tween(begin: 12, end: 0), weight: 1,),
        TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1,),
        TweenSequenceItem(tween: Tween(begin: -12, end: 0), weight: 1,),
      ]).animate(CurvedAnimation(parent: wrongAnsController[index]!, curve: Curves.ease));
    }
  }

  _getRandomCountries() {
    try {
      List<String> countries = [];

      /// Get 4 options
      while(countries.length != 4) {
        final int random = Random().nextInt(251);
        if(!countries.contains(countriesArray[random])) {
          countries.add(countriesArray[random]);
        }
      }

      /// Choose the correct answer randomly
      final int correctAnswerIndex = Random().nextInt(4);
      correctCountry = countries[correctAnswerIndex];

      ref.read(quizController.notifier).setCountryList(countries);
      ref.read(quizController.notifier).setCorrectCountryIndex(correctAnswerIndex);
      ref.read(quizController.notifier).changeFlagImage(correctCountry);

      /// Start/Restart the count down animation
      countDownController.reset();
      countDownController.forward();

      wrongAnsController.forEach((key, value) => value.reset(),);

      dev.log("correct_answer: ${countriesJson[correctCountry]}");
    } catch(error) {
      dev.log("get_random_country: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.black
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              40.ph,
              Container(
                width: double.infinity,
                height: 200.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Consumer(
                  builder: (context, ref, child) {
                    final flagImage = ref.watch(quizController.select((value) => value.flagImgPath,));
                    if(flagImage.isEmpty) {
                      return Container();
                    } else {
                      return SvgPicture.asset(
                        flagImage,
                        fit: BoxFit.contain,
                      );
                    }
                  },
                ),
              ),
              30.ph,
              Consumer(
                builder: (context, ref, child) {
                  final List<String> countries = ref.watch(quizController.select((value) => value.countries,));
                  return Expanded(
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final String countryOption = countries[index];
                        return _optionButton(
                          countryName: countriesJson[countryOption].toString(),
                          index: index,
                        );
                      },
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: countDownController,
                builder: (context, child) {
                  return Container(
                    color: Colors.red,
                    height: 20.h,
                    width: countDownAnimation.value,
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _optionButton({required String countryName, required int index}) {
    return Consumer(
      builder: (context, ref, child) {
        final int correctCountryIndex = ref.watch(quizController.select((value) => value.correctCountryIndex,));
        return GestureDetector(
          onTap: () {
            if(countriesJson[correctCountry] == countryName) {
              correctAnsController[index]!.forward();
            } else {
              wrongAnsController[index]!.forward();
              correctAnsController[correctCountryIndex]!.forward();
            }
          },
          child: AnimatedBuilder(
            animation: Listenable.merge([
              correctAnsController[index]!,
              wrongAnsController[index]!
            ]),
            builder: (context, child) {
              return  Transform.scale(
                scale: correctAnsScaleAnimation[index]!.value,
                child: Transform.translate(
                  offset: Offset(wrongAnsPosAnimation[index]!.value, 0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    decoration: BoxDecoration(
                        color: correctCountryIndex == index ? correctAnsColorAnimation[index]!.value : wrongAnsColorAnimation[index]!.value,
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        border: Border.all(color: Colors.black45, width: 6.w)
                    ),
                    child: Text(
                      countryName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

}