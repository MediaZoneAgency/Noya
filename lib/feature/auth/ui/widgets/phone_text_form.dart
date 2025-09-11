import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../Utils/color_manager.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';


class PhoneTextForm extends StatelessWidget {
  const PhoneTextForm({super.key, this.controller, required this.onChanged});
  final Function(String) onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      validator: (p){
        if (p!.completeNumber.length < 10) {
          return "phone number is not valid";
        }
        return "aaaaa";
      }
      ,
dropdownTextStyle:  TextStyles.latoRegular14lightBlack,
     style: TextStyles.latoRegular14lightBlack , controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.mainBlue,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.lightGray,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        hintStyle: TextStyles.latoRegular14lightBlack,
      ),
      initialCountryCode: 'EG',
      onChanged: (phone) {
        onChanged(phone.completeNumber);
      },
    );
  }
}






class Phone2TextForm extends StatelessWidget {
  const Phone2TextForm({super.key, this.controller, required this.onChanged});
  final Function(String) onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: TextStyles.latoRegular14lightBlack,
      validator: (p){
        if (p!.completeNumber.length < 10) {
          return "phone number is not valid";
        }
        return "aaaaa";
      }
      ,dropdownTextStyle: TextStyles.latoRegular14lightBlack,

      controller: controller,
      decoration: InputDecoration(
        
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.mainBlue,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
       border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none, // <--- لا يوجد حد
        ),
         enabledBorder: OutlineInputBorder(

      borderSide: const BorderSide(
        color: ColorsManager.lightGray,
        width: 1.3,
      ),
      borderRadius:BorderRadius.only(
  topLeft: Radius.circular(28.r),
  topRight: Radius.circular(28.r),
)
    ),
      
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          // حد لوني عند حدوث خطأ
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder( borderRadius:BorderRadius.only(
  topLeft: Radius.circular(28.r),
  topRight: Radius.circular(28.r),
) ,
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      
        hintStyle: TextStyles.latoRegular14lightBlack,
      ),
      initialCountryCode: 'EG',
      onChanged: (phone) {
        onChanged(phone.completeNumber);
      },
    );
  }
}