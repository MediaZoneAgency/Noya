import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class OptionSelector extends StatefulWidget {
  final List<String> options;
  final Color selectedColor;
  final Color unselectedColor;
  final Color textColor;

  const OptionSelector({
    Key? key,
    required this.options,
    this.selectedColor = ColorsManager.mainBlUE,
    this.unselectedColor = ColorsManager.mainDarkGray,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  _OptionSelectorState createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  String? selectedOption; // Track the selected option

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.map((option) {
        final isSelected = selectedOption == option;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = option;
              });
            },
            child: Container(
              width: 52.w,
              height: 31.h,
           margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? widget.selectedColor : widget.unselectedColor,
                borderRadius: BorderRadius.circular(15.52),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyles.inter13SemiBoldWhite
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
