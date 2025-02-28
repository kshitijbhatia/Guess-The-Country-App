import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// extension EmptyPadding on num {
//   SizedBox get pw => SizedBox(width: toDouble().w,);
//   SizedBox get ph => SizedBox(height: toDouble().h,);
// }

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
    height: toDouble().h,
  );

  SizedBox get pw => SizedBox(
    width: toDouble().w,
  );
}