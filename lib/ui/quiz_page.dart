import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guess_the_country/config/common/common_utils.dart';
import 'package:guess_the_country/controllers/question_controller.dart';
import 'package:guess_the_country/controllers/quiz_controller.dart';
import 'dart:developer' as dev;
import 'package:guess_the_country/main.dart';

import 'package:guess_the_country/countries/countries.dart';
import 'package:guess_the_country/ui/home_page.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> with TickerProviderStateMixin {
  String correctCountry = "";

  final int totalPoints = 10;

  late final AnimationController countDownController;
  late final Animation<double> countDownAnimation;

  late final Map<int, AnimationController> correctAnsController = {};
  late final Map<int, Animation<double>> correctAnsScaleAnimation = {};
  late final Map<int, Animation<Color?>> correctAnsColorAnimation = {};
  late final Map<int, Animation<Color?>> correctTextColorAnimation = {};

  late final Map<int, AnimationController> wrongAnsController = {};
  late final Map<int, Animation<Color?>> wrongAnsColorAnimation = {};
  late final Map<int, Animation<double>> wrongAnsPosAnimation = {};
  late final Map<int, Animation<Color?>> wrongTextColorAnimation = {};

  late final Map<int, AnimationController> reduceLifeController = {};
  late final Map<int, Animation<double>> reduceLifeAnimation = {};

  @override
  void initState() {
    super.initState();
    _initCountDownAnimation();
    _initCorrectAnswerAnimation();
    _initWrongAnswerAnimation();
    _initLivesAnimation();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getRandomCountries();
    },);
  }

  void _initLivesAnimation() {
    for(int index = 0;index<4;index++) {
      reduceLifeController[index] = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
      reduceLifeAnimation[index] = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1, end: 1.4), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.4, end: 0), weight: 1)
      ]).animate(CurvedAnimation(parent: reduceLifeController[index]!, curve: Curves.linear));
    }
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
    for(int index = 0;index < 4;index++) {
      correctAnsController[index] = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
      correctAnsScaleAnimation[index] = Tween<double>(begin: 1.0, end: 1.05).animate(correctAnsController[index]!);
      correctAnsColorAnimation[index] = ColorTween(begin: Colors.white, end: const Color(0xFF74ee15)).animate(correctAnsController[index]!);
      correctTextColorAnimation[index] = ColorTween(begin: Colors.black, end: Colors.white).animate(correctAnsController[index]!);

      correctAnsController[index]!.addListener(() {
        if(correctAnsController[index]!.isCompleted) {
          Future.delayed(const Duration(seconds: 1), () {
            _getRandomCountries();
            correctAnsController[index]!.reset();
          },);
        }
      },);
    }
  }

  void _initWrongAnswerAnimation() {
    for(int index = 0;index<4;index++) {
      wrongAnsController[index] = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
      wrongAnsColorAnimation[index] = ColorTween(begin: Colors.white, end: const Color(0xFFFF0000)).animate(wrongAnsController[index]!);
      wrongTextColorAnimation[index] = ColorTween(begin: Colors.black, end: Colors.white).animate(wrongAnsController[index]!);
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

      ref.read(questionController.notifier).setCountryList(countries);
      ref.read(questionController.notifier).setCorrectCountryIndex(correctAnswerIndex);
      ref.read(questionController.notifier).changeFlagImage(correctCountry);

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
  void dispose() {
    countDownController.dispose();
    wrongAnsController.forEach((key, value) => value.dispose(),);
    correctAnsController.forEach((key, value) => value.dispose(),);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(quizController.select((value) => value.livesLeft,), (previous, next) {
      if(next == 0) {
        ref.read(quizController.notifier).reviveAllLives();
        Future.delayed(const Duration(milliseconds: 600), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),)),);
      }
    },);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Color(0xFFFAF9F6)
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pointCalculator(),
                    _livesLeftBar()
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(20, 15),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    final flagImage = ref.watch(questionController.select((value) => value.flagImgPath,));
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
                  final List<String> countries = ref.watch(questionController.select((value) => value.countries,));
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

  Widget _pointCalculator() {
    return Consumer(
      builder: (context, ref, child) {
        int pointsEarned = ref.watch(quizController.select((value) => value.pointsEarned,));
        return Container(
          child: Text("$pointsEarned/10", style: Theme.of(context).textTheme.titleMedium,),
        );
      },
    );
  }

  Widget _livesLeftBar() {
    return Row(
      children: List.generate(4, (index) {
        return ScaleTransition(
          scale: reduceLifeAnimation[3 - index]!,
          child: Container(
            width: 28.w,
            height: 26.h,
            margin: EdgeInsets.only(right: 5.w),
            child: Image.asset("assets/images/heart.png", fit: BoxFit.contain,),
          ),
        );
      },),
    );
  }

  Widget _optionButton({required String countryName, required int index}) {
    return Consumer(
      builder: (context, ref, child) {
        final int correctCountryIndex = ref.watch(questionController.select((value) => value.correctCountryIndex,));
        return GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();

            if(countriesJson[correctCountry] == countryName) {
              ref.read(quizController.notifier).increasePoint();
              correctAnsController[index]!.forward();
            } else {
              wrongAnsController[index]!.forward();

              Future.delayed(const Duration(milliseconds: 400), () {
                correctAnsController[correctCountryIndex]!.forward();
              },);

              Future.delayed(const Duration(seconds: 1), () {
                int index = ref.read(quizController.notifier).reduceOneLife();
                reduceLifeController[index]!.forward();
              });
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
                        border: Border.all(color: Colors.black, width: 2.w)
                    ),
                    child: Text(
                      countryName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: correctCountryIndex == index ? correctTextColorAnimation[index]!.value : wrongTextColorAnimation[index]!.value)
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