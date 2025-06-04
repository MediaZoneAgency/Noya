import 'package:broker/core/sharedWidgets/property_card.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/sharedWidgets/network_image.dart';
import '../../../../core/theming/colors.dart';
import '../../../unitDetails/ui/screen/unit_details_screen.dart';


class UiLoadingUnitItem extends StatelessWidget {
  const UiLoadingUnitItem( {super.key,  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        onDoubleTap: (){

        },
        child: Container(
          width: 357.w,
          height: 470.h,
          decoration: const BoxDecoration(
            color: ColorsManager.mainThemeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  width: 317.w,
                  height: 211.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8189.jpg", fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PropertyCard(location: "not valid location ", type:"not valid type ", price: "not valid price",),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
