
import 'package:broker/core/sharedWidgets/app_text_button.dart';
import 'package:broker/feature/unitDetails/ui/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';


class AdContainer extends StatelessWidget {
  const AdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 358.w,
      height: 183.h,
      decoration: BoxDecoration(
      //  color: ColorsManager.mainThemeColor,
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ad Owner',
                  style: TextStyles.urbanistregular18Lightgray,
                ),
                SizedBox(height: 16,),

                Row(
                  children: [

                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 5, 0),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage(
                          'assets/img/image (3).png',
                        ), // Profile image URL
                      ),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      children: [

                        Text(
                            'MountainView ',
                            style: TextStyles.urbanistSemiBold18Light.copyWith(
                                wordSpacing:1,height: 1
                            )
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '0102901921',
                          style: TextStyles.urbanistRegular10Lightgray.copyWith(
                              wordSpacing:1,height: 1
                          ),),
                      ],
                    ),
                  SizedBox(width: 28,),
                    AppTextButton(
                      horizontalPadding:5,
                      verticalPadding: 5,
                      buttonText: 'Contact Owner',
                      textStyle: TextStyles.urbanistSemiBold8Light,
                      onPressed: () {  },
                      buttonHeight: 29.h,
                      buttonWidth: 103.w,
                    ),

                  ],
                ),



              ],
            ),

          ),
        ],
      ),
    );
  }
}
