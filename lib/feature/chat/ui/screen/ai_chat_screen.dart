import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/chat/data/model/bo_response_model.dart';
import 'package:broker/feature/chat/data/model/chat_model.dart';
import 'package:broker/feature/chat/ui/screen/chat_voice.dart';
import 'package:broker/feature/chat/ui/screen/test.dart';
import 'package:broker/feature/chat/ui/screen/voice_chat_screen.dart';
import 'package:broker/feature/map/ui/map_screen.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/screen/side_menu.dart';
import 'package:broker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theming/styles.dart';
import '../../logic/chat_cubit.dart';
import '../widget/chat_widget.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late TextEditingController typingController;
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isRecording = false;
  bool _hasSentFirstMessage = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
   ChatCubit.get(context).startChat();
    typingController = TextEditingController();
    _scrollController = ScrollController();
    ProfileCubit.get(context).getProfile();
    typingController.addListener(() {
      setState(() {
        _isTyping = typingController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> requestPermissions() async {
    var statuses = await [Permission.microphone].request();
    if (statuses[Permission.microphone]!.isPermanentlyDenied && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
              "Microphone permission is needed for voice input. Please enable it in app settings."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text("Open Settings")),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    typingController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final userMessage = typingController.text.trim();
    if (userMessage.isNotEmpty && mounted) {
      setState(() {
        _hasSentFirstMessage = true;
      });
      FocusScope.of(context).unfocus();
      context.read<ChatCubit>().addMessageAndFetchResponse(userMessage);
      typingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer: const CustomDrawer(),
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/image 2.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          ProfileCubit.get(context).profileUser?.image ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:BlocBuilder<ChatCubit, ChatState>(
builder: (context, state) {
final chatList = state.chatList;
if (chatList.isEmpty) {
return _buildWelcomeWidget();
}
return _buildChatList(chatList, context, state);
},
),
                ),
                
// ChatLocationPreview(latitude: 30.002165148149373, longitude:  30.974464501204057,),
                _buildBottomChatInput(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final name = ProfileCubit.get(context).profileUser?.name ?? '';
          return ListView(
            shrinkWrap: true, physics: ScrollPhysics(),
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 205,
                width: 111,
                child: Image.asset("assets/img/noya icon logo  1.png",
                    width: 111, fit: BoxFit.scaleDown),
              ),
              //    const SizedBox(height: 30),
              Text(
                "Hello, $name",
                style: TextStyles.interSemiBold38White.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "How Can I help you?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              // Text(
              //   "Lets Start Chat..",
              //   style: TextStyle(color: Colors.white.withOpacity(0.4)),
              // ),
              // const SizedBox(height: 8),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Image.asset(
              //     'assets/images/wave_animation.gif',
              //     width: 50,
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
Widget _buildChatList(
    List<dynamic> chatList, BuildContext context, ChatState currentState) {
  final bool isBotTyping = currentState is ChatLoading;

  // ❗️عرض آخر رسالة فقط (زائد مؤشر الكتابة إن وُجد)
  final lastMessageIndex = chatList.isNotEmpty ? chatList.length - 1 : null;
  final itemCount = (lastMessageIndex != null ? 1 : 0) + (isBotTyping ? 1 : 0);

  return ListView.builder(
    controller: _scrollController,
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
    itemCount: itemCount,
    itemBuilder: (context, index) {
      // 🔄 عرض مؤشر الكتابة
      if (isBotTyping && index == itemCount - 1) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white24,
                child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              DefaultTextStyle(
                style: const TextStyle(color: Colors.white, fontSize: 16),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('Analyzing...'),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                ),
              ),
            ],
          ),
        );
      }

      // 💬 عرض آخر رسالة فقط
      final chatItem = chatList[lastMessageIndex!];
      final message = chatItem.message ?? "Error: Message is null";
      final interactionMode = chatItem.interactionMode;
      final chatIndex = (interactionMode == "user") ? 0 : 1;
      final isThisMessageCurrentlyReceiving =
          (currentState is BotResponseReceived) &&
              (lastMessageIndex == chatList.length - 1);

      return ChatWidget(
        key: ValueKey('$interactionMode-$lastMessageIndex-${message.hashCode}'),
        msg: message,
        chatIndex: chatIndex,
        isCurrentlyReceiving: isThisMessageCurrentlyReceiving,
        onFeedback: (chatIndex == 1)
            ? (feedbackType, comment) {
                if (context.mounted) {
                  context.read<ChatCubit>().submitFeedback(
                        message: message,
                        feedbackType: feedbackType,
                        comment: comment,
                      );
                }
              }
            : null,
      );
    },
  );
}
  Widget _buildBottomChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 3,
              minLines: 1,
              controller: typingController,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                hintText: "How can I help you?",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (_isTyping) {
                  _sendMessage(context);
                } else {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    barrierColor:
                        Colors.black.withOpacity(0.5), // nice dark overlay
                    builder: (context) => VoiceChatScreen(),
                  );
                }
              },
          
             
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: _isTyping
                    ? Image.asset(
                        'assets/img/Group 2 (1).png',
                        width: 24,
                        height: 24,
                        // color: Colors.white,
                      )
                    : Image.asset(
                        'assets/img/Group 2.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
