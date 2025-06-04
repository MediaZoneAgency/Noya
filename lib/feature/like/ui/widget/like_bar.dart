import 'package:broker/feature/home/ui/widgets/unit_type_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theming/styles.dart';

class LikeBar extends StatelessWidget {
  final String username;


  const LikeBar({
    super.key,
    required this.username,

  });

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
                child: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/img/740712ae-9eae-4b47-b8cf-bee8736f3b46.jpg'), // Profile image URL
                ),
              ),

              const SizedBox(width: 8),

              // Greeting text
              Text(
                'Hi,  $username!',
                style: TextStyles.inter22BoldWhite
              ),

              Spacer(),
              Container(
                width: 40,  // Width of the circular container
                height: 40, // Height of the circular container
                decoration: BoxDecoration(
                  color: const Color(0xFF23273F), // Dark navy color background
                  shape: BoxShape.circle,),

                child: IconButton(
                  icon: SvgPicture.asset(
                    width: 30,
                    height: 30,
                    'assets/img/notification.svg',
                  ),
                  onPressed: () {
                    // Notification button tapped
                  },
                ),
              ),
            ],),
SizedBox(height: 8.h,),
          Text(
            'Like',
            style: TextStyles.latoBold36white.copyWith(
              wordSpacing:1,height: 1
            )
          ),
          SizedBox(height: 8.h,),
        ],
      ),

    );
  }
}