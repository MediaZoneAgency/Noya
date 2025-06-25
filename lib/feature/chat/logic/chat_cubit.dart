// import 'dart:async';
// import 'dart:typed_data';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:path_provider/path_provider.dart';
// import '../data/model/bo_response_model.dart';
// import '../data/model/chat_model.dart';
// import '../data/model/feedback_model.dart';
// import '../data/repo/chat_services.dart';

// part 'chat_state.dart';

// class ChatCubit extends Cubit<ChatState> {
//   final ChatService chatService;
//   StreamSubscription<String>? _streamSubscription;
//   String? _sessionId;
//   bool _isWebSocketConnected = false;

//   ChatCubit(this.chatService) : super(ChatInitial());

//   Future<void> addMessageAndFetchResponse(String userMessage) async {
//     try {
//       final userMessageModel = ChatModel(message: userMessage, interactionMode: "user");
//       if (!isClosed) emit(ChatLoading(chatList: [...state.chatList, userMessageModel]));

//       final chatModel = ChatModel(message: userMessage, interactionMode: "text");
//       final response = await chatService.sendMessageStreamWithHeaders(chatModel);
//       final stream = response.stream;
//       final headers = response.headers;

//       _sessionId = headers['session-id'];
//       if (_sessionId != null) {
//         print('Session ID: $_sessionId');
//       }

//       final initialBotMessage = const BotResponseModel(message: "", interactionMode: 'bot');
//       final updatedChatList = [...state.chatList, initialBotMessage];

//       _streamSubscription = stream.listen(
//             (chunk) {
//           final lastMessage = updatedChatList.last as BotResponseModel;
//           final updatedMessage = BotResponseModel(
//             message: lastMessage.message + chunk,
//             interactionMode: 'bot',
//           );

//           updatedChatList[updatedChatList.length - 1] = updatedMessage;
//           if (!isClosed) {
//             emit(BotResponseReceived(
//               botMessage: updatedMessage,
//               chatList: updatedChatList,
//             ));
//           }
//         },
//         onError: (error) {
//           if (!isClosed) emit(ChatError(errorMessage: error.toString()));
//         },
//         onDone: () {
//           _streamSubscription?.cancel();
//         },
//       );
//     } catch (e) {
//       if (!isClosed) emit(ChatError(errorMessage: e.toString()));
//     }
//   }

//   /*void initializeWebSocket() {
//     if (!_isWebSocketConnected) {
//       chatService.initializeWebSocket();
//       _isWebSocketConnected = true;
//     }
//   }*/

//   /* Future<void> startRecording() async {
//     if (!isClosed) {
//       emit(RecordingInProgress(chatList: state.chatList));
//     }
//     try {
//       await chatService.startStreamingAudio();
//     } catch (e) {
//       if (!isClosed) {
//         emit(ChatError(errorMessage: "Error starting recording: ${e.toString()}"));
//       }
//     }
//   }*/
//   Future<void> submitFeedback({
//     required String message,
//     required String feedbackType,
//     String? comment,
//   }) async {
//     try {
//       if (_sessionId == null) {
//         emit(ChatError(errorMessage: "Session ID is missing."));
//         return;
//       }

//       final feedback = FeedbackModel(
//         sessionId: _sessionId!,
//         message: message,
//         feedbackType: feedbackType,
//         comment: comment,
//       );

//       await chatService.sendFeedback(feedback);
//       emit(FeedbackSubmitted(chatList: state.chatList));
//     } catch (e) {
//       emit(ChatError(errorMessage: e.toString()));
//     }
//   }

//   //
//   Future<void> stopRecordingAndSend() async {
//     try {
//       // await chatService.stopStreamingAudio();
//       addMessageAndFetchResponse('Audio sent');
//     } catch (e) {
//       if (!isClosed) {
//         emit(ChatError(errorMessage: "Error stopping recording: ${e.toString()}"));
//       }
//     }
//   }
//   Future<void> recordAndSendAudio() async {
//     try {
//       emit(RecordingInProgress(chatList: state.chatList));

//       final Uint8List? audioBytes = (await chatService.recordAndSendAudio()) as Uint8List?;

//       if (audioBytes != null) {
//         await playReceivedAudio(audioBytes);
//       } else {
//         emit(ChatError(errorMessage: "🚨 Failed to record audio"));
//       }
//     } catch (e) {
//       emit(ChatError(errorMessage: "❌ Error while sending audio: $e"));
//     }
//   }

//   /// ✅ **تشغيل الصوت المستلم**
//   Future<void> playReceivedAudio(Uint8List audioBytes) async {
//     try {
//       await chatService.playAudioFromBytes(audioBytes);
//     } catch (e) {
//       emit(ChatError(errorMessage: "❌ خطأ أثناء تشغيل الصوت: ${e.toString()}"));
//     }
//   }

//   @override
//   Future<void> close() {
//     _streamSubscription?.cancel();
//     // ✅ إغلاق WebSocket عند تدمير `ChatCubit`
//     return super.close();
//   }
// }

import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:broker/feature/chat/data/repo/websocket_chat.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
// Assuming path_provider is used within ChatService, otherwise remove if not needed here.
// import 'package:path_provider/path_provider.dart';
import '../../../core/helpers/cash_helper.dart';
import '../data/model/bo_response_model.dart'; // Corrected import name assuming it's bot_response_model.dart
import '../data/model/chat_model.dart';
import '../data/model/feedback_model.dart';
import '../data/repo/chat_services.dart'; // Corrected import name assuming it's chat_service.dart

part 'chat_state.dart';
class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService;
  final WebSocketService webSocketService;
  StreamSubscription<String>? _streamSubscription;
  String? _sessionId;

  static ChatCubit get(context) => BlocProvider.of(context);

  ChatCubit(this.chatService, this.webSocketService) : super(ChatInitial());

  Future<void> fetchSessionHistory() async {
    try {
      final String userId = await CashHelper.getStringSecured(key: Keys.id);
      final sessionHistory = await chatService.fetchSessionHistory(userId: userId);

      if (sessionHistory.success && sessionHistory.sessions.isNotEmpty) {
        _sessionId = sessionHistory.sessions.last;
        print("✅ Latest Session ID: $_sessionId");
      }
    } catch (e) {
      if (!isClosed) {
        emit(ChatError(errorMessage: "Failed to fetch session history: ${e.toString()}"));
      }
    }
  }

  Future<void> startChat() async {
    try {
    //  await webSocketService.connect();
     //
     // webSocketService.sendMessage("hi");

      bool hasReceivedWelcome = false;

      await _streamSubscription?.cancel();
      _streamSubscription = webSocketService.stream.listen((message) async {
        if (message.length == 36) return;

        if (!hasReceivedWelcome) {
          hasReceivedWelcome = true;

          final botMessage = BotResponseModel(
            message: message,
            interactionMode: 'bot',
          );

          final updatedChatList = [...state.chatList, botMessage];

          if (!isClosed) {
            emit(BotResponseReceived(
              botMessage: botMessage,
              chatList: updatedChatList,
            ));
          }
        }
      });
    } catch (e) {
      if (!isClosed) {
        emit(ChatError(errorMessage: "Failed to start chat: ${e.toString()}"));
      }
    }
  }

 Future<void> addMessageAndFetchResponse(String userMessage) async {
final previousList = state.chatList;
String cumulativeMessage = ""; // ⬅️ لتجميع الرسالة

try {
// 🧑‍💬 ضيف رسالة المستخدم أولًا
final userMessageModel = ChatModel(message: userMessage, interactionMode: "user");
final updatedList = [...previousList, userMessageModel];

emit(ChatLoading(chatList: updatedList));

// 🤖 جهز مكان للرسالة الفاضية اللى هتتبني chunk by chunk
final botPlaceholder = BotResponseModel(message: "", interactionMode: 'bot');
final chatListBeingUpdated = [...updatedList, botPlaceholder];

await _streamSubscription?.cancel(); // ألغى أي stream قديم

_streamSubscription = webSocketService.stream.listen(
  (chunk) {
    // تجاهل sessionId أو أي message UUID
    if (chunk.length == 36) return;

    // ✏️ ضيف النص الجديد على القديم
    cumulativeMessage += chunk;

    // ✏️ حدّث آخر رسالة بوت بالكلام الجديد
    final updated = BotResponseModel(
      message: cumulativeMessage,
      interactionMode: 'bot',
    );

    chatListBeingUpdated[chatListBeingUpdated.length - 1] = updated;

    if (!isClosed) {
      emit(BotResponseReceived(
        botMessage: updated,
        chatList: List.from(chatListBeingUpdated),
      ));
    }
  },
  onError: (error) {
    if (!isClosed) emit(ChatError(errorMessage: error.toString()));
  },
  onDone: () {
    _streamSubscription = null;
  },
  cancelOnError: true,
);

// ✉️ ابعت الرسالة فعليًا
webSocketService.sendMessage(userMessage);
} catch (e) {
if (!isClosed) {
emit(ChatError(errorMessage: e.toString()));
}
await _streamSubscription?.cancel();
_streamSubscription = null;
}
}

  Future<void> submitFeedback({
    required String message,
    required String feedbackType,
    String? comment,
  }) async {
    try {
      if (_sessionId == null) {
        emit(ChatError(errorMessage: "Session ID is missing."));
        return;
      }

      final feedback = FeedbackModel(
        sessionId: _sessionId!,
        message: message,
        feedbackType: feedbackType,
        comment: comment,
      );

      await chatService.sendFeedback(feedback);
      emit(FeedbackSubmitted(chatList: state.chatList));
    } catch (e) {
      emit(ChatError(errorMessage: "Error submitting feedback: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    return super.close();
  }
}

class ChatIdle extends ChatState {
  const ChatIdle({required List<dynamic> chatList}) : super(chatList: chatList);
}
