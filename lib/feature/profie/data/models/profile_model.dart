class ProfileModel {
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  String? image;

//<editor-fold desc="Data Methods">


  ProfileModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          role == other.role &&
          image == other.image);

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      role.hashCode ^
      image.hashCode;

  @override
  String toString() {
    return 'ProfileModel{' +
        ' name: $name,' +
        ' email: $email,' +
        ' phoneumber: $phoneNumber,' +
        ' role: $role,' +
        ' image: $image,' +
        '}';
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    Null? image,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'phone_number': this.phoneNumber,
      'role': this.role,
      'image': this.image,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ,
      email: map['email'] ,
      phoneNumber: map['phone_number'] ,
      role: map['role'] ,
      image: map['image'] ,
    );
  }

//</editor-fold>
}