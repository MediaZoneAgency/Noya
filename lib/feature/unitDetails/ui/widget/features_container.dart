
import 'package:broker/feature/unitDetails/ui/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';


class FeatureContainer extends StatelessWidget {
  const FeatureContainer({super.key,  required this.feature1, required this.feature2, required this.feature3, required this.feature4});
final String feature1;
final String feature2;
final String feature3;
final String feature4;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      //height: 410.h,
      decoration: BoxDecoration(
     //   color: ColorsManager.mediumDarkGray,
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
                  'Key Features and Amenities',
                  style: TextStyles.urbanistSemiBold18Light,
                ),
                SizedBox(height: 20.h,),
                FeatureWidget(feature: feature1,),
                SizedBox(height: 18.h,),
                FeatureWidget(feature:feature2,),
                SizedBox(height: 18.h,),
                FeatureWidget(feature: feature3,),
                SizedBox(height: 18.h,),
                FeatureWidget(feature: feature4,),



              ],
            ),

          ),

        ],
      ),
    );
  }
}
