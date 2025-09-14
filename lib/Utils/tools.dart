import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../Utils/color_manager.dart';

class Tools {
  static showToast({
    required String message,
    required bool isSuccess,
    required BuildContext context,
  }) {
    var fToast = FToast().init(context);
    return fToast.showToast(
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: isSuccess ? Colors.green : Colors.redAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: SizedBox(
          width: 80.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check : Icons.clear,
                color: Colors.white,
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                width: 70.w,
                child: Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static loader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //Change Date Picker Theme Data
  static Theme selectDateTime(context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManager.primaryColor, //
            onPrimary: ColorManager.white, //selected text color
            onSurface: ColorManager.primaryColor, //color header and day text
            background: ColorManager.white,
          ),
          dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ), // color of button's letters
              backgroundColor: ColorManager.primaryColor,
              // Background color
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        child: child!,
      );
}
