
import 'package:broker/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';

import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/theming/styles.dart';

import '../../../../core/utils/routes.dart';
import '../../../../generated/l10n.dart';

class PhoneRecoveryScreen extends StatelessWidget{
  const PhoneRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SafeArea(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).Phone,
          style: TextStyles.latoBold20DarkBlack,),
        Text('011*******99',
          style: TextStyles.latoBold20DarkBlack,),
        verticalSpace(25),
        Text(S.of(context).RecoverySent,
          style: TextStyles.latoBold20DarkBlack,textAlign: TextAlign.center,),
        verticalSpace(37),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppTextButton(

            borderRadius: 30.r,
            buttonHeight: 47.h,
            buttonWidth: 122.w,
            buttonText: S.of(context).Resend, textStyle: TextStyles.latoRegular18White, onPressed: () {
             context.pushNamed(Routes.resetPasswordScreen);
          },),
            horizontalSpace(17),
            AppTextButton(

              borderRadius: 30.r,
              buttonHeight: 47.h,
              buttonWidth: 122.w,
              buttonText: S.of(context).Login, textStyle: TextStyles.latoRegular18White, onPressed: () {
              context.pushNamed(Routes.loginScreen);
            },)
          ],)
      ],),),
    );
  }
}