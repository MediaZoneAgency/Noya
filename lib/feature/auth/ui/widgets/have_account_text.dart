
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/styles.dart';

class HaveAccountText extends StatelessWidget {
  final String buttonText;
  final String text;
  final VoidCallback onTap;
  const HaveAccountText({super.key, required this.onTap, required this.buttonText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: TextStyles.latoRegular15lightBlack,
            ),
        
            TextSpan(
              text: buttonText,
              style: TextStyles.latoBold15BlueBlack,
              recognizer: TapGestureRecognizer()
                ..onTap = onTap
            ),
          ],
        ),
      ),
    );
  }
}