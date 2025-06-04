
class LogInModel {

  String? email;
  String? password;
  String? phoneNumber;
  //<editor-fold desc="Data Methods">

  LogInModel({
    this.email,
    this.password,
    this.phoneNumber,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is LogInModel &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              password == other.password &&
              phoneNumber == other.phoneNumber
          );


  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      phoneNumber.hashCode;


  @override
  String toString() {
    return 'LogInModel{' +
        ' email: $email,' +
        ' password: $password,' +
        ' phoneNumber: $phoneNumber,' +
        '}';
  }


  LogInModel copyWith({
    String? email,
    String? password,
    String? phoneNumber,
  }) {
    return LogInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }


  Map<String, dynamic> toMap() {
    return {
   //   'email': this.email,
      'password': this.password,
      'phone_number': this.phoneNumber,
    };
  }

  factory LogInModel.fromMap(Map<String, dynamic> map) {
    return LogInModel(
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phone_number'] as String,
    );
  }


  //</editor-fold>
  }
