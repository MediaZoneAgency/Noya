// lib/feature/chat/ui/screen/ai_chat_screen.dart

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/chat/logic/chat_cubit.dart';
import 'package:broker/feature/chat/ui/screen/chat_voice.dart';
import 'package:broker/feature/chat/ui/widget/chat_widget.dart';
import 'package:broker/feature/chat/ui/screen/voice_chat_screen.dart';
import 'package:broker/feature/like/logic/fav_cubit.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/screen/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiChatScreen extends StatefulWidget {
   final ZoomDrawerController controller;
  const AiChatScreen({super.key, required this.controller});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late TextEditingController typingController;
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
   // _initSpeech();
    // ابدأ الاتصال بالـ WebSocket فوراً
    context.read<ChatCubit>().startChat();
    typingController = TextEditingController();
    _scrollController = ScrollController();
    context.read<ProfileCubit>().getProfile();
    typingController.addListener(() {
      if (mounted) {
        setState(() => _isTyping = typingController.text.trim().isNotEmpty);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    typingController.dispose();
    _speechToText.cancel();
    super.dispose();
  }

  // --- دوال تحويل الكلام إلى نص (Speech To Text) تبقى كما هي ---
  Future<void> _initSpeech() async {
    await requestPermissions();
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => print('STT Error: ${error.errorMsg}'),
        onStatus: (status) {
          if (mounted) setState(() => _isListening = _speechToText.isListening);
        },
      );
    } catch (e) {
      _speechEnabled = false;
    }
  }

  void _startListening() async {
    if (!_speechEnabled || _speechToText.isListening) return;
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "ar_EG",
      partialResults: true,
    );
    if (mounted) setState(() {});
  }

  void _stopListening() async {
    if (!_speechToText.isListening) return;
    await _speechToText.stop();
    if (mounted && typingController.text.trim().isNotEmpty) {
      _sendMessage(context);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (mounted) {
      typingController.text = result.recognizedWords;
      typingController.selection = TextSelection.fromPosition(
          TextPosition(offset: typingController.text.length));
    }
  }

  Future<void> requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isPermanentlyDenied && mounted) {
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

  void _sendMessage(BuildContext context) {
    final userMessage = typingController.text.trim();
    if (userMessage.isNotEmpty && mounted) {
      FocusScope.of(context).unfocus();
      context.read<ChatCubit>().addMessageAndFetchResponse(userMessage);
      typingController.clear();
    }
  }

  void _scrollToBottom() {
    // تأكد من أن الـ scroll controller مرتبط بـ ListView
    // وانتظر لحظة بعد بناء الواجهة ليتمكن من التمرير
    if (_scrollController.hasClients) {
      Timer(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,

      // drawerEnableOpenDragGesture: false,
      // drawer: const CustomDrawer(),
      backgroundColor: Colors.transparent,
      body:
       SafeArea(
         child: Column(
           children: [
             // Padding(
             //   padding: const EdgeInsets.symmetric(
             //       horizontal: 16.0, vertical: 8.0),
             //   child: Row(
             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //     children: [
             //       IconButton(
             //         onPressed: () =>
             //             _scaffoldKey.currentState?.openDrawer(),
             //         icon: const Icon(Icons.menu, color: Colors.white),
             //       ),
             //       CircleAvatar(
             //         radius: 20,
             //         backgroundImage: NetworkImage(
             //           ProfileCubit.get(context).profileUser?.image ?? '',
             //         ),
             //       ),
             //     ],
             //   ),
             // ),
              AppBarHome(controller: widget.controller,), 
             Expanded(
               child: BlocBuilder<ChatCubit, ChatState>(
                 builder: (context, state) {
                   final chatList = state.chatList;
                   if (chatList.isEmpty && !_isListening) {
                     return _buildWelcomeWidget();
                   }
                   return _buildChatList(chatList, context, state);
                 },
               ),
             ),
             _buildBottomChatInput(context),
           ],
         ),
       ),
    );
  }
// lib/feature/chat/ui/screen/ai_chat_screen.dart -> _AiChatScreenState
Widget _buildWelcomeWidget() {
  // نستخدم SingleChildScrollView لجعل المحتوى قابلاً للتمرير
  return SingleChildScrollView(
    // يمكنك إضافة padding هنا إذا أردت مسافة حول كل المحتوى
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قمت بتغيير Spacer إلى SizedBox لأنه يعمل بشكل أفضل
          // داخل SingleChildScrollView. الـ Spacer يحاول أخذ كل المساحة
          // المتاحة مما يسبب مشاكل.
          SizedBox(height: 100.h), // يمكنك تعديل هذه القيمة حسب الحاجة

          Center(
            child: Image.asset(
              "assets/img/noya icon logo  1.png",
              height: 110.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 40.h),

          // BlocBuilder والنصوص تبقى كما هي، فهي صحيحة
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final name = ProfileCubit.get(context).profileUser?.name ?? 'there';

              return RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 46.7.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.58,
                    height: 1.1,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Hello, $name\n',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'How can I help you?',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // استبدال الـ Spacer الثاني أيضاً بـ SizedBox
          SizedBox(height: 150.h), // يمكنك تعديل هذه القيمة حسب الحاجة
        ],
      ),
    ),
  );
}
 Widget _buildChatList(
      List<dynamic> chatList, BuildContext context, ChatState currentState) {
    final bool isBotTyping = currentState is ChatLoading;

    final lastMessageIndex = chatList.isNotEmpty ? chatList.length - 1 : null;
    final itemCount =
        (lastMessageIndex != null ? 1 : 0) + (isBotTyping ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (isBotTyping && index == itemCount - 1) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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

        if (lastMessageIndex == null) return const SizedBox.shrink();

        final chatItem = chatList[lastMessageIndex];
        final message = chatItem.message ?? "Error: Message is null";
        final interactionMode = chatItem.interactionMode;
        final id =(interactionMode == "user")? "0":chatItem.messageId;
        final chatIndex = (interactionMode == "user") ? 0 : 1;
        final isThisMessageCurrentlyReceiving =
            (currentState is BotResponseReceived) &&
                (lastMessageIndex == chatList.length - 1);

        return ChatWidget(
          messageId: id,
          key: ValueKey(
              '$interactionMode-$lastMessageIndex-${message.hashCode}'),
          msg: message,
          chatIndex: chatIndex,
          isCurrentlyReceiving: isThisMessageCurrentlyReceiving,
          onFeedback: (chatIndex == 1)
              ? (messageId, feedbackType, comment) {
                  // <--- لاحظ البارامترات الجديدة
                  if (context.mounted) {
                    context.read<ChatCubit>().submitFeedback(
                          // <--- تم التغيير من message إلى messageId
                          feedbackType: feedbackType,
                          comment: comment,
                          messageId:id,
                        );
                  }
                }
              : null,
        );
      },
    );
  }

  // +++ هذه الدالة لم تتغير (بناءً على طلبك) +++
  Widget _buildBottomChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: _isListening ? Colors.red.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 3,
              minLines: 1,
              controller: typingController,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: _isListening ? "Listening..." : "How can I help you?",
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 8),
          if (!_isTyping)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _speechToText.isNotListening
                    ? _startListening
                    : _stopListening,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _isListening ? Icons.stop_circle_outlined : Icons.mic_none,
                    color: _isListening ? Colors.redAccent : Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (_isTyping) {
                  _sendMessage(context);
                } else {
                  final favCubit = BlocProvider.of<FavCubit>(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VoiceChatScreen(favCubit: favCubit),
                    ),
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


class AppBarHome extends StatelessWidget {
  final ZoomDrawerController controller;
  const AppBarHome({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- زر القائمة ---
          IconButton(
  onPressed: () {
    // Check if the controller's toggle function is not null before calling it
    if (controller.toggle != null) {
      controller.toggle!();
    }
  },
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          ),

          // --- صورة المستخدم ---
          // استخدام BlocBuilder يضمن تحديث الصورة تلقائياً عند تغييرها
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final userImage = context.read<ProfileCubit>().profileUser?.image;
              
              return CircleAvatar(
                radius: 22, // تم تكبير الحجم قليلاً ليتناسب مع التصميم
                backgroundColor: Colors.white24, // لون احتياطي في حالة عدم وجود صورة
                backgroundImage: (userImage != null && userImage.isNotEmpty)
                    ? NetworkImage(userImage)
                    : null,
                // في حالة عدم وجود صورة، أظهر أيقونة
                child: (userImage == null || userImage.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white, size: 24)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

// class AiChatRoot extends StatelessWidget {
//   const AiChatRoot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final zoomDrawerController = ZoomDrawerController();

//     return ZoomDrawer(
//       controller: zoomDrawerController,
//       slideWidth: MediaQuery.of(context).size.width * 0.85, // أكبر شوية زي التصميم
//       angle: 0, // مفيش ميلان
//       borderRadius: 24.0,
//       showShadow: true,
//       drawerShadowsBackgroundColor: Colors.grey[300]!,
//      // menuBackgroundColor: Colors.transparent,
      
//       // شاشة القائمة
//       menuScreen: SideMenu (
//         // controller: zoomDrawerController,
//         // pageController: PageController(), // لو عندك PageView جوه المنيو
//       ),

//       // شاشة الشات
//       mainScreen: Scaffold(
     
//   //       appBar: AppBar(
//   //        flexibleSpace: Container(
//   //   decoration: const BoxDecoration(
//   //     gradient: LinearGradient(
//   //       colors: [
//   //         Color(0xFF1A3A35),
//   //         Color(0xFF0E2522),
//   //       ],
//   //       begin: Alignment.topLeft,
//   //       end: Alignment.bottomRight,
//   //     ),
//   //   ),
//   // ),
//   //         elevation: 0,
//   //         leading: IconButton(
//   //           icon: Icon(Icons.menu, size: 30.sp, color: Colors.black),
//   //           onPressed: () => zoomDrawerController.toggle!(),
//   //         ),
//   //       ),
//         body: Container(
          
//            decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [
//           Color(0xFF1A3A35),
//           Color(0xFF0E2522),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),
          
//           child: const AiChatScreen()),
//       ),
//     );
//   }
// }

// lib/feature/chat/ui/screen/ai_chat_screen.dart

// ... (imports)

class AiChatRoot extends StatefulWidget {
  const AiChatRoot({super.key});

  @override
  State<AiChatRoot> createState() => _AiChatRootState();
}

class _AiChatRootState extends State<AiChatRoot> {

     late final ZoomDrawerController zoomDrawerController ;
  @override
  void initState() {
    super.initState();
    // 3. Initialize the controller here, only once
    zoomDrawerController = ZoomDrawerController();
  }
  @override
  Widget build(BuildContext context) {


    // Wrap the ZoomDrawer with a Container that has the background
    return Container(
      decoration: const BoxDecoration(
        // Use the same image you had in AiChatScreen
        image: DecorationImage(
          image: AssetImage('assets/img/image 2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ZoomDrawer( 
        controller: zoomDrawerController,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        angle: 0,
        borderRadius: 26.0,
          style: DrawerStyle.defaultStyle,
      //  showShadow: true,
            menuBackgroundColor: Colors.transparent,  
       drawerShadowsBackgroundColor: Colors.grey[300]!,
     //mainScreenOverlayColor: Colors.transparent, 
  mainScreen: ClipRRect( // 1. نستخدم ClipRRect لقص الحواف
          borderRadius: BorderRadius.circular(24.0), // يجب أن تكون نفس قيمة الـ ZoomDrawer
          child: Container(
            // 2. نستخدم Container لإضافة الإطار (Border)
            decoration: BoxDecoration(
              boxShadow:  [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4), // لون الظل وقوته
                  spreadRadius: 2, // مدى انتشار الظل
                  blurRadius: 15, // درجة التمويه (Blur)
                  offset: const Offset(-5, 0), // اتجاه الظل (X, Y) - هنا لليسار قليلاً
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // لون الإطار شفاف قليلاً
                width: 1.0, // سماكة الإطار
              ),
            ),
            // 3. بداخل الإطار نضع الشاشة الرئيسية
            child: AiChatScreen(controller: zoomDrawerController),
          ),
        ),
        
      menuScreen: SideMenu(controller: zoomDrawerController), // Corrected SideMenu call
      ),
    );
  }
}