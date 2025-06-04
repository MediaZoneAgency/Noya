import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/feature/auth/ui/widgets/phone_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/routes.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/login_model.dart';
import '../../logic/auth_cubit.dart';
import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/sharedWidgets/app_text_form_field.dart';
import '../../../../core/helpers/spacing.dart';
import 'enter_your.dart';
import 'have_account_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone number input field with validation
          EnterYour(text: S.of(context).EnterPhone),
          verticalSpace(5),
          PhoneTextForm(
            controller: phoneEditingController,
            onChanged: AuthCubit.get(context).changeLogInPhone,
          ),


          // Password input field with validation
          EnterYour(
            text: S.of(context).EnterPassword,
          ),
          verticalSpace(5),
          AppTextFormField(
            controller: passwordEditingController,
            hintText: S.of(context).Password,
            isObscureText: AuthCubit.get(context).isObscureText2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password must not be empty';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () {
                AuthCubit.get(context).obscureText2();
              },
              child: Icon(
                AuthCubit.get(context).isObscureText2
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
          verticalSpace(18),

          // Forgot password
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(Routes.forgetPasswordScreen);
              },
              child: Text(
                S.of(context).ForgotPassword,
                style: TextStyles.latoRegular15DarkGray,
              ),
            ),
          ),
          verticalSpace(20),

          // Login button with form validation and submission
          AppTextButton(
            buttonText: S.of(context).Login,
            textStyle: TextStyles.latoMedium17White,
            onPressed: () async {
              // Check if the form is valid before proceeding
              if (formKey.currentState!.validate()) {
                // Perform login
                await AuthCubit.get(context).login(
                  LogInModel(
                    email: emailEditingController.text,
                    password: passwordEditingController.text,
                    phoneNumber: AuthCubit.get(context).logInPhone,
                  ),
                );
              }
            },
          ),
          verticalSpace(25),

          // Sign-up text at the bottom of the form
          HaveAccountText(
            text: S.of(context).NoAccount,
            buttonText: S.of(context).SignUp,
            onTap: () {
              Navigator.pushNamed(context, Routes.signUpScreen);
            },
          ),
        ],
      ),
    );
  }
}
