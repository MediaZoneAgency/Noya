import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiErrorsModel {
  final String message;
  ApiErrorsModel({
    required this.message,
  });

  ApiErrorsModel copyWith({
    String? message,
  }) {
    return ApiErrorsModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ApiErrorsModel.fromMap(Map<String, dynamic> map) {
    return ApiErrorsModel(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiErrorsModel.fromJson(String source) => ApiErrorsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ApiErrorsModel(message: $message)';

  @override
  bool operator ==(covariant ApiErrorsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
