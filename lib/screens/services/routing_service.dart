import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum TravelMode { walking, driving }

class RouteStep {
  final String instruction;
  final double distance;
  final double duration;
  final String maneuverType;
  final String modifier;

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.maneuverType,
    this.modifier = '',
  });

  String get distanceText {
    if (distance < 1000) return '${distance.toStringAsFixed(0)} m';
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  String get durationText {
    if (duration < 60) return '${duration.toStringAsFixed(0)} sec';
    return '${(duration / 60).toStringAsFixed(0)} min';
  }
}

class RouteResult {
  final List<LatLng> polylinePoints;
  final List<RouteStep> steps;
  final double totalDistance;
  final double totalDuration;
  final TravelMode mode;

  RouteResult({
    required this.polylinePoints,
    required this.steps,
    required this.totalDistance,
    required this.totalDuration,
    required this.mode,
  });

  String get totalDistanceText {
    if (totalDistance < 1000) return '${totalDistance.toStringAsFixed(0)} m';
    return '${(totalDistance / 1000).toStringAsFixed(1)} km';
  }

  String get totalDurationText {
    if (totalDuration < 60) return '${totalDuration.toStringAsFixed(0)} sec';
    if (totalDuration < 3600)
      return '${(totalDuration / 60).toStringAsFixed(0)} min';
    final h = (totalDuration / 3600).floor();
    final m = ((totalDuration % 3600) / 60).floor();
    return '${h}h ${m}min';
  }
}

class RoutingService {
  static const _baseUrl = 'https://router.project-osrm.org/route/v1';

  static Future<RouteResult?> getRoute({
    required LatLng origin,
    required LatLng destination,
    required TravelMode mode,
  }) async {
    final profile = mode == TravelMode.walking ? 'foot' : 'driving';
    final url = '$_baseUrl/$profile/${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?steps=true&geometries=geojson&overview=full&annotations=false';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['code'] != 'Ok') return null;

      final routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) return null;

      final route = routes[0] as Map<String, dynamic>;
      final leg = (route['legs'] as List<dynamic>)[0] as Map<String, dynamic>;

      final coords = ((route['geometry']
          as Map<String, dynamic>)['coordinates']) as List<dynamic>;
      final polylinePoints = coords
          .map(
              (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      final steps = (leg['steps'] as List<dynamic>).map((s) {
        final step = s as Map<String, dynamic>;
        final maneuver = step['maneuver'] as Map<String, dynamic>;
        final type = (maneuver['type'] ?? 'turn') as String;
        final modifier = (maneuver['modifier'] ?? '') as String;
        final name = (step['name'] ?? '') as String;
        return RouteStep(
          instruction: _buildInstruction(type, modifier, name),
          distance: (step['distance'] as num).toDouble(),
          duration: (step['duration'] as num).toDouble(),
          maneuverType: type,
          modifier: modifier,
        );
      }).toList();

      return RouteResult(
        polylinePoints: polylinePoints,
        steps: steps,
        totalDistance: (leg['distance'] as num).toDouble(),
        totalDuration: (leg['duration'] as num).toDouble(),
        mode: mode,
      );
    } catch (_) {
      return null;
    }
  }

  static String _buildInstruction(String type, String mod, String street) {
    final on = street.isNotEmpty ? ' onto $street' : '';
    switch (type) {
      case 'depart':
        return 'Start heading${on.isNotEmpty ? on : ' forward'}';
      case 'arrive':
        return 'You have arrived at your destination';
      case 'turn':
        switch (mod) {
          case 'left':
            return 'Turn left$on';
          case 'right':
            return 'Turn right$on';
          case 'slight left':
            return 'Bear left$on';
          case 'slight right':
            return 'Bear right$on';
          case 'sharp left':
            return 'Turn sharply left$on';
          case 'sharp right':
            return 'Turn sharply right$on';
          case 'uturn':
            return 'Make a U-turn';
          default:
            return 'Continue$on';
        }
      case 'continue':
        return 'Continue$on';
      case 'merge':
        return 'Merge$on';
      case 'roundabout':
        return 'Enter the roundabout$on';
      case 'exit roundabout':
        return 'Exit the roundabout$on';
      default:
        return 'Continue$on';
    }
  }

  static IconData getManeuverIcon(String type, String modifier) {
    switch (type) {
      case 'depart':
        return Icons.my_location;
      case 'arrive':
        return Icons.flag;
      case 'turn':
        switch (modifier) {
          case 'left':
          case 'slight left':
          case 'sharp left':
            return Icons.turn_left;
          case 'right':
          case 'slight right':
          case 'sharp right':
            return Icons.turn_right;
          case 'uturn':
            return Icons.u_turn_left;
          default:
            return Icons.straight;
        }
      case 'roundabout':
        return Icons.roundabout_left;
      default:
        return Icons.straight;
    }
  }
}
