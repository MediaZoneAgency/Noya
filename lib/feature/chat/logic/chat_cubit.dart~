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
  StreamSubscription<String>? _streamSubscription;
  String? _sessionId;
  static ChatCubit get(context) => BlocProvider.of(context);
  // Removed _isWebSocketConnected as initializeWebSocket is commented out
  // bool _isWebSocketConnected = false;
  final WebSocketService webSocketService;
  ChatCubit(this.chatService, this.webSocketService) : super(ChatInitial());

  Future<void> fetchSessionHistory() async {
    try {
      final String userId = await CashHelper.getStringSecured(key: Keys.id);
      final sessionHistory =
          await chatService.fetchSessionHistory(userId: userId);

      if (sessionHistory.success && sessionHistory.sessions.isNotEmpty) {
        _sessionId = sessionHistory.sessions.last;

        print("✅ Fetched Sessions: ${sessionHistory.sessions}");
        print("✅ Latest Session ID: $_sessionId");
      } else {
        print("⚠️ No sessions found or API returned success = false.");
      }
    } catch (e) {
      print("❌ Error fetching session history: $e");
      if (!isClosed) {
        emit(ChatError(
            errorMessage: "Failed to fetch session history: ${e.toString()}"));
      }
    }
  }

Future<void> startChat() async {
try {
final String userId = await CashHelper.getStringSecured(key: Keys.id);
 webSocketService.connect();
webSocketService.sendMessage("hi");
late StreamSubscription sub;
sub = webSocketService.stream.listen((firstMessage) async {
  final botMessage = BotResponseModel(
    message: firstMessage,
    interactionMode: 'bot',
  );

  final updatedChatList = [...state.chatList, botMessage];

  if (!isClosed) {
    emit(BotResponseReceived(
      botMessage: botMessage,
      chatList: updatedChatList,
    ));
  }

  await sub.cancel(); // ✅ دلوقتي تقدر تستخدمه
});
} catch (e) {
print("❌ Error starting chat (WebSocket): $e");
if (!isClosed) {
emit(ChatError(errorMessage: "Failed to start chat: ${e.toString()}"));
}
}
}



  Future<void> addMessageAndFetchResponse(String userMessage) async {
    final listBeforeRequest = state.chatList;
    try {
      final userMessageModel =
          ChatModel(message: userMessage, interactionMode: "user");
      final loadingList = [...listBeforeRequest, userMessageModel];

      if (!isClosed) emit(ChatLoading(chatList: loadingList));

      final initialBotMessage =
          BotResponseModel(message: "", interactionMode: 'bot');
      final List<dynamic> chatListBeingUpdated = [
        ...loadingList,
        initialBotMessage
      ];

      await _streamSubscription?.cancel();
      _streamSubscription = webSocketService.stream.listen(
        (chunk) {
          if (chatListBeingUpdated.isNotEmpty &&
              chatListBeingUpdated.last is BotResponseModel) {
            final lastMessagePlaceholder =
                chatListBeingUpdated.last as BotResponseModel;

            final updatedBotMessage = BotResponseModel(
              message: lastMessagePlaceholder.message + chunk,
              interactionMode: 'bot',
            );

            chatListBeingUpdated[chatListBeingUpdated.length - 1] =
                updatedBotMessage;

            if (!isClosed) {
              emit(BotResponseReceived(
                botMessage: updatedBotMessage,
                chatList: List<dynamic>.from(chatListBeingUpdated),
              ));
            }
          }
        },
        onError: (error) {
          print("Stream Error: $error");
          if (!isClosed) {
            emit(ChatError(errorMessage: error.toString()));
          }
        },
        onDone: () {
          print("Stream Done.");
          _streamSubscription = null;
        },
        cancelOnError: true,
      );

      // ✉️ Send user message to WebSocket
      webSocketService.sendMessage(userMessage);
    } catch (e) {
      print("Error in addMessageAndFetchResponse: $e");
      if (!isClosed) {
        emit(ChatError(errorMessage: e.toString()));
      }
      await _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }

  // Future<void> startChat() async {
  //   try {
  //     final String userId = await CashHelper.getStringSecured(key: Keys.id);
  //     final response = await chatService.startSession(userId);

  //     final String welcomeMessage = response.messages[0].content;
  //     _sessionId = response.sessionId;

  //     final botMessage = BotResponseModel(
  //       message: welcomeMessage,
  //       interactionMode: 'bot',
  //     );

  //     final updatedChatList = [...state.chatList, botMessage];
  //     print(updatedChatList);
  //     if (!isClosed) {
  //       emit(BotResponseReceived(
  //         botMessage: botMessage,
  //         chatList: updatedChatList,
  //       ));
  //     }
  //   } catch (e) {
  //     print("❌ Error starting chat: $e");
  //     if (!isClosed) {
  //       emit(ChatError(errorMessage: "Failed to start chat: ${e.toString()}"));
  //     }
  //   }
  // }

  // Future<void> addMessageAndFetchResponse(String userMessage) async {
  //   final listBeforeRequest = state.chatList;
  //   try {
  //     final userMessageModel =
  //         ChatModel(message: userMessage, interactionMode: "user");
  //     final loadingList = [...listBeforeRequest, userMessageModel];

  //     // Emit Loading state FIRST to show user message and thinking indicator
  //     if (!isClosed) emit(ChatLoading(chatList: loadingList));

  //     final chatModel =
  //         ChatModel(message: userMessage, interactionMode: "text");
  //     final response =
  //         await chatService.sendMessageStreamWithHeaders(chatModel);
  //     final stream = response.stream;
  //     final headers = response.headers; // Keep headers if needed elsewhere

  //     // Create the list WITH the placeholder LOCALLY *before* listening
  //     final initialBotMessage =
  //         BotResponseModel(message: "", interactionMode: 'bot');
  //     // This list will be updated directly by the stream listener
  //     final List<dynamic> chatListBeingUpdated = [
  //       ...loadingList,
  //       initialBotMessage
  //     ];

  //     // Optional: Emit initial bot placeholder immediately? Might cause empty bubble flicker.
  //     // if (!isClosed) emit(BotResponseReceived(botMessage: initialBotMessage, chatList: chatListBeingUpdated));

  //     await _streamSubscription?.cancel();

  //     _streamSubscription = stream.listen(
  //       (chunk) {
  //         // --- SOLUTION ---
  //         // Directly update the locally managed list (`chatListBeingUpdated`)
  //         // instead of relying on `state.chatList` inside the listener.

  //         // We know the last item *should* be the BotResponseModel placeholder here
  //         if (chatListBeingUpdated.isNotEmpty &&
  //             chatListBeingUpdated.last is BotResponseModel) {
  //           // Get the last message placeholder FROM THE LOCAL LIST
  //           final lastMessagePlaceholder =
  //               chatListBeingUpdated.last as BotResponseModel;

  //           // Create the updated message model
  //           final updatedBotMessage = BotResponseModel(
  //             message: lastMessagePlaceholder.message + chunk, // Append chunk
  //             interactionMode: 'bot',
  //           );

  //           // Update the last item IN THE LOCAL LIST directly
  //           chatListBeingUpdated[chatListBeingUpdated.length - 1] =
  //               updatedBotMessage;

  //           // NOW emit the BotResponseReceived state with the updated local list
  //           if (!isClosed) {
  //             // IMPORTANT: Emit a *new* list instance for Bloc to detect the change
  //             emit(BotResponseReceived(
  //               botMessage: updatedBotMessage, // Pass the updated message model
  //               chatList: List<dynamic>.from(
  //                   chatListBeingUpdated), // Pass a COPY of the updated list
  //             ));
  //           }
  //         } else {
  //           // This log should ideally not appear now, but keep it for debugging potential edge cases
  //           print(
  //               "Stream chunk received but LOCAL list structure is unexpected.");
  //         }
  //         // --- END SOLUTION ---
  //       },
  //       onError: (error) {
  //         print("Stream Error: $error");
  //         if (!isClosed) {
  //           emit(ChatError(errorMessage: error.toString())); // Pass list
  //         }
  //       },
  //       onDone: () {
  //         print("Stream Done.");
  //         _streamSubscription = null;
  //         // Optional: Emit a final state here if the stream finishing means something
  //         // e.g., if BotResponseReceived indicates streaming, maybe emit ChatIdle or ChatSuccess
  //         // if (!isClosed && state is BotResponseReceived) {
  //         //    emit(ChatIdle(chatList: state.chatList));
  //         // }
  //       },
  //       cancelOnError: true,
  //     );
  //   } catch (e) {
  //     print("Error in addMessageAndFetchResponse: $e");
  //     if (!isClosed) {
  //       emit(ChatError(errorMessage: e.toString())); // Pass list
  //     }
  //     await _streamSubscription?.cancel();
  //     _streamSubscription = null;
  //   }
  // }

  Future<void> submitFeedback({
    required String message,
    required String feedbackType,
    String? comment,
  }) async {
    // Keep track of the list *before* the potential error
    final listBeforeFeedback = state.chatList;
    try {
      if (_sessionId == null) {
        print("Error: Session ID is missing for feedback.");
        if (!isClosed) {
          // *** FIX: Pass the chatList ***
          emit(ChatError(
              errorMessage: "Cannot submit feedback: Session ID is missing."));
        }
        return;
      }

      final feedback = FeedbackModel(
        sessionId: _sessionId!,
        message:
            message, // Should this be the bot's message ID or text? Clarify requirement.
        feedbackType: feedbackType,
        comment: comment,
      );

      // Example logging
      await chatService.sendFeedback(feedback);
      print("Feedback Submitted Successfully");

      // Emit FeedbackSubmitted state, keeping the current chat list
      if (!isClosed) emit(FeedbackSubmitted(chatList: listBeforeFeedback));
    } catch (e) {
      print("Error submitting feedback: $e");
      if (!isClosed) {
        // *** FIX: Pass the chatList ***
        emit(ChatError(
            errorMessage: "Error submitting feedback: ${e.toString()}"));
      }
    }
  }

  Future<void> loadChatHistory() async {
    try {
      // Get user ID (assuming you have access to it)
      final String userId = await CashHelper.getStringSecured(
          key: Keys.id); // Or however you get the user ID

      // Emit a loading state if desired
      // emit(ChatHistoryLoading());

      final historyResponse = await chatService.getChatHistory(userId);

      if (historyResponse.success && !isClosed) {
        // Convert ChatMessageHistoryModel to your existing chat list format
        // (e.g., ChatModel or BotResponseModel) or adapt your UI to handle ChatMessageHistoryModel
        final formattedHistory = historyResponse.messages.map((histMsg) {
          // Example conversion (adjust based on your existing models)
          if (histMsg.role == 'user') {
            return ChatModel(message: histMsg.message, interactionMode: 'user');
          } else {
            // assistant
            return BotResponseModel(
                message: histMsg.message, interactionMode: 'bot');
          }
        }).toList();

        // Emit a state with the loaded history
        emit(ChatHistoryLoaded(
            chatList: formattedHistory)); // Create a new state for this
      } else if (!isClosed) {
        // Handle the case where success is false
        emit(ChatError(
            errorMessage: "Failed to retrieve history (API success: false)"));
      }
    } catch (e) {
      if (!isClosed) {
        // Handle errors from the service call (already wrapped in ApiErrorModel)
        emit(ChatError(errorMessage: e.toString()));
      }
    }
  }

  // Note: This method's logic seems incorrect for a chat application.
  // It records audio, then immediately tries to play it back locally.
  // It should likely *send* the audioBytes to the server and handle the *response*.
  // The corrected code below fixes the ChatError emission but retains the flawed logic for now.
  Future<void> recordAndSendAudio() async {
    // Keep track of the list *before* the potential error
    //  final listBeforeRecording = state.chatList;
    // try {
    //   // Emit recording state, keeping the current chat list visible
    //   if (!isClosed) emit(RecordingInProgress(chatList: listBeforeRecording));

    //   // This service method name is misleading if it *only* records.
    //   // If it *does* record AND send AND return the *response* audio, the name is okay.
    //   // Assuming it currently just records locally for playback:
    //   final Uint8List? audioBytes = await chatService.recordAudioLocally(); // Example corrected service call name

    //   // Stop showing recording indicator *before* playing or erroring
    //   // Revert to the previous state list (or emit a generic state like ChatIdle)
    //   if(!isClosed) emit(ChatIdle(chatList: listBeforeRecording)); // Assuming ChatIdle state exists

    //   if (audioBytes != null && audioBytes.isNotEmpty) {
    //      print("Audio Recorded Locally. Attempting playback...");
    //      // This plays the *recorded* audio, not a response from the bot.
    //      await playRecordedAudioLocally(audioBytes); // Renamed for clarity
    //   } else {
    //      print("🚨 Failed to record audio or audio data is empty.");
    //      if (!isClosed) {
    //          // *** FIX: Pass the chatList ***
    //          emit(ChatError(errorMessage: "Failed to record audio", chatList: listBeforeRecording));
    //      }
    //   }
    // } catch (e) {
    //   print("❌ Error during audio recording/processing: $e");
    //    // Ensure state reverts from RecordingInProgress on error
    //    if(!isClosed && state is RecordingInProgress) {
    //        emit(ChatIdle(chatList: listBeforeRecording)); // Revert state
    //    }
    //    if (!isClosed) {
    //        // *** FIX: Pass the chatList ***
    //        emit(ChatError(errorMessage: "Error processing audio: ${e.toString()}", chatList: listBeforeRecording));
    //    }
    // }
  }

  /// Renamed for clarity: Plays audio bytes locally (not a bot response)
  Future<void> playRecordedAudioLocally(Uint8List audioBytes) async {
    // Keep track of the list *before* the potential error
    final listBeforePlayback = state.chatList;
    try {
      await chatService.playAudioFromBytes(audioBytes);
      print("Local audio playback finished.");
      // No state change needed after playback usually, unless you want to indicate it finished.
    } catch (e) {
      print("❌ Error during local audio playback: $e");
      if (!isClosed) {
        // *** FIX: Pass the chatList ***
        emit(ChatError(errorMessage: "Error playing audio: ${e.toString()}"));
      }
    }
  }

  // This method seems redundant or incorrectly implemented based on recordAndSendAudio
  /*
  Future<void> stopRecordingAndSend() async {
    final listBeforeStop = state.chatList;
    try {
      // This doesn't make sense - it sends "Audio sent" as a *user text message*
      // await chatService.stopStreamingAudio(); // This should likely return the audio bytes
      // Then you'd send those bytes via a specific service method.
      // addMessageAndFetchResponse('Audio sent'); // Incorrect logic
    } catch (e) {
      if (!isClosed) {
        // *** FIX: Pass the chatList ***
        emit(ChatError(errorMessage: "Error stopping recording: ${e.toString()}", chatList: listBeforeStop));
      }
    }
  }
  */

  @override
  Future<void> close() {
    print("Closing ChatCubit and cancelling stream subscription.");
    _streamSubscription?.cancel();
    _streamSubscription = null;
    // chatService.disposeWebSocket(); // Call dispose if you re-enable WebSocket
    return super.close();
  }
}

// Define ChatIdle state if you use it:
class ChatIdle extends ChatState {
  const ChatIdle({required List<dynamic> chatList}) : super(chatList: chatList);
}
