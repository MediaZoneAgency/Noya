import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key, required this.title, required this.content, required this.img});
  final String title;
  final String content;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15,right: 15 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyles.poppinsSemiBold12White,
          ),
          SizedBox(height: 9),
          Container(
            height: 44.h,
            width: 320.w,
            decoration: const BoxDecoration(
              color:ColorsManager.mainThemeColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.only(left:13 ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    img,
                  ),
                  SizedBox(width: 5),
                  Text(
                    content,
                    style: TextStyles.poppinsMedium11ContantGray,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}