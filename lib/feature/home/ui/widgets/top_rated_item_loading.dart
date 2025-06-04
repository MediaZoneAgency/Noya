import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theming/styles.dart';

class TopPropertyItemLoading extends StatelessWidget {
  const TopPropertyItemLoading({super.key} );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 250.w,
        height: 300.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            // استخدام CachedNetworkImage
            CachedNetworkImage(
              imageUrl: "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8189.jpg",
              fit: BoxFit.cover,
              width: 250.w,
              height: 300.h,
            ),
            // Gradient overlay
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
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            // باقي الكود الخاص بالـ Stack
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'starts from',
                    style: TextStyles.latoLight18DarkGray,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                     " error in price",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    " error in type",
                    style: TextStyles.latoLight18DarkGray,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    " error in location",
                    style: TextStyles.latoBold10lightWhite,
                  ),
                ],
              ),
            ),
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
                  child: SvgPicture.asset(
                    'assets/img/heart.svg',
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
