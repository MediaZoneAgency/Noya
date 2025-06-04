import 'package:broker/feature/home/ui/widgets/unit_type_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theming/styles.dart';

class ChatBar extends StatelessWidget {



  const ChatBar({
    super.key,


  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/img/openai_logo.jpg",
          height: 30,
          width: 30,),
      SizedBox(width: 12.h,),
          Text(
            'Nour',
            style: TextStyles.latoBold36white.copyWith(
              wordSpacing:1,height: 1,
              fontSize: 28.sp
            )
          ),
          SizedBox(height: 8.h,),
        ],
      ),

    );
  }
}