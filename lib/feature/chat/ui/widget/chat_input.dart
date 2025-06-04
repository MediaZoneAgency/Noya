import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key, required this.controller});
final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
     // color: Colors.black,
      child: Row(
        children: [

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
onSubmitted:(v){

} ,
                controller: controller,
                decoration: InputDecoration(

                  hintText: "HowCanIHeYou",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.mic, color: Colors.white),
            onPressed: () {
              // Handle microphone action
            },
          ),
        ],
      ),
    );
  }
}