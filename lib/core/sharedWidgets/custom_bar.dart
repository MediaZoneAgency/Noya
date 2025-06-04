

import 'package:flutter/material.dart';




class CustomBar extends StatelessWidget{
  const CustomBar({Key?key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
          height: 20,
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          SizedBox(
            width: 20,
          ),
          Container(width: 100,
              height: 100,

              child:

              Image.asset('assets/img/Broker..png')),

          SizedBox(
            width: 170,
          ),


        ],
      ),
    );
  }

}