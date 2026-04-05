// lib/screens/map/map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../models/room_model.dart';
import '../../widgets/room_search_bar.dart';
import '../services/map_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();
  final MapController _mapController = MapController();

  // State variables
  LatLng? _currentLocation;
  RoomModel? _selectedRoom;
  List<RoomModel> _searchResults = [];
  List<LatLng> _routePoints = [];
  bool _isLoadingLocation = true;
  bool _isLoadingRoute = false;
  bool _showSearchResults = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  // ── Load student's GPS location ──────────────────────────────────────────

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      final Position position = await _mapService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
      // Move map to student's location
      _mapController.move(_currentLocation!, 17.0);
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ── Search rooms ─────────────────────────────────────────────────────────

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    final results = await _mapService.searchRooms(query);
    setState(() {
      _searchResults = results.cast<RoomModel>();
      _showSearchResults = true;
    });
  }

  void _onClear() {
    setState(() {
      _searchResults = [];
      _showSearchResults = false;
      _selectedRoom = null;
      _routePoints = [];
    });
  }

  // ── Select a room and draw route ─────────────────────────────────────────

  Future<void> _selectRoom(RoomModel room) async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still fetching your location...')),
      );
      return;
    }

    setState(() {
      _selectedRoom = room;
      _showSearchResults = false;
      _isLoadingRoute = true;
    });

    final destination = LatLng(room.latitude, room.longitude);

    try {
      final route = await _mapService.getRoute(_currentLocation!, destination);
      setState(() {
        _routePoints = route;
        _isLoadingRoute = false;
      });

      // Fit map to show both student and destination
      _fitMapToBounds(_currentLocation!, destination);
    } catch (e) {
      setState(() {
        _isLoadingRoute = false;
        _routePoints = [_currentLocation!, destination];
      });
    }
  }

  void _fitMapToBounds(LatLng origin, LatLng destination) {
    final bounds = LatLngBounds(origin, destination);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  // ── Build UI ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          _buildMap(),

          // ── Top search bar ───────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                RoomSearchBar(
                  onSearch: _onSearch,
                  onClear: _onClear,
                ),
                if (_showSearchResults && _searchResults.isNotEmpty)
                  _buildSearchResults(),
                if (_showSearchResults && _searchResults.isEmpty)
                  _buildNoResults(),
              ],
            ),
          ),

          // ── Loading location indicator ───────────────────────────────────
          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),

          // ── Error message ────────────────────────────────────────────────
          if (_errorMessage != null) _buildErrorBanner(),

          // ── Route loading indicator ──────────────────────────────────────
          if (_isLoadingRoute)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 6)
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Finding route...'),
                    ],
                  ),
                ),
              ),
            ),

          // ── Selected room info card ──────────────────────────────────────
          if (_selectedRoom != null && !_isLoadingRoute)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _buildRoomInfoCard(),
            ),

          // ── My location button ───────────────────────────────────────────
          Positioned(
            bottom: _selectedRoom != null ? 140 : 20,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 17.0);
                } else {
                  _loadCurrentLocation();
                }
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  // ── Map widget ────────────────────────────────────────────────────────────

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(-0.6800, 34.7667),
        initialZoom: 16.0,
      ),
      children: [
        // OpenStreetMap tile layer (FREE)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.campusconnect.app',
        ),

        // Route polyline
        if (_routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 5.0,
                color: Colors.blueAccent,
              ),
            ],
          ),

        // Markers
        MarkerLayer(
          markers: [
            // Student's current location
            if (_currentLocation != null)
              Marker(
                point: _currentLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),

            // Destination room marker
            if (_selectedRoom != null)
              Marker(
                point:
                    LatLng(_selectedRoom!.latitude, _selectedRoom!.longitude),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ── Search results dropdown ───────────────────────────────────────────────

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _searchResults.length > 5 ? 5 : _searchResults.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final room = _searchResults[index];
          return ListTile(
            leading: const Icon(Icons.room, color: Colors.blueAccent),
            title: Text(room.roomName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle:
                Text(room.fullLabel, style: const TextStyle(fontSize: 12)),
            onTap: () => _selectRoom(room),
          );
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'No rooms found. Try a different name.',
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ── Room info card at the bottom ──────────────────────────────────────────

  Widget _buildRoomInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, color: Colors.blueAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedRoom!.roomName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${_selectedRoom!.buildingName} · ${_selectedRoom!.floor}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                if (_selectedRoom!.description != null)
                  Text(
                    _selectedRoom!.description!,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _onClear,
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Error banner ──────────────────────────────────────────────────────────

  Widget _buildErrorBanner() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: _loadCurrentLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
