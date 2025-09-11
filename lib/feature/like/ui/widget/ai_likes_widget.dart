// lib/feature/wishlist/ui/widget/wishlist_item_card.dart

import 'package:broker/core/sharedWidgets/network_image.dart'; // تأكد من صحة هذا المسار
import 'package:broker/core/theming/colors.dart'; // تأكد من صحة هذا المسار
import 'package:broker/feature/home/data/models/unit_model.dart'; // تأكد من صحة هذا المسار
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistItemCard extends StatelessWidget {
   // ✅ الخطوة 1: تعريف المتغيرات
  final UnitModel unit;
  final VoidCallback onRemove;
  final VoidCallback onRequestMeeting;
  final VoidCallback onViewDetails;

  const WishlistItemCard({
    Key? key,
    required this.unit,
    required this.onRemove,
    required this.onRequestMeeting,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ⛔️ لم نعد بحاجة للبيانات الثابتة
    // const String imageUrl = '...';

    return Container(
      width: 341.w,
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2522).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // الصورة على اليسار
                  SizedBox(
                    width: 140.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppCachedNetworkImage(
                            // ✅ الخطوة 2: استخدام بيانات الوحدة الحقيقية
                            image: unit.images?.first ?? '',
                            fit: BoxFit.cover,
                          ),
                          // يمكن جعل نقاط التمرير ديناميكية إذا أردت
                          // ...
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // التفاصيل على اليمين
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    // ✅ استخدام بيانات الوحدة الحقيقية
                                    unit.type ?? 'Property',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // يمكنك إضافة لوجو الشركة هنا إذا كان متوفرًا في UnitModel
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              // ✅ استخدام بيانات الوحدة الحقيقية
                              unit.location ?? 'Unknown Location',
                              style: GoogleFonts.lato(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                                'Price',
                                unit.price ?? 'N/A',
                                'Installments',
                                unit.price ?? 'N/A'), // افترض وجود installments في الموديل
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                                'DownPayment',
                                unit.price ?? 'N/A', // افترض وجود downPayment في الموديل
                                '',
                                ''),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 35.h,
                          child: ElevatedButton(
                            // ✅ ربط الدالة بالزر
                            onPressed: onViewDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              'View Property Details',
                              style: GoogleFonts.lato(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 16.h),

            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         // ✅ ربط الدالة بالزر
            //         onPressed: onRequestMeeting,
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: ColorsManager.mainDarkGray,
            //           foregroundColor: Colors.white,
            //           minimumSize: Size.fromHeight(45.h),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12.r),
            //           ),
            //         ),
            //         child: Text('Request Meeting', style: GoogleFonts.lato()),
            //       ),
            //     ),
            //     SizedBox(width: 12.w),
            //     Expanded(
            //       child: ElevatedButton(
            //         // ✅ ربط الدالة بالزر
            //         onPressed: onRemove,
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: const Color(0xFF451919),
            //           foregroundColor: Colors.white,
            //           minimumSize: Size.fromHeight(45.h),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12.r),
            //           ),
            //         ),
            //         child: Text('Remove', style: GoogleFonts.lato()),
            //       ),
            //     )
            //   ],
            // )
         
          ],
        ),
      ),
    );
  }
  Widget _buildDetailRow(String title1, String value1, String title2, String value2) {
    return Row(
      children: [
        Expanded(child: _buildDetailItem(title1, value1)),
        if (title2.isNotEmpty) Expanded(child: _buildDetailItem(title2, value2)),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}