class ChatModel{
  final String? message;
  final String ? interactionMode;

//<editor-fold desc="Data Methods">
  const ChatModel({
    this.message,
    this.interactionMode,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ChatModel &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              interactionMode == other.interactionMode
          );

  @override
  int get hashCode => message.hashCode ^ interactionMode.hashCode;

  @override
  String toString() {
    return 'ChatModel{' +
        ' message: $message,' +
        ' interactionMode: $interactionMode,' +
        '}';
  }

  ChatModel copyWith({
    String? message,
    String? interactionMode,
  }) {
    return ChatModel(
      message: message ?? this.message,
      interactionMode: interactionMode ?? this.interactionMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'interaction_mode': this.interactionMode,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'] ,
      interactionMode: map['interactionMode'] ,
    );
  }

//</editor-fold>
}
// class ChatModel {
//   String? message;
//   String? interactionMode;
//
//   ChatModel({this.message, this.interactionMode});
//
//   ChatModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     interactionMode = json['interaction_mode'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'interaction_mode': interactionMode,
//     };
//   }
// }
