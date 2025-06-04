import 'package:broker/Utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, this.controller, this.validator, this.ontap, this.onSubmit, this.read});
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? ontap;
  final String? Function(String?)? onSubmit;
  final bool? read;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Container(
        height: 51.h,
        width: double.infinity,
        decoration: const BoxDecoration(
            color:ColorsManager.mainDarkGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            ),
        child: TextFormField(
          style: TextStyles.inter12RegularWhite,
          onTap:ontap ,
          readOnly: read ?? false,
          controller: controller,
          textAlign: TextAlign.center,
          onFieldSubmitted: onSubmit,
          decoration: InputDecoration(

          contentPadding: EdgeInsets.only(left: 20.w,top: 15.h,bottom: 15.h),
            hintStyle: TextStyles.rubikRegular15DarkGray,
              border: InputBorder.none,
              hintText: 'Search a place',


              prefixIcon: SvgPicture.asset(
                'assets/img/clarity_search-line.svg',
                fit: BoxFit.scaleDown,
              ),
            suffixIcon:  SvgPicture.asset(
              'assets/img/clarity_microphone-line.svg',
              fit: BoxFit.scaleDown,
            ),
          ),

        ),

      ),
    );

  }
}