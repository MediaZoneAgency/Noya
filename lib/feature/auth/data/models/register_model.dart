class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String phone_number;
  final String passwordConfirmation;

//<editor-fold desc="Data Methods">
  const RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone_number,
    required this.passwordConfirmation, String? phone_numberu,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          phone_number == other.phone_number &&
          passwordConfirmation == other.passwordConfirmation);

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      phone_number.hashCode ^
      passwordConfirmation.hashCode;

  @override
  String toString() {
    return 'RegisterModel{' +
        ' name: $name,' +
        ' email: $email,' +
        ' password: $password,' +
        ' phone_number: $phone_number,' +
        ' passwordConfirmation: $passwordConfirmation,' +
        '}';
  }

  RegisterModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone_number,
    String? passwordConfirmation,
  }) {
    return RegisterModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone_number: phone_number ?? this.phone_number,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'phone_number': this.phone_number,
      'password_confirmation': this.passwordConfirmation,
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone_number: map['phone_number'] as String,
      passwordConfirmation: map['password_confirmation'] as String,
    );
  }

//</editor-fold>
}