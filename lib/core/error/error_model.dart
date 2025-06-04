// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiErrorModel {
  final String message;
  final int? status;
  final String? code;
  final dynamic errors; // This can hold any type of error details, such as a list or a map

  ApiErrorModel({
    required this.message,
    this.status,
    this.code,
    this.errors,
  });

  ApiErrorModel copyWith({
    String? message,
    int? status,
    String? code,
    dynamic errors,
  }) {
    return ApiErrorModel(
      message: message ?? this.message,
      status: status ?? this.status,
      code: code ?? this.code,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'code': code,
      'errors': errors,
    };
  }

  factory ApiErrorModel.fromMap(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['message'] as String,
      status: map['status'] as int?,
      code: map['code'] as String?,
      errors: map['errors'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiErrorModel.fromJson(String source) => ApiErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ApiErrorModel(message: $message, status: $status, code: $code, errors: $errors)';

  @override
  bool operator ==(covariant ApiErrorModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.code == code &&
        other.errors == errors;
  }

  @override
  int get hashCode => message.hashCode ^ status.hashCode ^ code.hashCode ^ errors.hashCode;
}
