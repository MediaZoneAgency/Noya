import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class CustomLocationBar extends StatelessWidget {
  const CustomLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( right: 14),
      child: Container(
        height: 36.8.h, // تحديد ارتفاع الحاوية
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorsManager.mainDarkGray,
          borderRadius: BorderRadius.all(Radius.circular(4.8)),
        ),
        child:TextFormField(

          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20.w,top: 15.h,bottom: 10.h),
            hintStyle: TextStyles.inter13MediumGray,
            border: InputBorder.none,
            hintText: 'Any Area',
            suffixIcon:  SvgPicture.asset(
              'assets/img/Input.svg',
              fit: BoxFit.scaleDown,
            ),

          ),
        ),
      ),
    );
  }
}


// Text(
// "Any Area",
// style: TextStyles.inter13MediumGray,
// ),