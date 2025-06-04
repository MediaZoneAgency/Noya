
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class CategoryFilterItem extends StatelessWidget {
  final bool isSelected;

  final VoidCallback onTap;
final String text;
  const CategoryFilterItem({
    super.key,

     required this.isSelected,
    required this.onTap, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       if  ( isSelected==false ){
      //   isSelected=true;
       }
        },
      child: Container(
width: 52.w,
        height: 31.h,
        decoration: BoxDecoration(

          color: isSelected ? ColorsManager.mainDarkGray : ColorsManager.mainDarkGray ,
          borderRadius: BorderRadius.circular(15.517),
          border: Border.all(
            color: isSelected ? ColorsManager.mainBlUE: Colors.transparent,
          )
        ),
        child: Center(
          child: Text(
           text,
            style:isSelected ? TextStyles.inter13MediumGray : TextStyles.inter13MediumGray,
          ),
        ),
      ),
    );
  }
}
