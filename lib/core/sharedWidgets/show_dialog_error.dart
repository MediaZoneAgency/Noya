import 'package:flutter/material.dart';

import '../theming/colors.dart';

class ShowDialogError {
  static void showErrorDialog(
      BuildContext context,
      String title,
      String message,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.only(right: 20, bottom: 10),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white, // Adjusted color for visibility
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ColorsManager.darkBlack, // Ensure text color contrasts with background
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: ColorsManager.darkBlack, // Ensure text color contrasts with background
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorsManager.mainBlue),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Try again',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Ensure button text is visible
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
