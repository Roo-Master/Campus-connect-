import 'dart:ui'
    as ui; // Fix 4: import dart:ui to avoid Path conflict with flutter_map

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/routing_service.dart';

class NavigationScreen extends StatefulWidget {
  final String destinationName;
  final LatLng destination;

  const NavigationScreen({
    super.key,
    required this.destinationName,
    required this.destination,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  static const Color _primary = Color(0xFF1565C0);
  static const Color _primaryLight = Color(0xFF1E88E5);

  final MapController _mapController = MapController();

  LatLng? _currentLocation;
  RouteResult? _currentRoute;
  TravelMode _selectedMode = TravelMode.walking;

  bool _isLoadingLocation = true;
  bool _isLoadingRoute = false;
  bool _showSteps = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getCurrentLocation();
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permission denied. Enable it in Settings.';
          _isLoadingLocation = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        _isLoadingLocation = false;
      });
      await _fetchRoute();
    } catch (_) {
      setState(() {
        _errorMessage = 'Could not get your location. Try again.';
        _isLoadingLocation = false;
      });
    }
  }

  // ── Route ──────────────────────────────────────────────────────────────────

  Future<void> _fetchRoute() async {
    if (_currentLocation == null) return;
    setState(() {
      _isLoadingRoute = true;
      _errorMessage = null;
    });

    final result = await RoutingService.getRoute(
      origin: _currentLocation!,
      destination: widget.destination,
      mode: _selectedMode,
    );

    if (!mounted) return;
    setState(() {
      _currentRoute = result;
      _isLoadingRoute = false;
      if (result == null) {
        _errorMessage = 'No route found. Check your connection and try again.';
      }
    });

    if (result != null && result.polylinePoints.isNotEmpty) {
      _fitMap(result.polylinePoints);
    }
  }

  void _fitMap(List<LatLng> pts) {
    if (pts.isEmpty) return;
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(minLat - 0.001, minLng - 0.001),
          LatLng(maxLat + 0.001, maxLng + 0.001),
        ),
        padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
      ),
    );
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _appBar(),
      body: Column(
        children: [
          _modeSelector(),
          if (_currentRoute != null) _routeSummary(),
          if (_errorMessage != null) _errorBar(),
          if (_isLoadingLocation || _isLoadingRoute) _loadingBar(),
          Expanded(
            flex: _showSteps ? 4 : 10,
            child: _buildMap(),
          ),
          if (_showSteps && _currentRoute != null)
            Expanded(
              flex: 6,
              child: _stepsList(),
            ),
        ],
      ),
      floatingActionButton: _currentRoute != null
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _showSteps = !_showSteps),
              backgroundColor: _primary,
              elevation: 4,
              icon: Icon(
                _showSteps ? Icons.map_outlined : Icons.format_list_numbered,
                color: Colors.white,
              ),
              label: Text(
                _showSteps ? 'Show Map' : 'Show Directions',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            )
          : null,
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: _primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Directions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              'To: ${widget.destinationName}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _getCurrentLocation,
            tooltip: 'Refresh location',
          ),
        ],
      );

  // ── Mode selector ──────────────────────────────────────────────────────────

  Widget _modeSelector() => Container(
        color: _primary,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Row(
          children: [
            _modeBtn(TravelMode.walking, Icons.directions_walk, 'Walking'),
            const SizedBox(width: 12),
            _modeBtn(TravelMode.driving, Icons.directions_car, 'Driving'),
          ],
        ),
      );

  Widget _modeBtn(TravelMode mode, IconData icon, String label) {
    final sel = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        if (_selectedMode == mode) return;
        setState(() => _selectedMode = mode);
        _fetchRoute();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? Colors.white : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(24),
          boxShadow: sel
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: sel ? _primary : Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: sel ? _primary : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Route summary ──────────────────────────────────────────────────────────

  Widget _routeSummary() {
    final r = _currentRoute!;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _summaryTile(
              Icons.straighten, r.totalDistanceText, 'Distance', _primary),
          _vDivider(),
          _summaryTile(Icons.access_time_filled, r.totalDurationText,
              'Est. Time', Colors.orange.shade700),
          _vDivider(),
          _summaryTile(
            r.mode == TravelMode.walking
                ? Icons.directions_walk
                : Icons.directions_car,
            r.mode == TravelMode.walking ? 'Walking' : 'Driving',
            'Mode',
            Colors.green.shade700,
          ),
          _vDivider(),
          _summaryTile(Icons.format_list_numbered, '${r.steps.length}', 'Steps',
              Colors.purple.shade600),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 42, color: Colors.grey.shade200);

  Widget _summaryTile(IconData icon, String val, String label, Color color) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(val,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.grey[850], // Fix 1: removed invalid .shade850
              )),
          Text(label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              )),
        ],
      );

  // ── Error bar ──────────────────────────────────────────────────────────────

  Widget _errorBar() => Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: _getCurrentLocation,
              child: Text('Retry',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
      );

  // ── Loading bar ────────────────────────────────────────────────────────────

  Widget _loadingBar() => Container(
        color: _primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              _isLoadingLocation
                  ? 'Getting your location…'
                  : 'Calculating route…',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  // ── Map ────────────────────────────────────────────────────────────────────

  Widget _buildMap() {
    final routeColor =
        _selectedMode == TravelMode.walking ? Colors.green.shade600 : _primary;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation ?? widget.destination,
            initialZoom: 15.0,
          ),
          children: [
            // ── OSM tiles ────────────────────────────────────────────────────
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.campusconnect.app',
            ),

            // ── Route polyline ────────────────────────────────────────────
            if (_currentRoute != null &&
                _currentRoute!.polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _currentRoute!.polylinePoints,
                    strokeWidth: 9,
                    color: routeColor.withValues(alpha: 0.25),
                  ),
                  Polyline(
                    points: _currentRoute!.polylinePoints,
                    strokeWidth: 5,
                    color: routeColor,
                  ),
                ],
              ),

            // ── Markers ───────────────────────────────────────────────────
            MarkerLayer(
              markers: [
                if (_currentLocation != null)
                  Marker(
                    point: _currentLocation!,
                    width: 52,
                    height: 52,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.blue.shade600, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.45),
                              blurRadius: 12,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                Marker(
                  point: widget.destination,
                  width: 60,
                  height: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.school,
                            color: Colors.white, size: 20),
                      ),
                      CustomPaint(
                        size: const Size(16, 10),
                        painter: _TrianglePainter(Colors.red.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Zoom controls
        Positioned(
          right: 12,
          bottom: 12,
          child: Column(
            children: [
              _mapBtn(
                  Icons.add,
                  () => _mapController.move(_mapController.camera.center,
                      _mapController.camera.zoom + 1)),
              const SizedBox(height: 6),
              _mapBtn(
                  Icons.remove,
                  () => _mapController.move(_mapController.camera.center,
                      _mapController.camera.zoom - 1)),
              const SizedBox(height: 6),
              _mapBtn(Icons.center_focus_strong, () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 17);
                }
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15), blurRadius: 6),
            ],
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
      );

  // ── Steps list ─────────────────────────────────────────────────────────────

  Widget _stepsList() {
    final steps = _currentRoute!.steps;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.format_list_numbered,
                      size: 16, color: _primary),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Turn-by-Turn Directions',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: _primary,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${steps.length} steps',
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable steps ───────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: steps.length,
              itemBuilder: (ctx, i) {
                final step = steps[i];
                final isFirst = i == 0;
                final isLast = i == steps.length - 1;

                final Color stepColor = isFirst
                    ? Colors.green.shade700
                    : isLast
                        ? Colors.red.shade600
                        : _primary;

                final Color bgColor = isFirst
                    ? Colors.green.withValues(alpha: 0.04)
                    : isLast
                        ? Colors.red.withValues(alpha: 0.04)
                        : (i % 2 == 0 ? Colors.white : Colors.grey.shade50);

                return Column(
                  children: [
                    Container(
                      color: bgColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Step icon circle
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: stepColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: stepColor.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Builder(
                              builder: (context) {
                                final icon = RoutingService.getManeuverIcon(
                                  step.maneuverType,
                                  _selectedMode.name,
                                );

                                // ✅ Handle both IconData and String safely
                                if (icon is IconData) {
                                  return Icon(
                                    icon as IconData?,
                                    color: stepColor,
                                    size: 22,
                                  );
                                } else if (icon is String) {
                                  return Center(
                                    child: Text(
                                      icon as String,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                } else {
                                  // fallback (never crash)
                                  return Icon(
                                    Icons.navigation,
                                    color: stepColor,
                                    size: 22,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Instruction
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.instruction,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isFirst || isLast
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: Colors.grey[850],
                                    height: 1.3,
                                  ),
                                ),
                                if (!isFirst && !isLast)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      step.distanceText,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Distance + time
                          if (!isLast)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  step.distanceText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: stepColor,
                                  ),
                                ),
                                Text(
                                  step.durationText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            )
                          else
                            Icon(
                              Icons.flag_rounded,
                              color: Colors.red.shade600,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                    if (i < steps.length - 1)
                      Divider(height: 1, color: Colors.grey.shade200),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Triangle pointer for destination marker ────────────────────────────────
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // Fix 4: use ui.Path to avoid name collision with flutter_map's Path<LatLng>
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
