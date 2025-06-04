part of 'chat_cubit.dart';

@immutable
abstract class ChatState {
  final List<dynamic> chatList;

  const ChatState({this.chatList = const []});
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<dynamic> chatList;

  ChatLoading({required this.chatList});
}

class BotResponseReceived extends ChatState {
  final BotResponseModel botMessage;
  final List<dynamic> chatList;

  BotResponseReceived({
    required this.botMessage,
    required this.chatList,
  });
}
class BotResponseLoading extends ChatState {
  const BotResponseLoading({required super.chatList});
}


class ChatError extends ChatState {
  final String errorMessage;

  ChatError({required this.errorMessage});
}

class RecordingInProgress extends ChatState {
  final List<dynamic> chatList;

  RecordingInProgress({required this.chatList});
}

class FeedbackSubmitted extends ChatState {
  final List<dynamic> chatList;

  FeedbackSubmitted({required this.chatList});
}
class ChatHistoryLoading extends ChatState {
  // تأخذ القائمة من الحالة *قبل* بدء التحميل
  const ChatHistoryLoading({required super.chatList}); // تمرير القائمة
}

// حالة تشير إلى أنه تم تحميل سجل المحادثات بنجاح
class ChatHistoryLoaded extends ChatState {
  // الـ chatList هنا ستحتوي على السجل الذي تم جلبه وتنسيقه
  const ChatHistoryLoaded({required super.chatList}); // تمرير القائمة الجديدة
}