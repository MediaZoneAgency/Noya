import 'package:broker/core/sharedWidgets/network_image.dart';
import 'package:broker/core/sharedWidgets/property_card.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theming/colors.dart';
import '../../../unitDetails/ui/screen/unit_details_screen.dart'; // Add this package for SVG handling


class LikeItem extends StatelessWidget {
  const LikeItem(this.unit, {super.key, this.onremove});
  final UnitModel unit;
  final Function()? onremove;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnitDetailsScreen(
                unit: unit, // Replace 'someUnitModel' with the actual UnitModel object
              ),
            ),
          );
        },
        child: Stack(
          children: [
            // Main container
            Container(
              width: 357.w,
              height: 450.h,
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
                    // Image container
                    Container(
                      width: 317.w,
                      height: 211.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AppCachedNetworkImage(
                        image: unit.images?.first ??
                            'https://via.placeholder.com/150', // Default image
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PropertyCard(
                        location: unit.location ?? "Not valid location",
                        type: unit.type ?? "Not valid type",
                        price: unit.price ?? "Not valid price",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Trash icon positioned on top right
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onremove,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/img/TRASH.svg', // Replace with your SVG path
                   // Optional: change icon color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
