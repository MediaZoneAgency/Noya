import 'package:meta/meta.dart';
import 'dart:convert';

// Model for the entire API response
@immutable
class ChatHistoryResponseModel {
  final bool success;
  final List<ChatMessageHistoryModel> messages;

  const ChatHistoryResponseModel({
    required this.success,
    required this.messages,
  });

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    // Parse the list of messages safely
    List<ChatMessageHistoryModel> parsedMessages = [];
    if (json['messages'] != null && json['messages'] is List) {
      parsedMessages = (json['messages'] as List<dynamic>)
          .map((item) => ChatMessageHistoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ChatHistoryResponseModel(
      success: json['success'] as bool? ?? false, // Provide default value if null
      messages: parsedMessages,
    );
  }

  // Optional: toJson method if you need to serialize it back
  Map<String, dynamic> toJson() => {
        'success': success,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  @override
  String toString() => 'ChatHistoryResponse(success: $success, messages: ${messages.length} items)';
}


// Model for a single message within the history
@immutable
class ChatMessageHistoryModel {
  final String role;
  final String message;
  final String timestamp; // Keep as String for simplicity, parse later if needed

  const ChatMessageHistoryModel({
    required this.role,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageHistoryModel(
      role: json['role'] as String? ?? 'unknown', // Provide default
      message: json['message'] as String? ?? '', // Provide default
      timestamp: json['timestamp'] as String? ?? '', // Provide default
    );
  }

  // Optional: toJson method
  Map<String, dynamic> toJson() => {
        'role': role,
        'message': message,
        'timestamp': timestamp,
      };

  @override
  String toString() => 'ChatMessageHistory(role: $role, message: "$message", timestamp: $timestamp)';

  // Optional: Equality and hashCode for comparisons
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageHistoryModel &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          message == other.message &&
          timestamp == other.timestamp;

  @override
  int get hashCode => role.hashCode ^ message.hashCode ^ timestamp.hashCode;
}