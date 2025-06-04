import 'package:broker/feature/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/sharedWidgets/image_network.dart';
import '../../../../core/theming/styles.dart';

class UnitTypeItem extends StatelessWidget {

 final CategoryModel model;
final Color backGroundColor;
final Color textColor;
  const UnitTypeItem({
    super.key, required this.model, required this.backGroundColor, required this.textColor,});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 150.w,
      height: 40.h,
      //padding: EdgeInsets.only(left: 20, ),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(40),
       color:backGroundColor,
     ),


      child: Row(
       //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 3.w,),
          ImageNetwork(image: model.image, width: 40, height: 40, radius: 100,),
          SizedBox(width: 5.w,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: backGroundColor,
              ),
              child: Center(
                child: Text(
                  model.type,
                  style: TextStyles.inter9RegularWhite.copyWith(
                    color: textColor
                  )
                          ),
              ),
            ),
          )

        ],
      ),
    );
  }
}