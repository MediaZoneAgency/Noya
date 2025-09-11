import 'dart:async';
import 'dart:convert'; // قد لا يكون مطلوباً هنا الآن، لكن من الجيد إبقاؤه
import 'package:bloc/bloc.dart';
import 'package:broker/feature/chat/data/model/bo_response_model.dart';
import 'package:broker/feature/chat/data/repo/websocket_chat.dart';
import 'package:flutter/material.dart'; // مطلوب فقط لدالة submitFeedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../core/helpers/cash_helper.dart';

import '../data/model/chat_model.dart';
import '../data/model/feedback_model.dart';
import '../data/repo/chat_services.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService;
  final WebSocketService webSocketService;
  // ✅ النوع الصحيح للاستماع
  StreamSubscription<Map<String, dynamic>>? _streamSubscription;

  static ChatCubit get(context) => BlocProvider.of(context);

  ChatCubit(this.chatService, this.webSocketService) : super(ChatInitial()) {
    // ابدأ الاستماع لرسائل البوت فور إنشاء الـ Cubit
    _listenToBotMessages();
  }

  /// دالة مركزية تستمع لردود البوت القادمة من الـ Service.
  void _listenToBotMessages() {
    _streamSubscription?.cancel();
    _streamSubscription = webSocketService.stream.listen((dataMap) {
      if (isClosed) return;

      try {
        // الـ Service يضمن أن dataMap هي خريطة صالحة
        print("CUBIT RECEIVED MAP: $dataMap");

        // إنشاء الموديل مباشرة من الخريطة
        final botResponseModel = BotResponseModel.fromMap(dataMap);

        // تحديث الحالة بإضافة الموديل الجديد
        final updatedList = [...state.chatList, botResponseModel];
        emit(BotResponseReceived(
            botMessage: botResponseModel, chatList: updatedList));
      } catch (e) {
        print("Error in ChatCubit while processing bot message: $e");
        // يمكنك هنا إرسال حالة خطأ إذا أردت
        emit(ChatError(
          errorMessage: 'Failed to process bot message.',
        ));
      }
    }, onError: (error) {
      if (!isClosed) {
        emit(ChatError(
          errorMessage: "Connection error: ${error.toString()}",
        ));
      }
    });
  }

  /// تبدأ الاتصال بالـ WebSocket.
  Future<void> startChat() async {
    // لا تعرض أي رسالة هنا، فقط ابدأ الاتصال
    emit(ChatLoading(chatList: const [])); // اعرض مؤشر تحميل
    try {
      await webSocketService.connect();
      // بعد نجاح الاتصال، يمكننا العودة إلى حالة الخمول
      // الـ Listener سيتعامل مع أي رسالة ترحيبية تلقائية
      if (state is ChatLoading) {
        emit(ChatIdle(chatList: const []));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ChatError(errorMessage: "Failed to connect: ${e.toString()}"));
      }
    }
  }

  /// تضيف رسالة المستخدم للـ UI وترسلها إلى الخادم.
  Future<void> addMessageAndFetchResponse(String userMessage) async {
    // 1. أضف رسالة المستخدم إلى الـ UI فوراً
    final userMessageModel =
        ChatModel(message: userMessage, interactionMode: "user");
    final updatedList = [...state.chatList, userMessageModel];
    // اعرض رسالة المستخدم مع مؤشر تحميل بجانبها
    emit(ChatLoading(chatList: updatedList));

    // 2. أرسل الرسالة عبر الـ WebSocket
    try {
      // الـ Service سيتولى أي مشاكل في الاتصال
      await webSocketService.sendMessage(userMessage);
    } catch (e) {
      if (!isClosed) {
        // في حالة فشل الإرسال، اعرض رسالة خطأ
        emit(ChatError(
          errorMessage: e.toString(),
        ));
      }
    }
    // 3. انتهى دور هذه الدالة. الـ listener سيتولى استلام الرد.
  }

  /// ترسل تقييم المستخدم لرسالة معينة.
  Future<void> submitFeedback(
    {
    required String messageId,
    required String feedbackType,
    String? comment,
    // لا حاجة لـ BuildContext هنا
  }) async {
    try {
      final userId = await CashHelper.getStringSecured(key: Keys.id);
      if (userId == null) {
        emit(ChatError(
          errorMessage: "User not logged in. Cannot submit feedback.",
        ));
        return;
      }

      final feedback = FeedbackModel(
        messageId: messageId,
        userId: userId,
        feedbackType: feedbackType,
        comment: comment,
      );
      print(feedback.toMap());
      // افترض أن الخدمة تتولى تحويل الموديل إلى Map
      await chatService.sendFeedback(feedback);
    Fluttertoast.showToast(msg: "Thanks for your feedback!");
      // يمكنك هنا إظهار رسالة تأكيد للمستخدم
      emit(FeedbackSubmitted(chatList: state.chatList));
      
    } catch (e) {
      emit(ChatError(
        errorMessage: "Error submitting feedback: ${e.toString()}",
      ));
    }
  }

  /// تنظيف الموارد عند إغلاق الـ Cubit.
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    webSocketService.dispose(); // مهم جداً لإغلاق الاتصال والـ controllers
    return super.close();
  }
}

/// حالة الخمول (اختيارية، يمكن إزالتها إذا لم تكن مستخدمة)
class ChatIdle extends ChatState {
  const ChatIdle({required List<dynamic> chatList}) : super(chatList: chatList);
}
