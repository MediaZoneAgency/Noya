// lib/core/sharedWidgets/unit_item.dart

import 'package:broker/core/sharedWidgets/network_image.dart';
import 'package:broker/core/sharedWidgets/property_card.dart';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../feature/unitDetails/ui/screen/unit_details_screen.dart';

class UnitItem extends StatelessWidget {
  const UnitItem(
    this.unit, {
    super.key,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final UnitModel unit;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(16),
                child: UnitDetailsScreen(unit: unit),
              );
            },
          );
        },
        child: Container(
          width: 362.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(217, 217, 217, 0.2331),
                Color.fromRGBO(115, 115, 115, 0.1701),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // استخدام padding موحد
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- قسم العنوان ---
                Text(
                   unit.type ?? "Unit Details", // عرض الاسم أو النوع
                  style: TextStyles.urbanistSemiBold18Light,
                ),
                SizedBox(height: 12.h),

                // +++ بداية الإصلاح الرئيسي +++
                // تغليف الصورة بـ Expanded لجعلها مرنة في ارتفاعها
                Expanded(
                  child: Stack(
                    children: [
                      // إزالة الـ Container المحيط بـ ClipRRect لتبسيط الكود
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AppCachedNetworkImage(
                          image: unit.images?.first ?? '',
                          width: double.infinity,
                          // ❗️ تم إزالة الارتفاع الثابت (height: 220.h)
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: isFavorite
                                  ? SvgPicture.asset("assets/img/heartfull.svg")
                                  : SvgPicture.asset("assets/img/heart.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // +++ نهاية الإصلاح الرئيسي +++

                // --- قسم تفاصيل السعر ---
                Padding(
                  padding: const EdgeInsets.only(top: 12.0), // إضافة مسافة علوية
                  child: PropertyCard(
                    location: unit.location ?? "not valid location",
                    type: unit.type ?? "not valid type",
                    price: unit.price ?? "0",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}