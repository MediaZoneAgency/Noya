import 'dart:convert';
import 'dart:developer'; // لإجراء التحويل من JSON إلى قائمة

class UnitModel {
  int? id;
  int? project_id;
  String? type;
  int? size;
  String? price;
  String? location;
  String? location_link;
  String? description;
  String? listOfDescription;
  List<dynamic>? images;
  int? bathrooms;
  int? rooms;
  int? has_garden;
  int? garden_size;
  int? has_roof;
  int? roof_size;
  String? status;
  String? created_at;
  String? updated_at;
  Map<dynamic, dynamic>? sales_info;

  UnitModel({
    this.id,
    this.project_id,
    this.type,
    this.size,
    this.price,
    this.location,
    this.location_link,
    this.description,
    this.listOfDescription,
    this.images,
    this.bathrooms,
    this.rooms,
    this.has_garden,
    this.garden_size,
    this.has_roof,
    this.roof_size,
    this.status,
    this.created_at,
    this.updated_at,
    this.sales_info,
  });

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    log('Images field: ${map['images']}'); // أضفه هنا لتسجيل قيمة الحقل
    return UnitModel(
      id: map['id'],
      project_id: map['project_id'],
      type: map['type'],
      size: map['size'],
      price: map['price'],
      location: map['location'],
      location_link: map['location_link'],
      description: map['description'],
      listOfDescription: map['listOfDescription'],
      images: map['images'] is String
          ? [map['images']] // إذا كان رابط واحد، تحويله إلى قائمة
          : (map['images'] as List<dynamic>? ?? []), // إذا كانت قائمة، استخدامها كما هي
      bathrooms: map['bathrooms'],
      rooms: map['rooms'],
      has_garden: map['has_garden'],
      garden_size: map['garden_size'],
      has_roof: map['has_roof'],
      roof_size: map['roof_size'],
      status: map['status'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      sales_info: map['sales_info'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': project_id,
      'type': type,
      'size': size,
      'price': price,
      'location': location,
      'location_link': location_link,
      'description': description,
      'listOfDescription': listOfDescription,
      'images': images,
      'bathrooms': bathrooms,
      'rooms': rooms,
      'has_garden': has_garden,
      'garden_size': garden_size,
      'has_roof': has_roof,
      'roof_size': roof_size,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'sales_info': sales_info,
    };
  }

  @override
  String toString() {
    return 'UnitModel{id: $id, project_id: $project_id, type: $type, size: $size, price: $price, location: $location, location_link: $location_link, description: $description, listOfDescription: $listOfDescription, images: $images, bathrooms: $bathrooms, rooms: $rooms, has_garden: $has_garden, garden_size: $garden_size, has_roof: $has_roof, roof_size: $roof_size, status: $status, created_at: $created_at, updated_at: $updated_at, sales_info: $sales_info}';
  }
}
