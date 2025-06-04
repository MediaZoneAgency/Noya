class SessionHistoryModel {
  final bool success;
  final List<String> sessions;
  final String message;

  SessionHistoryModel({
    required this.success,
    required this.sessions,
    required this.message,
  });

  factory SessionHistoryModel.fromMap(Map<String, dynamic> map) {
    return SessionHistoryModel(
      success: map['success'] ?? false,
      sessions: List<String>.from(
        (map['sessions'] ?? []).whereType<String>(), // نحذف أي null
      ),
      message: map['message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'sessions': sessions,
      'message': message,
    };
  }
}
