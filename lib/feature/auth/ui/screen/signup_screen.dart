import 'package:broker/feature/auth/logic/auth_cubit.dart';
import 'package:broker/feature/auth/ui/widgets/phone_text_form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/sharedWidgets/app_text_form_field.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/register_model.dart';
import '../widgets/enter_your.dart';
import '../widgets/have_account_text.dart';
import '../widgets/sign_up_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
   final TextEditingController _PasswordConfirmController = TextEditingController();

  @override

   void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _PasswordConfirmController.dispose();

    super.dispose();
  }
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(

      builder: (BuildContext context, AuthState state) {
        return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(45),
                Center(
                  child: Text(
                    S.of(context).SignUp,
                    style: TextStyles.latoBold28DarkBlack,
                  ),
                ),
                verticalSpace(40),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EnterYour(text: S.of(context).EnterName),
                      verticalSpace(7),
                      AppTextFormField(hintText: "Your Name",controller: _nameController,),
                      verticalSpace(18),
                      EnterYour(text: S.of(context).EnterPhone),
                      verticalSpace(7),
                   PhoneTextForm(controller: _phoneController,onChanged: AuthCubit.get(context).changeSignUpPhone ),
                      verticalSpace(5),
                      EnterYour(text: S.of(context).EnterEmail),
                      verticalSpace(7),
                      AppTextFormField(hintText: "Your Email",controller: _emailController,),
                      verticalSpace(18),
                      EnterYour(
                        text: S.of(context).EnterPassword,
                      ),
                      verticalSpace(7),
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: S.of(context).Password,
                        isObscureText:AuthCubit.get(context).isObscureText1,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            AuthCubit.get(context).obscureText2();
                          },
                          child: Icon(
                            AuthCubit.get(context).isObscureText1
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      verticalSpace(18),
                      EnterYour(
                        text: S.of(context).ConfirmPassword,
                      ),
                      verticalSpace(7),
                      AppTextFormField(
                        controller: _PasswordConfirmController,
                        hintText: S.of(context).Password,
                        isObscureText:AuthCubit.get(context).isObscureText2,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).passwordcannotbeempty;
                          } else if (_passwordController.text !=
                              _PasswordConfirmController.text) {
                            return S.of(context).Passwordsdontmatch;
                          }
                          return null;
                        },
                      ),

                      verticalSpace(20),
                      AppTextButton(
                        buttonText: S.of(context).SignUp,
                        textStyle: TextStyles.latoMedium17White,
                        onPressed: ()  async {
                  if (formKey.currentState!.validate()) {
                     await AuthCubit.get(context).signUp(
                         RegisterModel(
                          name: _nameController.text,
                          email: _emailController.text,
                         password: _passwordController.text,
                          passwordConfirmation: _PasswordConfirmController.text,
                           phone_number:  AuthCubit.get(context).signUpPhone,
                        ),
                      );
                   }
                },
                      ),
                      HaveAccountText(
                        text: "or",
                        buttonText: S.of(context).Login,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.loginScreen);
                        },
                      ),
                      verticalSpace(25),


                    ],
                  ),
                ),
                SignUpStateUi(),
              ],

            ),
          ),
        ),

      );
      },
    );

  }
}
