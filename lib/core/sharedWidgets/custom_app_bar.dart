

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../utils/approute.dart';
import '../utils/routes.dart';

class CustomAppBar extends StatelessWidget{
  const CustomAppBar({Key?key}): super(key: key);

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
          Container(width: 100,
              height: 100,
              child: Image.asset('assets/img/Broker..png')),
          SizedBox(
            width: 170,
          ),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, Routes.loginScreen);
          }, icon: Icon(Icons.favorite)),

          IconButton(onPressed: (){
            Navigator.pushNamed(context, Routes.signUpScreen);
          }, icon: Icon(Icons.person)),
        ],
      ),
    );
  }

}