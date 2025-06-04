import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toggle_switch/toggle_switch.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

class StayGoSwitch extends StatefulWidget {
  const StayGoSwitch({super.key});

  @override
  State<StayGoSwitch> createState() => _StayGoSwitchState();
}

class _StayGoSwitchState extends State<StayGoSwitch> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        SizedBox(height: 22.h),
        Center(
          child: ToggleSwitch(
            radiusStyle: true,
            minWidth: double.infinity,
            cornerRadius: 20.0.r,
            initialLabelIndex: _currentIndex,
            doubleTapDisable: false, 
            totalSwitches: 2, 
            labels: const ['Yearly', 'Monthly'],
            inactiveBgColor: Colors.white,
            customTextStyles: [
              _currentIndex == 0
                  ? TextStyles.inter13SemiBoldLightGray
                      .copyWith(color: Colors.white)
                  : TextStyles.inter13SemiBoldLightGray,
              _currentIndex == 1
                  ? TextStyles.inter13SemiBoldLightGray
                      .copyWith(color: Colors.white)
                  : TextStyles.inter13SemiBoldLightGray,
            ],
          
            activeBgColors: const [
              [ColorsManager.mainBlUE], 
              [ColorsManager.mainBlUE], 
            ],
            onToggle: (index) {
              if (index != null) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),
        ),
        SizedBox(height: 20.h),
        _currentIndex == 0 ? const Text('Yearly') : const Text('monthly'),
      ],
    );
  }
}
