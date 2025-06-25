import 'package:broker/core/sharedWidgets/top_property_list.dart';
import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DetailsContainer extends StatelessWidget {
  const DetailsContainer({
    super.key,
    required this.bedroom,
    required this.bathroom,
    required this.space,
    required this.description,
    required this.price
  });

  final int bedroom;
  final int bathroom;
  final int space;
  final String description;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: ColorsManager.mediumDarkGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price',
              style: TextStyles.urbanistSemiBold18Light,
            ),
            SizedBox(height: 8.h),
            Text(
             price,
              style: TextStyles.urbanistMedium14LightGray,
            ),
            const Divider(
              height: 20,
              thickness: 1,
              color: ColorsManager.mediumDarkGray,
            ),
            Text(
              'Description',
              style: TextStyles.urbanistSemiBold18Light,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyles.urbanistMedium14LightGray,
            ),
            const Divider(
              height: 20,
              thickness: 1,
              color: ColorsManager.mediumDarkGray,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/Icon.png',
                            height: 20.h,
                            width: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Bedrooms',
                            style: TextStyles.urbanistMedium14LightGray,
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '0$bedroom',
                        style: TextStyles.urbanistSemiBold18Light,
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/Icon.png',
                            height: 20.h,
                            width: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Bathrooms',
                            style: TextStyles.urbanistMedium14LightGray,
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '0$bathroom',
                        style: TextStyles.urbanistSemiBold18Light,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              color: ColorsManager.mediumDarkGray,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/Icon (4).png',
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Area',
                    style: TextStyles.urbanistMedium14LightGray,
                  ),
                  Spacer(),
                  Text(
                    '$space Sq Ft',
                    style: TextStyles.urbanistSemiBold18Light,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
