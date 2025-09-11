// ✅ الكود الجديد لـ feedback_model.dart

class FeedbackModel {
  final String messageId;
  final String userId;
  final String feedbackType;
  final String? comment;

  FeedbackModel({
    required this.messageId,
    required this.userId,
    required this.feedbackType,
    this.comment,
  });

  // دالة لتحويل الكائن إلى Map لإرساله كـ JSON للـ API
  Map<String, dynamic> toMap() {
    return {
      'message_id': this.messageId,
      'user_id': this.userId,
      'feedback_type': this.feedbackType,
      'comment': this.comment ?? "", // أرسل نصًا فارغًا إذا كان التعليق null
    };
  }

  // يمكنك ترك باقي الدوال (copyWith, toString, etc.) أو إزالتها لأنها قد لا تكون ضرورية الآن
}