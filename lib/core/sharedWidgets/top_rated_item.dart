import 'package:broker/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../feature/home/data/models/unit_model.dart';
import '../../feature/unitDetails/ui/screen/unit_details_screen.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';
import '../utils/routes.dart';

class TopPropertyItem extends StatelessWidget {
  const TopPropertyItem(this.unit,{super.key, required this.onTap, required this.isFavorite, this.addToFavourite} );
final UnitModel unit;
  final bool isFavorite;
  final Function() onTap;
  final Function()? addToFavourite;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailsScreen(
              unit: unit, // Replace 'someUnitModel' with the actual UnitModel object
            ),
          ),
        );
      },
      child: Container(
        width: 250.w,
        height: 300.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:unit.images!=null&&unit.images!.isNotEmpty?NetworkImage(unit.images![0]):AssetImage('assets/img/image (1).png')as ImageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            // Add a gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(), // To push content to the bottom
                  // Price and downpayment information
                  Text(
                    'starts from',
                    style: TextStyles.latoLight18DarkGray,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    unit.price?? " error in price" ,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    unit.type?? " error in type" ,
                    style: TextStyles.latoLight18DarkGray,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    unit.location?? " error in location" ,
                    style: TextStyles.latoBold10lightWhite,
                  ),
                ],
              ),
            ),
            // Circular button at the top right
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  // Add functionality here
                },
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: (){
                        onTap();
                      },
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: isFavorite

                            ? SvgPicture.asset(
                            "assets/img/heartfull.svg"
                            )
                            : SvgPicture.asset(
                          "assets/img/heart.svg",
                        ),
                      ))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
