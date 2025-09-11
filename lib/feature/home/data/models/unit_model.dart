// هذا هو الكود الصحيح والمعدل، قم بنسخه بالكامل

import 'dart:convert';

class UnitModel {
  final int? id;
  final int? projectId;
  final String? type;
  final int? size;
  final String? price;
  final String? location;
  final String? locationLink;
  final String? description;
  final List<dynamic>? listOfDescription; // الـ API يرسلها كقائمة فارغة []
  final List<String>? images;
  final int? bathrooms;
  final int? rooms;
  final bool? hasGarden; // ✅ تم التصحيح: من int? إلى bool?
  final int? gardenSize;
  final bool? hasRoof;   // ✅ تم التصحيح: من int? إلى bool?
  final int? roofSize;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? salesInfo;

  UnitModel({
   this.id,
    this.projectId,
    this.type,
    this.size,
    this.price,
    this.location,
    this.locationLink,
    this.description,
    this.listOfDescription,
    this.images,
    this.bathrooms,
    this.rooms,
    this.hasGarden,
    this.gardenSize,
    this.hasRoof,
    this.roofSize,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.salesInfo,
  });

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'],
      projectId: map['project_id'],
      type: map['type'],
      size: map['size'],
      price: map['price'],
      location: map['location'],
      locationLink: map['location_link'],
      description: map['description'],
      listOfDescription: map['list_of_description'] != null
          ? List<dynamic>.from(map['list_of_description'])
          : null,
      images: map['images'] != null
          ? List<String>.from(map['images'].map((x) => x.toString())) // ✅ تصحيح تحليل الصور
          : null,
      bathrooms: map['bathrooms'],
      rooms: map['rooms'],
      hasGarden: map['has_garden'], // ✅ أصبح يقرأ bool
      gardenSize: map['garden_size'],
      hasRoof: map['has_roof'],     // ✅ أصبح يقرأ bool
      roofSize: map['roof_size'],
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      salesInfo: map['sales_info'] != null
          ? Map<String, dynamic>.from(map['sales_info'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'type': type,
      'size': size,
      'price': price,
      'location': location,
      'location_link': locationLink,
      'description': description,
      'list_of_description': listOfDescription,
      'images': images,
      'bathrooms': bathrooms,
      'rooms': rooms,
      'has_garden': hasGarden,
      'garden_size': gardenSize,
      'has_roof': hasRoof,
      'roof_size': roofSize,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sales_info': salesInfo,
    };
  }

  factory UnitModel.fromJson(String source) => UnitModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnitModel(id: $id, type: $type, has_garden: $hasGarden, has_roof: $hasRoof)';
  }
}