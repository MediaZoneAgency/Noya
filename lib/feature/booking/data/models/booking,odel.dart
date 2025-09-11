// lib/feature/bookings/data/models/booking_model.dart

class BookingModel {
  final int id;
  final DateTime viewingDate;
  final int propertyId;
  final String status;
  final BookedProperty property;

  BookingModel({
    required this.id,
    required this.viewingDate,
    required this.propertyId,
    required this.status,
    required this.property,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      // Safely parse the date
      viewingDate: DateTime.parse(json['viewing_date'] as String),
      propertyId: json['property_id'] as int,
      status: json['status'] as String,
      property: BookedProperty.fromJson(json['property'] as Map<String, dynamic>),
    );
  }
}

class BookedProperty {
  final int id;
  final String price;
  final String location;
  // You can add more fields here if the API provides them, like images, type, etc.

  BookedProperty({
    required this.id,
    required this.price,
    required this.location,
  });

  factory BookedProperty.fromJson(Map<String, dynamic> json) {
    return BookedProperty(
      id: json['id'] as int,
      price: json['price'] as String,
      location: json['location'] as String,
    );
  }
}