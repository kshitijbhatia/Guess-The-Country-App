import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guess_the_country/config/common/common_utils.dart';
import 'package:guess_the_country/ui/quiz_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  late final AnimationController transitionController;
  late final Animation<double> transitionAnimation;

  String playText = "Play";

  @override
  void initState() {
    super.initState();
    transitionController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    transitionAnimation = Tween<double>(begin: 1, end: 20).animate(CurvedAnimation(parent: transitionController, curve: Curves.ease));
    transitionController.addListener(() {
      if(transitionController.isAnimating) {
        setState(() {
          playText = "";
        });
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            140.ph,
            Container(
              width: double.infinity,
              child: Text("Guess".toUpperCase(), style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,),
            ),
            Container(
              width: double.infinity,
              child: Text("the".toUpperCase(), style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,),),
            Container(
              width: double.infinity,
              child: Text("country".toUpperCase(), style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,),
            ),
            60.ph,
            GestureDetector(
              onTap: () {
                transitionController.forward();
                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuizPage(),));
                  },
                );
              },
              child: ScaleTransition(
                scale: transitionAnimation,
                child: Container(
                  width: 180.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.r))
                  ),
                  alignment: Alignment.center,
                  child: Text(playText, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium,),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}