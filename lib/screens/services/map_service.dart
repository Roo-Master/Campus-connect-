// lib/services/map_service.dart

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../models/building_model.dart';
import '../../models/room_model.dart';

class MapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─────────────────────────────────────────────
  // 1. GET STUDENT'S CURRENT LOCATION
  // ─────────────────────────────────────────────

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ─────────────────────────────────────────────
  // 2. SEARCH ROOMS FROM FIRESTORE
  // ─────────────────────────────────────────────

  Future<List<RoomModel>> searchRooms(String query) async {
    if (query.trim().isEmpty) return [];

    final snapshot = await _firestore.collection('rooms').get();

    final results = snapshot.docs
        .map((doc) => RoomModel.fromFirestore(doc.data(), doc.id))
        .where((room) =>
            room.roomName.toLowerCase().contains(query.toLowerCase()) ||
            room.buildingName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results;
  }

  Future<List<RoomModel>> getAllRooms() async {
    final snapshot = await _firestore.collection('rooms').get();
    return snapshot.docs
        .map((doc) => RoomModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // ─────────────────────────────────────────────
  // 3. GET ROUTE BETWEEN TWO POINTS
  // ─────────────────────────────────────────────

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final url = 'https://router.project-osrm.org/route/v1/foot/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;
        return coords
            .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();
      } else {
        throw Exception('Failed to fetch route.');
      }
    } catch (e) {
      // Fallback: straight line if routing fails
      return [origin, destination];
    }
  }

  // ─────────────────────────────────────────────
  // 4. KISII UNIVERSITY ROOM DATA
  //    Call this ONCE from an admin/dev screen
  //    to populate your Firestore database.
  // ─────────────────────────────────────────────

  Future<void> seedSampleRooms() async {
    final List<Map<String, dynamic>> campusRooms = [
      {
        'roomName': 'ICT Room 22',
        'buildingName': 'ICT Block',
        'floor': 'Ground Floor',
        'latitude': -0.6911967259847902,
        'longitude': 34.78667860557033,
        'description': 'ICT computer laboratory',
      },
      {
        'roomName': 'Sakagwa Block',
        'buildingName': 'Sakagwa Block',
        'floor': 'Ground Floor',
        'latitude': -0.6935888634046808,
        'longitude': 34.78482369551909,
        'description': 'Sakagwa lecture block',
      },
      {
        'roomName': 'Tuition Complex',
        'buildingName': 'Tuition Complex',
        'floor': 'Ground Floor',
        'latitude': -0.693835608542582,
        'longitude': 34.78438381326505,
        'description': 'Main tuition complex',
      },
      {
        'roomName': 'Pavilion',
        'buildingName': 'Pavilion',
        'floor': 'Ground Floor',
        'latitude': -0.6931191626919239,
        'longitude': 34.781756306682,
        'description': 'University pavilion',
      },
      {
        'roomName': 'Admin Block',
        'buildingName': 'Administration Block',
        'floor': 'Ground Floor',
        'latitude': -0.6772589027123002,
        'longitude': 34.78015016693769,
        'description': 'University administration offices',
      },
      {
        'roomName': 'School of Law',
        'buildingName': 'School of Law',
        'floor': 'Ground Floor',
        'latitude': -0.6908169223533418,
        'longitude': 34.78589423810216,
        'description': 'School of Law building',
      },
      {
        'roomName': 'Twin Towers Complex',
        'buildingName': 'Twin Towers',
        'floor': 'Ground Floor',
        'latitude': -0.6733631531426383,
        'longitude': 34.7701561227603,
        'description': 'Twin Towers lecture complex',
      },
      {
        'roomName': 'Science Complex',
        'buildingName': 'Science Complex',
        'floor': 'Ground Floor',
        'latitude': -0.6934514822039993,
        'longitude': 34.784233541798905,
        'description': 'Science laboratories and lecture rooms',
      },
      {
        'roomName': 'Medical Annex',
        'buildingName': 'Medical Annex',
        'floor': 'Ground Floor',
        'latitude': -0.6908982056007581,
        'longitude': 34.78267786065657,
        'description': 'Medical school annex building',
      },
      {
        'roomName': 'Dr. Sagini Block',
        'buildingName': 'Dr. Sagini Block',
        'floor': 'Ground Floor',
        'latitude': -0.6947083664056224,
        'longitude': 34.78252181111525,
        'description': 'Dr. Sagini lecture block',
      },
      {
        'roomName': 'Main Library',
        'buildingName': 'Main Library',
        'floor': 'Ground Floor',
        'latitude': -0.6910255431911482,
        'longitude': 34.78559340741842,
        'description': 'Kisii University main library',
      },
      {
        'roomName': 'Amphitheatre',
        'buildingName': 'Amphitheatre',
        'floor': 'Ground Floor',
        'latitude': -0.6910255431911482,
        'longitude': 34.78559340741842,
        'description': 'Open-air amphitheatre',
      },
      {
        'roomName': 'Old Moot Court',
        'buildingName': 'Old Moot Court',
        'floor': 'Ground Floor',
        'latitude': -0.6934514822039993,
        'longitude': 34.784233541798905,
        'description': 'Old moot court building',
      },
    ];

    // Check if rooms already exist to avoid duplicating data
    final existing = await _firestore.collection('rooms').limit(1).get();
    if (existing.docs.isNotEmpty) {
      throw Exception('Rooms already seeded. Clear the collection first.');
    }

    final batch = _firestore.batch();
    for (final room in campusRooms) {
      final ref = _firestore.collection('rooms').doc();
      batch.set(ref, room);
    }
    await batch.commit();
  }
}
