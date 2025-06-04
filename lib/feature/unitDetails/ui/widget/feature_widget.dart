import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class FeatureWidget extends StatelessWidget {
  const FeatureWidget({super.key, required this.feature});
final   String feature;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 318.w,
      height: 70.h,
      decoration: const BoxDecoration(
        color: ColorsManager.mainThemeColor,
        border: Border(
          left: BorderSide(
            color: Color(0xFF703BF7), // Color for the left border
            width: 2, // Thickness of the left border
          ),

        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child:
                  Image.asset('assets/img/Vector 449 (Stroke).png',
                    //  fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '$feature',
                    style: TextStyles.urbanistMedium14Light,
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
