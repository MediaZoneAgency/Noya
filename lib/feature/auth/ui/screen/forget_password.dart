
import 'package:broker/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/theming/styles.dart';

import '../../../../core/utils/routes.dart';
import '../../../../generated/l10n.dart';

class ForgetPasswordScreen extends StatelessWidget{
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SafeArea(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(S.of(context).ForgotPassword,style: TextStyles.latoBold28DarkBlack,),
        verticalSpace(10),
        Text(S.of(context).ChooseRecovery,style: TextStyles.latoRegular20gray,textAlign: TextAlign.center,),
        verticalSpace(37),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppTextButton(

          borderRadius: 30.r,
          buttonHeight: 47.h,
          buttonWidth: 122.w,
          buttonText: S.of(context).Email, textStyle: TextStyles.latoRegular18White,
            onPressed: () {  },),
          horizontalSpace(17),
          AppTextButton(

            borderRadius: 30.r,
            buttonHeight: 47.h,
            buttonWidth: 122.w,
            buttonText: S.of(context).Phone, textStyle: TextStyles.latoRegular18White,
            onPressed: () {  context.pushNamed(Routes.phoneRecovery);},)
        ],)
      ],),),
    );
  }
}