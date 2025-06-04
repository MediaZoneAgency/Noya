import 'dart:convert';

class LoginResponseModel {
  String? message;
  User? user;
  String token; // Token is now non-nullable

  LoginResponseModel({
    this.message,
    this.user,
    required this.token, // Token is required in the constructor
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is LoginResponseModel &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              user == other.user &&
              token == other.token);

  @override
  int get hashCode => message.hashCode ^ user.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'LoginResponseModel{message: $message, user: $user, token: $token}';
  }

  LoginResponseModel copyWith({
    String? message,
    User? user,
    String? token,
  }) {
    return LoginResponseModel(
      message: message ?? this.message,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'user': user?.toMap(),
      'token': token, // Non-nullable token
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      message: map['message'] ,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      token: map['token'] , // Ensure token is non-null
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
class User {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? city;
  String? lastActiveAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.city,
    this.lastActiveAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      phoneNumber: map['phone_number'] as String?,
      emailVerifiedAt: map['email_verified_at'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      image: map['image'] as String?,
      city: map['city'] as String?,
      lastActiveAt: map['last_active_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'city': city,
      'last_active_at': lastActiveAt,
    };
  }
}
