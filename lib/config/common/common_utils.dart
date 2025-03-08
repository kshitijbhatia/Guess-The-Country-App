import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
    height: toDouble().h,
  );

  SizedBox get pw => SizedBox(
    width: toDouble().w,
  );
}

Future<void> dialogBox(BuildContext context, {required String title, required String subTitle}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0,
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              10.ph,
              Text(subTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
            ],
          )
        ),
      );
    },
  );
}