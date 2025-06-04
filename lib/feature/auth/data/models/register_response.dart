import 'dart:convert';

class RegisterResponseModel {
  final User user;
  final String token;

  RegisterResponseModel({
    required this.user,
    required this.token,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is RegisterResponseModel &&
              runtimeType == other.runtimeType &&
              user == other.user &&
              token == other.token);

  @override
  int get hashCode => user.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'RegisterResponseModel{user: $user, token: $token}';
  }

  RegisterResponseModel copyWith({
    User? user,
    String? token,
  }) {
    return RegisterResponseModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'token': token,
    };
  }

  factory RegisterResponseModel.fromMap(Map<String, dynamic> map) {
    return RegisterResponseModel(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterResponseModel.fromJson(String source) =>
      RegisterResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is User &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email &&
              phoneNumber == other.phoneNumber &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
