
import 'package:broker/core/sharedWidgets/app_text_button.dart';
import 'package:broker/feature/unitDetails/ui/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';


class LocationContainer extends StatelessWidget {
  const LocationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 183.h,
      decoration: BoxDecoration(
       // color: ColorsManager.mainThemeColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        border: Border.all(color: ColorsManager.mediumDarkGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add your content here
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyles.urbanistregular18Lightgray,
                ),
                SizedBox(height: 20,),

                Text(
                    'MountainView Icity',
                    style: TextStyles.urbanistSemiBold18Light.copyWith(
                        wordSpacing:1,height: 1
                    )

                ),
                SizedBox(height: 10,),
            Text(
                '6 October City',
            style: TextStyles.urbanistSemiBold18Light.copyWith(
                wordSpacing:1,height: 1
            ),),
                SizedBox(height: 18,),
                AppTextButton(
                  horizontalPadding:5,
                  verticalPadding: 5,
                  buttonText: 'Open Location',
                  textStyle: TextStyles.urbanistSemiBold8Light,
                  onPressed: () {  },
                  buttonHeight: 25.h,
                  buttonWidth: 99.w,
                ),

              ],
            ),

          ),

        ],
      ),
    );
  }
}
