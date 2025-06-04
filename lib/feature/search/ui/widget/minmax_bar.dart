import 'dart:async';

import 'package:broker/feature/search/logic/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class CustomMinMaxBar extends StatefulWidget {
  const CustomMinMaxBar({super.key});

  @override
  State<CustomMinMaxBar> createState() => _CustomMinMaxBarState();
}

class _CustomMinMaxBarState extends State<CustomMinMaxBar> {
  Timer? time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( right: 0),
      child: Row(
        children: [
          Container(
            height: 36.8.h, // تحديد ارتفاع الحاوية
            width: 150.w,
            decoration: const BoxDecoration(
              color: ColorsManager.mainDarkGray,
              borderRadius: BorderRadius.all(Radius.circular(4.8)),
            ),
            child:TextFormField(
              style: TextStyles.inter12RegularWhite,
keyboardType: TextInputType.number,
               onChanged: (v){
                 time?.cancel();
                 time= Timer(Duration(milliseconds:  100),(){
                  SearchCubit.get(context).minPriceChange(double.parse(v));
                 });


               },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20.w,top: 15.h,bottom: 10.h),
                hintStyle: TextStyles.inter13MediumGray,
                border: InputBorder.none,
                hintText: 'Min',


              ),
            ),
          ),
         SizedBox(width: 15.52.w,),
          Container(
            height: 36.8.h, // تحديد ارتفاع الحاوية
            width:150.w,
            decoration: const BoxDecoration(
              color: ColorsManager.mainDarkGray,
              borderRadius: BorderRadius.all(Radius.circular(4.8)),
            ),
            child:TextFormField(
              style: TextStyles.inter12RegularWhite,
              keyboardType: TextInputType.number,
              onChanged: (v){
                time?.cancel();
                time= Timer(Duration(milliseconds:  100),(){
                  SearchCubit.get(context).maxPriceChange(double.parse(v));
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20.w,top: 15.h,bottom: 10.h),
                hintStyle: TextStyles.inter13MediumGray,
                border: InputBorder.none,
                hintText: 'Max',


              ),
            ),
          ),
        ],
      ),
    );
  }
}


