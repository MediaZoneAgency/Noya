import 'package:broker/feature/home/data/models/unit_model.dart';

String? extractUnitTypeFromAI(String response) {
  final regex = RegExp("Type:\\s*(.*)");
  final match = regex.firstMatch(response);
  return match != null ? match.group(1)!.trim() : null;
}

UnitModel parseUnitFromAI(String response) {
  String? type = _tryExtractValue(response, "Type:");
  String? price = _tryExtractValue(response, "Price:")?.replaceAll("EGP", "").replaceAll(",", "").trim();
  String? size = _tryExtractValue(response, "Size:")?.replaceAll("sqm", "").replaceAll("m", "").trim();
  String? rooms = _tryExtractValue(response, "Rooms:");
  String? bathrooms = _tryExtractValue(response, "Bathrooms:");
  String? location = _tryExtractValue(response, "Location:");

  return UnitModel(
    type: type,
    price: price,
    size: int.tryParse(size ?? ""),
    rooms: int.tryParse(rooms ?? ""),
    bathrooms: int.tryParse(bathrooms ?? ""),
    location: location,
    images: [
      "https://via.placeholder.com/300" // صورة افتراضية مؤقتة
    ], 
  );
}

String? _tryExtractValue(String source, String key) {
  final regex = RegExp("$key\\s*(.*)");
  final match = regex.firstMatch(source);
  return match != null ? match.group(1)!.trim() : null;
}
