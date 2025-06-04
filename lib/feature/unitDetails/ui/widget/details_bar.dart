import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DetailsBar extends StatelessWidget {
  final String username;
  final String location;
  final String type;
  final String price;
  const DetailsBar({
    super.key,
    required this.username,
    required this.location,
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Stack(
        children: [Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 5, 0),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                        'assets/img/740712ae-9eae-4b47-b8cf-bee8736f3b46.jpg',
                      ), // Profile image URL
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Greeting text
                  Expanded(
                    child: Text(
                      'Hi,  $username!',
                      style: TextStyles.inter22BoldWhite,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                '$location, $type',
                style: TextStyles.urbanistSemiBold20Light,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Container(
                    width: 89.w, // Adjusted width
                    height: 37.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorsManager.mediumDarkGray),
                    ), // Width of the circular container
                    child: Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: SvgPicture.asset(

                              'assets/img/locate.svg',
                            ),
                          ),
                          SizedBox(width: 8.w,),
                          Text(
                            'Cairo ',
                            style: TextStyles.urbanistMedium14Light,
                            overflow: TextOverflow.ellipsis,
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                  Text(
                    'price',
                    style: TextStyles.urbanistMedium14LightGray,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$$price',
                    style: TextStyles.urbanistSemiBold18Light,
                  ),
                ],
              ),
            ],
          ),
        ),
          Positioned(
            top: 35,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Add functionality here
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/img/call.svg',
                  ),
                  SizedBox(height: 50.h,),
                  SvgPicture.asset(
                    'assets/img/call.svg',
                  ),
                ],
              ),
            ),

          ),
  ]
      ),
    );
  }
}
