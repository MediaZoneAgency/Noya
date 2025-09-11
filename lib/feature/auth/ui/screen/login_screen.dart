
import 'package:broker/feature/auth/ui/widgets/login_form.dart';
import 'package:broker/feature/auth/ui/widgets/phone_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';

import '../../../../core/theming/styles.dart';
import '../../../../core/utils/routes.dart';
import '../../../../generated/l10n.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../../data/models/login_model.dart';
import '../widgets/enter_your.dart';

import '../widgets/have_account_text.dart';
import '../widgets/sign_in_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    phoneEditingController.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
       backgroundColor: Colors.transparent,
    body: SafeArea(
      child: Stack(
            fit: StackFit.expand,
        children: [
          // 🌄 Background Image
          Positioned.fill(
            child:   Image.asset(
            'assets/img/image 2.png',
            fit: BoxFit.cover,
          ),
          ),

          // 🧾 Main content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 90.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(45),
                  Center(
                    child: Text(
                      S.of(context).Login,
                      style: TextStyles.latoBold28DarkBlack,
                    ),
                  ),
                  verticalSpace(40),
                  LoginForm(),
                  verticalSpace(40),
                  SignInStateUi(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


}
