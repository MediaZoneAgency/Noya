import 'package:broker/feature/home/ui/widgets/unit_type_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theming/styles.dart';

class HomeBar extends StatelessWidget {
  final String username;


  const HomeBar({
    Key? key,
    required this.username,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20,5,0),
                child: CircleAvatar(
                  radius: 28,
                  child: Image.asset(
                    'assets/img/avatarai.png', // Update the file path as needed
                   // Optional: Adjust how the image fits in the box
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Greeting text
              Text(
                'Hi,$username!',
                style: TextStyles.inter22BoldWhite
              ),

             Spacer(),
              IconButton(
                icon: SvgPicture.asset(
                  width: 30,
                  height: 30,
                  'assets/img/Group 37613.svg',
                ),
                onPressed: () {
                  // Notification button tapped
                },
              ),
            ],),
SizedBox(height: 8.h,),
          Text(
            'Dream, Discover,Chill',
            style: TextStyles.latoBold36white.copyWith(
              wordSpacing:1,height: 1
            )
          ),
          SizedBox(height: 8.h,),
          Row(
mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                 child:
               SvgPicture.asset(
                  width: 20.w,
                  height: 20.h,
                  'assets/img/location-add.svg',
                ),
              ),
              Text(
                  'Cairo-Egypt Eg',
                  style: TextStyles.inter7RegularGray
              ),

            ],
          ),

        ],
      ),

    );
  }
}