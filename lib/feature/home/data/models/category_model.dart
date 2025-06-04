class CategoryModel {

 final String image;
  final String type;

//<editor-fold desc="Data Methods">
  const CategoryModel({
    required this.image,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          type == other.type);

  @override
  int get hashCode => image.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'CategoryModel{' + ' image: $image,' + ' type: $type,' + '}';
  }

  CategoryModel copyWith({
    String? image,
    String? type,
  }) {
    return CategoryModel(
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': this.image,
      'type': this.type,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      image: map['image'] as String,
      type: map['type'] as String,
    );
  }

//</editor-fold>
}