class FeedbackModel {
  String? sessionId;
  String? message;
  String? feedbackType;
  String? comment;

//<editor-fold desc="Data Methods">
  FeedbackModel({
    this.sessionId,
    this.message,
    this.feedbackType,
    this.comment,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackModel &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          message == other.message &&
          feedbackType == other.feedbackType &&
          comment == other.comment);

  @override
  int get hashCode =>
      sessionId.hashCode ^
      message.hashCode ^
      feedbackType.hashCode ^
      comment.hashCode;

  @override
  String toString() {
    return 'FeedbackModel{' +
        ' sessionId: $sessionId,' +
        ' message: $message,' +
        ' feedbackType: $feedbackType,' +
        ' comment: $comment,' +
        '}';
  }

  FeedbackModel copyWith({
    String? sessionId,
    String? message,
    String? feedbackType,
    String? comment,
  }) {
    return FeedbackModel(
      sessionId: sessionId ?? this.sessionId,
      message: message ?? this.message,
      feedbackType: feedbackType ?? this.feedbackType,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': this.sessionId,
      'message': this.message,
      'feedbackType': this.feedbackType,
      'comment': this.comment,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      sessionId: map['sessionId'],
      message: map['message'] ,
      feedbackType: map['feedbackType'] ,
      comment: map['comment'] ,
    );
  }

//</editor-fold>
}