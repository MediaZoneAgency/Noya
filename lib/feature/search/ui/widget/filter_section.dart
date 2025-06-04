import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/styles.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const FilterSection({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.inter13SemiBoldWhite,
        ),
        SizedBox(height: 8.h),
        child,
        SizedBox(height: 16.h),
      ],
    );
  }
}
