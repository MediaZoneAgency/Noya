import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/chat/logic/chat_cubit.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // يتم تعيينه مرة واحدة عند إنشاء الواجهة
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  final List<String> timeSlots = ["10:00 AM", "12:00 PM", "2:00 PM", "4:00 PM"];

  @override
  Widget build(BuildContext context) {
    // ================== ✅ التعديل هنا ==================
    // نحصل على بداية اليوم الحالي (الساعة 00:00:00)
    final now = DateTime.now();
    final todayAtMidnight = DateTime(now.year, now.month, now.day);
    // ======================================================

    final String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'ar').format(selectedDate);

    return Container(
      width: 341,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: ColorsManager.GrayLIght.withOpacity(0.13),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoCalendar(
            mainColor: ColorsManager.gray,
            initialDateTime: selectedDate,
            // ================== ✅ التعديل هنا ==================
            minimumDateTime: todayAtMidnight, // استخدام بداية اليوم كحد أدنى
            // ======================================================
            maximumDateTime: now.add(const Duration(days: 365)),
            mode: CupertinoCalendarMode.date,
            onDateTimeChanged: (dt) {
              setState(() {
                selectedDate = dt;
                selectedTime = null;
              });
            },
            headerDecoration: CalendarHeaderDecoration(
              monthDateStyle: TextStyle(color: ColorsManager.WhiteGray),
            ),
            weekdayDecoration: CalendarWeekdayDecoration(
              textStyle: const TextStyle(color: Colors.white70),
            ),
            monthPickerDecoration: CalendarMonthPickerDecoration(
              defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
                textStyle: TextStyle(color: ColorsManager.WhiteGray),
              ),
              selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
                backgroundCircleColor: ColorsManager.green,
                textStyle: const TextStyle(color: Colors.white),
              ),
              currentDayStyle: CalendarMonthPickerCurrentDayStyle(
                textStyle: TextStyle(color: ColorsManager.WhiteGray),
              ),
              disabledDayStyle: CalendarMonthPickerDisabledDayStyle(
                textStyle: TextStyle(color: ColorsManager.gray.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  "الوقت المتاح ليوم:",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            alignment: Alignment.center,
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(41.r),
              border: Border.all(color: Colors.white24),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.black87,
                hint: const Text(
                  "اختر الوقت المناسب",
                  style: TextStyle(color: Colors.white70),
                ),
                value: selectedTime,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
                items: timeSlots.map((slot) {
                  return DropdownMenuItem<String>(
                    value: slot,
                    child: Center(child: Text(slot)),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ChatCubit>().addMessageAndFetchResponse('تم إلغاء تحديد الموعد.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38.r),
                    ),
                  ),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("برجاء اختيار الوقت أولاً")),
                      );
                      return;
                    }
                    final String message = "أرغب في حجز موعد يوم $formattedDate الساعة $selectedTime";
                    context.read<ChatCubit>().addMessageAndFetchResponse(message);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.green,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38.r),
                    ),
                  ),
                  child: const Text(
                    "تأكيد الحجز",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}