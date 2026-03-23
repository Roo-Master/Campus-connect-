// lib/models/room_model.dart

class RoomModel {
  final String id;
  final String roomName; // e.g. "LR 204"
  final String buildingName; // e.g. "Main Block"
  final String floor; // e.g. "2nd Floor"
  final double latitude;
  final double longitude;
  final String? description; // optional extra info

  RoomModel({
    required this.id,
    required this.roomName,
    required this.buildingName,
    required this.floor,
    required this.latitude,
    required this.longitude,
    this.description,
  });

  /// Create a RoomModel from a Firestore document
  factory RoomModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return RoomModel(
      id: docId,
      roomName: data['roomName'] ?? '',
      buildingName: data['buildingName'] ?? '',
      floor: data['floor'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      description: data['description'],
    );
  }

  /// Convert RoomModel to a Map (for saving to Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'roomName': roomName,
      'buildingName': buildingName,
      'floor': floor,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }

  /// Full display label e.g. "LR 204 - Main Block, 2nd Floor"
  String get fullLabel => '$roomName - $buildingName, $floor';
}
