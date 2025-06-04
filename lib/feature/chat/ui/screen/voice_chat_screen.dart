// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../logic/chat_cubit.dart';
//
// class VoiceChatScreen extends StatefulWidget {
//   const VoiceChatScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VoiceChatScreen> createState() => _VoiceChatScreenState();
// }
//
// class _VoiceChatScreenState extends State<VoiceChatScreen> {
//   bool _isRecording = false;
//   late ChatCubit chatCubit; // ✅ إنشاء متغير لتخزين المرجع إلى ChatCubit
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//     chatCubit = BlocProvider.of<ChatCubit>(context); // ✅ حفظ المرجع عند بدء الشاشة
//     chatCubit.initializeWebSocket(); // ✅ الاتصال بـ WebSocket عند فتح الشاشة
//   }
//
//   @override
//   void dispose() {
//     chatCubit.close(); // ✅ استخدم المرجع المخزن بدلاً من استدعاء BlocProvider.of مباشرةً
//     super.dispose();
//   }
//
//   Future<void> requestPermissions() async {
//     var statuses = await [
//       Permission.microphone,
//       Permission.storage,
//     ].request();
//
//     print("Microphone permission: ${statuses[Permission.microphone]}");
//     print("Storage permission: ${statuses[Permission.storage]}");
//
//     if (statuses[Permission.microphone]!.isDenied ||
//         statuses[Permission.storage]!.isDenied) {
//       openAppSettings();
//     }
//   }
//   void _toggleRecording() {
//     if (_isRecording) {
//       chatCubit.stopRecordingAndSend(); // ✅ استخدم المرجع بدلاً من BlocProvider.of
//     } else {
//       chatCubit.startRecording();
//     }
//     setState(() {
//       _isRecording = !_isRecording;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         title: const Text("Voice Chat"),
//         backgroundColor: Colors.black,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               BlocBuilder<ChatCubit, ChatState>(
//                 builder: (context, state) {
//                   if (state is RecordingInProgress) {
//                     return Lottie.asset('assets/img/Animation - 1736435129069.json');
//                   } else if (state is BotResponseReceived) {
//                     return const Text(
//                       "Listening...",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     );
//                   } else if (state is ChatError) {
//                     return Text(
//                       state.errorMessage,
//                       style: const TextStyle(color: Colors.red),
//                     );
//                   } else {
//                     return const Text(
//                       "Press and hold to speak",
//                       style: TextStyle(color: Colors.white70),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 50),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     chatCubit.stopRecordingAndSend();
//                   } else {
//                     chatCubit.startRecording();
//                   }
//                   setState(() {
//                     _isRecording = !_isRecording;
//                   });
//                 },
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: _isRecording ? Colors.red : Colors.blueAccent,
//                   child: Icon(
//                     _isRecording ? Icons.mic : Icons.mic_none,
//                     size: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import '../../../../core/helpers/cash_helper.dart';

import 'package:broker/core/theming/styles.dart';
import 'package:flutter/material.dart';

import '../../data/repo/websokect_services.dart';
import 'package:flutter/material.dart';

class WebSocketScreen extends StatefulWidget {
  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final WebSocketService _webSocketService = WebSocketService(userId: 46);

  bool _isRecording = false;
  bool _isSpeaking = false;
  late final Stream<bool> _speakingStream;

  @override
  void initState() {
    super.initState();

    // الاتصال بالخدمة
    _webSocketService.connect();

    // الاستماع لحالة الكلام
    _speakingStream = _webSocketService.speakingStatusStream;
    _speakingStream.listen((isSpeaking) {
      setState(() {
        _isSpeaking = isSpeaking;
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.stopListening();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await _webSocketService.startListening();
    } else {
      await _webSocketService.startListening();
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1F1F),
      appBar: AppBar(
        title: Text(
          "Broker Chat",
          style: TextStyles
              .latoBold22White, // أو استخدم TextStyle عادي إذا لم يكن لديك TextStyles
        ),
        backgroundColor: const Color(0xff2B2B2B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              color: _isRecording ? Colors.red : Colors.white,
              size: 64,
            ),
            SizedBox(height: 20),
            Text(
              _isRecording
                  ? _isSpeaking
                      ? "🎙️ Recording... (You are speaking)"
                      : "🔇 Recording... (Silent)"
                  : "🎤 Tap to start recording",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(
                _isRecording ? "Stop Recording" : "Start Recording",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
