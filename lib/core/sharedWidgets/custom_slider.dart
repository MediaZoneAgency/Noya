import 'package:flutter/material.dart';

import '../theming/styles.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({Key? key}) : super(key: key);

  @override
  _PriceRangeSliderState createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  double _currentValue = 200.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Slider(
          value: _currentValue,
          min: 0.0,
          max: 400.0,
          divisions: 400,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          label: '\$${_currentValue.toInt().toString()}',
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0),
        //   child: Text(
        //     '\$${_currentValue.toInt().toString()}',
        //     style: const TextStyle(
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}