import 'package:broker/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/unitDetails/ui/screen/unit_details_screen.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';

class PropertyCard extends StatelessWidget {
  final String location;
  final String type;
  final String price;
  const PropertyCard({super.key, required this.location, required this.type, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 4, ),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: ColorsManager.mediumDarkGray),
          //     color: ColorsManager.mainThemeColor,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Text(
          //     location,
          //     style:TextStyles.urbanistMedium14Light,
          //   ),
          // ),
          // SizedBox(height: 12.h),
          // Text(
          //   type,
          //   style:TextStyles.urbanistSemiBold18Light
          // ),
       
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: 'Wake up to the soothing melody of waves. This beachfront villa offers...',
          //         style: TextStyles.urbanistMedium14Light
          //       ),
          //       WidgetSpan(
          //         child: GestureDetector(
          //           onTap: () {
          //             // Handle "Read More" tap
          //           },
          //           child: Text(
          //             ' Read More',
          //             style: TextStyles.urbanistMedium14Light
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style:TextStyles.urbanistMedium14LightGray
                    ),
                     SizedBox(height: 8.h),
                     SizedBox(
                       width: 100.w,
                       child: Text(
                        '\$$price',
                        style: TextStyles.urbanistSemiBold18Light
                                           ),
                     ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width:155.w,
                height: 49.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                   padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Text(
                    'Property Details',
                    style: TextStyles. urbanistMedium14Light.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
