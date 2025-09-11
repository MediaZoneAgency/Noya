// lib/feature/chat/data/model/bot_response_model.dart

class BotResponseModel {
  final String message;
  final String? messageId; // ✅ أضفنا messageId وجعلناه يقبل null
  final String interactionMode; // ✅ سنقوم بتعيين هذا الحقل يدوياً

  const BotResponseModel({
    required this.message,
    this.messageId,
    required this.interactionMode,
  });

  // ✅✅✅ دالة fromMap المُعدّلة بالكامل
  factory BotResponseModel.fromMap(Map<String, dynamic> map) {
    return BotResponseModel(
      // استخدم '??' لتوفير قيمة افتراضية في حالة كان الحقل null
      message: map['message'] as String? ?? '...', 
      
      // اقرأ message_id مباشرة، سيكون null إذا لم يكن موجوداً
      messageId: map['message_id'] as String?, 
      
      // **مهم:** بما أن الخادم لا يرسل هذا الحقل، نضع قيمة ثابتة
      interactionMode: 'bot', 
    );
  }

  // --- باقي الدوال (toMap, copyWith, etc.) يمكن أن تبقى كما هي أو تعدلها لتشمل messageId ---
  
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'message_id': messageId,
      'interactionMode': interactionMode,
    };
  }

  BotResponseModel copyWith({
    String? message,
    String? messageId,
    String? interactionMode,
  }) {
    return BotResponseModel(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      interactionMode: interactionMode ?? this.interactionMode,
    );
  }

  @override
  String toString() {
    return 'BotResponseModel(message: $message, messageId: $messageId, interactionMode: $interactionMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BotResponseModel &&
        other.message == message &&
        other.messageId == messageId &&
        other.interactionMode == interactionMode;
  }

  @override
  int get hashCode => message.hashCode ^ messageId.hashCode ^ interactionMode.hashCode;
}