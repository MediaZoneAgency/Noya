class BotResponseModel {
  final String message;
final String interactionMode;

//<editor-fold desc="Data Methods">

  const BotResponseModel({
    required this.message,
    required this.interactionMode,
  });

//</e@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is BotResponseModel &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              interactionMode == other.interactionMode
          );


  @override
  int get hashCode =>
      message.hashCode ^
      interactionMode.hashCode;


  @override
  String toString() {
    return 'BotResponseModel{' +
        ' message: $message,' +
        ' interactionMode: $interactionMode,' +
        '}';
  }


  BotResponseModel copyWith({
    String? message,
    String? interactionMode,
  }) {
    return BotResponseModel(
      message: message ?? this.message,
      interactionMode: interactionMode ?? this.interactionMode,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'interactionMode': this.interactionMode,
    };
  }

  factory BotResponseModel.fromMap(Map<String, dynamic> map) {
    return BotResponseModel(
      message: map['message'] as String,
      interactionMode: map['interactionMode'] as String,
    );
  }


  //</editor-fold>

}
