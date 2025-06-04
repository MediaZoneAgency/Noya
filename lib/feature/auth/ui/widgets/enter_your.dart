
import 'package:flutter/material.dart';

import '../../../../core/theming/styles.dart';

class EnterYour extends StatelessWidget {
  final String text;
  const EnterYour ({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.latoRegular15DarkGray,);
  }
}