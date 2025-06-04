import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/core/network/dio_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/cash_helper.dart';
import '../../../core/utils/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> typingAnimation;
  final String word = 'NOYA';

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    typingAnimation = StepTween(begin: 0, end: word.length).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      WidgetsFlutterBinding.ensureInitialized();
      CashHelper.setStringSecured(key: Keys.session_id, value: '');
      String token = await CashHelper.getStringSecured(key: Keys.token);
      print(token);
      if (token == '') {
        context.pushReplacementNamed(Routes.signUpScreen);
      } else {
        DioFactory.setTokenIntoHeaderAfterLogin(token);
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.AiChatScreen,
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: typingAnimation,
          builder: (context, child) {
            return Text(
              word.substring(0, typingAnimation.value),
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
                fontFamily: 'Roboto',
              ),
            );
          },
        ),
      ),
    );
  }
}
