// lib/core/sharedWidgets/property_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; //  ✅ استيراد مكتبة intl لتنسيق الأرقام
import '../theming/styles.dart';

class PropertyCard extends StatelessWidget {
  final String location;
  final String type;
  final String price;

  const PropertyCard({
    super.key,
    required this.location,
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // --- بداية قسم الحسابات الديناميكية ---

    // 1. تنظيف السعر وتحويله إلى رقم عشري (double)
    final cleanedPriceString = price.replaceAll(RegExp(r'[^0-9.]'), '');
    final double priceValue = double.tryParse(cleanedPriceString) ?? 0.0;

    // 2. حساب الدفعة المقدمة (5%)
    final double downPaymentValue = priceValue * 0.05;

    // 3. حساب المبلغ المتبقي
    final double remainingAmount = priceValue - downPaymentValue;

    // 4. حساب القسط الشهري على 7 سنوات (84 شهرًا)
    final double monthlyInstallment = remainingAmount / (7 * 12);
    
    // 5. استخدام NumberFormat لتنسيق الأرقام وإضافة الفواصل
    final numberFormatter = NumberFormat("#,##0", "en_US");
    final formattedPrice = numberFormatter.format(priceValue);
    final formattedDownPayment = numberFormatter.format(downPaymentValue);
    final formattedMonthlyInstallment = numberFormatter.format(monthlyInstallment);

    // --- نهاية قسم الحسابات الديناميكية ---

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- قسم السعر ---
        Text(
          'Price',
          style: TextStyles.urbanistMedium14LightGray,
        ),
        SizedBox(height: 8.h),
        Text(
          '$formattedPrice LE', // استخدام السعر المنسق
          style: TextStyles.urbanistSemiBold18Light.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 20.h),

        // --- قسم التقسيط والدفعة المقدمة ---
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installments / 7 Yrs', // توضيح المدة
                    style: TextStyles.urbanistMedium14LightGray,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$formattedMonthlyInstallment LE/mo', // عرض القسط الشهري المنسق
                    style: TextStyles.urbanistSemiBold18Light,
                    maxLines: 1, // ضمان عدم تجاوز السطر
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w), // مسافة فاصلة بسيطة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DownPayment (5%)', // توضيح النسبة
                    style: TextStyles.urbanistMedium14LightGray,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$formattedDownPayment LE', // عرض الدفعة المقدمة المنسقة
                    style: TextStyles.urbanistSemiBold18Light,
                     maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // --- زر عرض التفاصيل ---
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            onPressed: () {
              print("View Property Details Tapped!");
            },
            child: Text(
              'View Property Details',
              style: TextStyles.urbanistMedium14Light.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}