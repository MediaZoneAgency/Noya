// lib/feature/bookings/ui/widget/appointment_card.dart

import 'package:broker/core/sharedWidgets/network_image.dart';
import 'package:broker/feature/booking/data/models/booking,odel.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Helper function to format numbers with commas
String _formatNumber(String priceString) {
  try {
    final number = double.parse(priceString);
    final format = NumberFormat("#,##0", "en_US");
    return format.format(number);
  } catch (e) {
    return priceString; // Return original string if parsing fails
  }
}

class AppointmentCard extends StatelessWidget {
  final UnitModel unit;
  final BookingModel booking;
  final VoidCallback onCancel; // Kept for future use, but not shown in UI
  final VoidCallback onViewDetails;

  const AppointmentCard({
    Key? key,
    required this.unit,
    required this.booking,
    required this.onCancel,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date and time for display based on the design
    final formattedDate = DateFormat('EEEE, d MMMM').format(booking.viewingDate);
    // Example time format from design, adjust as needed
    final formattedTime = "08:00 - 09:00 AM";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ================== Main Card Body ==================
        Container(
          width: 340.w,
         height: 165, // Matching design widt
          padding: EdgeInsets.fromLTRB(9, 8, 16, 8),
               decoration: BoxDecoration(
          gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E5950).withOpacity(0.63),
                  const Color(0xFF0F2E2A).withOpacity(0.63)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IntrinsicHeight( // This ensures both sides of the row have the same height
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Left side: Image ---
               Container(
                 
                   decoration: BoxDecoration(
          
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
                    width: 158.w,
                    height: 158,
                    child: AppCachedNetworkImage(
                      radius: 6.r,
                      image: unit.images?.first ?? '',
                      fit: BoxFit.cover,
                    ),
                  
                ),
                SizedBox(width: 6.w),

                // --- Right side: Details ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property Name and Location
                      Text(
                        unit.type ?? 'Property Name',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    //  SizedBox(height: 4.h),
                      Text(
                        unit.location ?? 'Unknown Location',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11.sp,
                        ),
                      ),
                      
                   // Pushes details down

                      // Price, Installments, DownPayment
                      _buildDetailRow(
                        'Price', '${_formatNumber(unit.price ?? '0')} LE',"",""
                       // Example data
                      ),

                      SizedBox(height: 8.h),
                      _buildDetailRow(
                        'DownPayment', '1,200,000 EGP', // Example data
                        '', ''
                      ),

                  // Pushes button to the bottom

                      // View Details Button
                      Container(
                        width: 200,
                       height: 30,
                          decoration: BoxDecoration(
        
            borderRadius: BorderRadius.only(topLeft:Radius.circular(6.r),topRight: Radius.circular(6.r),bottomLeft: Radius.circular(6.r),bottomRight: Radius.circular(6.r)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
                        child: 
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1,1 , 1, 1),
                          child:
                          TextButton(
  style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(6.0) ),
          ),
            backgroundColor: MaterialStatePropertyAll(
           Colors.white,
        ),
        ),
                            onPressed: onViewDetails,
                          
                            child: Text(
                              'View Property Details',
                              style: GoogleFonts.urbanist(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ================== Bottom Part: Appointment Info ==================
        SizedBox(height: 12.h),
        Container(
          width: 340.w,
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          decoration: BoxDecoration(
            color: const Color(0xFF132A27),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            children: [
              _buildDateTimeInfo(Icons.calendar_today_outlined, formattedDate),
              const Spacer(),
              _buildDateTimeInfo(Icons.access_time_rounded, formattedTime),
            ],
          ),
        ),
        SizedBox(height: 16.h), // Space between cards
      ],
    );
  }

  // Helper widget for Date and Time info
  Widget _buildDateTimeInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16.sp),
        SizedBox(width: 8.w),
        Text(
          text,
          style: GoogleFonts.lato(color: Colors.white, fontSize: 13.sp),
        ),
      ],
    );
  }

  // Helper widget for detail rows (Price, Installments, etc.)
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
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}


// lib/feature/bookings/ui/widget/appointment_card.dart

// import 'package:broker/core/sharedWidgets/network_image.dart';
// import 'package:broker/feature/booking/data/models/booking,odel.dart'; // تأكد من صحة اسم الملف
// import 'package:broker/feature/home/data/models/unit_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// // دالة مساعدة لتنسيق الأرقام مع فواصل
// String _formatNumber(String? priceString) {
//   if (priceString == null) return "N/A";
//   try {
//     // إزالة أي حروف أو رموز غير رقمية باستثناء النقطة
//     final sanitizedPrice = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
//     final number = double.parse(sanitizedPrice);
//     final format = NumberFormat("#,##0", "en_US");
//     return format.format(number);
//   } catch (e) {
//     return priceString; // إرجاع النص الأصلي في حالة فشل التحويل
//   }
// }

// class AppointmentCard extends StatelessWidget {
//   final UnitModel unit;
//   final BookingModel booking;
//   final VoidCallback? onCancel; // جعله اختياريًا
//   final VoidCallback onViewDetails;

//   const AppointmentCard({
//     Key? key,
//     required this.unit,
//     required this.booking,
//     this.onCancel,
//     required this.onViewDetails,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // تنسيق التاريخ والوقت بناءً على التصميم
//     final formattedDate = DateFormat('EEEE, d MMMM').format(booking.viewingDate);
//     final formattedTime = "08:00 - 09:00 AM"; // بيانات مثال من التصميم

//     return Padding(
//       // إضافة padding بين البطاقات
//       padding: EdgeInsets.only(bottom: 20.h), 
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ================== جسم البطاقة الرئيسي ==================
//           Container(
//             width: 340.w,
//             height: 183.h, // مطابقة ارتفاع التصميم
//             padding: EdgeInsets.all(9),
//             decoration: BoxDecoration(
//               // ✅ تطبيق التدرج اللوني من التصميم
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFF1E5950).withOpacity(0.63),
//                   const Color(0xFF0F2E2A).withOpacity(0.63)
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16.11.r), // مطابقة التصميم
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 // --- الجزء الأيسر: الصورة ---
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6.r),
//                   child: SizedBox(
//                     width: 150, // تعديل العرض ليتناسب مع المساحة
//                     height: 158,
//                     child: AppCachedNetworkImage(
//                       image: unit.images?.first ?? '',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 14.w),

//                 // --- الجزء الأيمن: التفاصيل ---
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // اسم العقار والموقع
//                       SizedBox(
//                         height: 34.h, // مطابقة ارتفاع التصميم
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               unit.type ?? 'Mountain View',
//                               style: GoogleFonts.inter( // ✅ استخدام خط Inter
//                                 color: Colors.white,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600, // Semi-bold
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               unit.location ?? 'Sheikh Zayed',
//                               style: GoogleFonts.inter(
//                                 color: Colors.white.withOpacity(0.7),
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
                      
//                       SizedBox(height: 12.h),

//                       // السعر، الأقساط، الدفعة المقدمة
//                       _buildDetailRow(
//                         'Price', '${_formatNumber(unit.price)} LE',
//                         'Installments', '7 Years'
//                       ),
//                       SizedBox(height: 10.h),
//                       _buildDetailRow(
//                         'DownPayment', '${_formatNumber("1200000")} EGP',
//                         '', '' // لا يوجد عنصر ثانٍ في هذا الصف
//                       ),

//                       const Spacer(), // يدفع الزر إلى الأسفل

//                       // زر عرض التفاصيل
//                       SizedBox(
//                         width: 123.24.w, // مطابقة عرض التصميم
//                         height: 30.97.h, // مطابقة ارتفاع التصميم
//                         child: ElevatedButton(
//                           onPressed: onViewDetails,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: const Color(0xFF1E1E1E), // لون النص أسود
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.06.r),
//                             ),
//                             padding: EdgeInsets.zero, // لإزالة الـ padding الافتراضي
//                           ),
//                           child: Text(
//                             'View Property Details',
//                             style: GoogleFonts.urbanist(
//                               fontSize: 9.sp,
//                               fontWeight: FontWeight.w500, // Medium
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ================== الجزء السفلي: معلومات الموعد ==================
//           SizedBox(height: 12.h),
//           Container(
//             width: 340.w,
//             height: 50.h,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF0F2E2A).withOpacity(0.8),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildDateTimeInfo(Icons.calendar_today_outlined, formattedDate),
//                 _buildDateTimeInfo(Icons.access_time_rounded, formattedTime),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ودجت مساعد لمعلومات التاريخ والوقت
//   Widget _buildDateTimeInfo(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white70, size: 15.sp),
//         SizedBox(width: 8.w),
//         Text(
//           text,
//           style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
//         ),
//       ],
//     );
//   }

//   // ودجت مساعد لصفوف التفاصيل (السعر، الأقساط، إلخ)
//   Widget _buildDetailRow(String title1, String value1, String title2, String value2) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: _buildDetailItem(title1, value1)),
//         if (title2.isNotEmpty) Expanded(child: _buildDetailItem(title2, value2)),
//       ],
//     );
//   }

//   Widget _buildDetailItem(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.inter(
//             color: Colors.white.withOpacity(0.6),
//             fontSize: 11.sp,
//           ),
//         ),
//         SizedBox(height: 3.h),
//         Text(
//           value,
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600, // Semi-bold
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }