class StartSessionResponse {
final String sessionId;
final List<SessionMessage> messages;

StartSessionResponse({
required this.sessionId,
required this.messages,
});

factory StartSessionResponse.fromJson(Map<String, dynamic> json) {
return StartSessionResponse(
sessionId: json['session_id'],
messages: (json['messages'] as List)
.map((msg) => SessionMessage.fromJson(msg))
.toList(),
);
}
}

class SessionMessage {
final String role;
final String content;

SessionMessage({
required this.role,
required this.content,
});

factory SessionMessage.fromJson(Map<String, dynamic> json) {
return SessionMessage(
role: json['role'],
content: json['content'],
);
}
}