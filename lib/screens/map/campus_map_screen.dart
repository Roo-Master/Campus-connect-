import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../models/building_model.dart';
import 'navigation_screen.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF1565C0);

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // Animation controller for search dropdown
  late AnimationController _dropdownAnim;
  late Animation<double> _dropdownHeight;
  late Animation<double> _dropdownOpacity;

  final List<BuildingModel> _allBuildings = BuildingModel.getMockBuildings();
  List<BuildingModel> _filteredBuildings = [];
  List<BuildingModel> _searchResults = [];
  BuildingCategory? _selectedCategory;
  BuildingModel? _selectedBuilding;

  LatLng? _currentLocation;
  bool _showBuildingList = true;
  bool _showSearchResults = false;

  static const LatLng _campusCenter = LatLng(-0.6920, 34.7830);

  @override
  void initState() {
    super.initState();
    _filteredBuildings = List.from(_allBuildings);

    _dropdownAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _dropdownHeight = CurvedAnimation(
      parent: _dropdownAnim,
      curve: Curves.easeOutCubic,
    );
    _dropdownOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _dropdownAnim, curve: Curves.easeIn),
    );

    _searchFocus.addListener(() {
      if (!_searchFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) _hideDropdown();
        });
      }
    });

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _dropdownAnim.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showDropdown() {
    setState(() => _showSearchResults = true);
    _dropdownAnim.forward();
  }

  void _hideDropdown() {
    _dropdownAnim.reverse().then((_) {
      if (mounted) setState(() => _showSearchResults = false);
    });
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() => _currentLocation = LatLng(pos.latitude, pos.longitude));
      _sortByNearest();
    } catch (_) {}
  }

  void _sortByNearest() {
    if (_currentLocation == null) return;
    const dist = Distance();
    setState(() {
      _filteredBuildings.sort((a, b) {
        final da = dist(_currentLocation!, LatLng(a.latitude, a.longitude));
        final db = dist(_currentLocation!, LatLng(b.latitude, b.longitude));
        return da.compareTo(db);
      });
    });
  }

  String _getDistance(BuildingModel b) {
    if (_currentLocation == null) return '';
    final m =
        const Distance()(_currentLocation!, LatLng(b.latitude, b.longitude));
    return m < 1000
        ? '${m.toStringAsFixed(0)} m away'
        : '${(m / 1000).toStringAsFixed(1)} km away';
  }

  String _getWalkTime(BuildingModel b) {
    if (_currentLocation == null) return '';
    final m =
        const Distance()(_currentLocation!, LatLng(b.latitude, b.longitude));
    final min = (m / 80).ceil();
    return min < 1 ? '< 1 min walk' : '$min min walk';
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    final results = _allBuildings.where((b) {
      final matchQ = q.isEmpty ||
          b.name.toLowerCase().contains(q) ||
          b.code.toLowerCase().contains(q) ||
          b.description.toLowerCase().contains(q);
      final matchC =
          _selectedCategory == null || b.category == _selectedCategory;
      return matchQ && matchC;
    }).toList();

    setState(() {
      _filteredBuildings = results;
      _searchResults = results;
    });

    if (q.isNotEmpty) {
      _showDropdown();
    } else {
      _hideDropdown();
    }

    if (_currentLocation != null) _sortByNearest();
  }

  void _selectSearchResult(BuildingModel b) {
    _searchController.text = b.name;
    _searchFocus.unfocus();
    _hideDropdown();
    _focusOnBuilding(b);
  }

  void _filterByCategory(BuildingCategory? cat) {
    setState(() => _selectedCategory = cat);
    _onSearch(_searchController.text);
  }

  // ── Map actions ────────────────────────────────────────────────────────────

  void _navigateTo(BuildingModel b) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationScreen(
          destinationName: b.name,
          destination: LatLng(b.latitude, b.longitude),
        ),
      ),
    );
  }

  void _focusOnBuilding(BuildingModel b) {
    setState(() {
      _selectedBuilding = b;
      _showBuildingList = false;
    });
    _mapController.move(LatLng(b.latitude, b.longitude), 18.0);
  }

  Color _catColor(BuildingCategory c) {
    switch (c) {
      case BuildingCategory.academic:
        return const Color(0xFF1565C0);
      case BuildingCategory.admin:
        return const Color(0xFF6A1B9A);
      case BuildingCategory.health:
        return const Color(0xFFC62828);
      case BuildingCategory.food:
        return const Color(0xFFE65100);
      case BuildingCategory.sports:
        return const Color(0xFF2E7D32);
      case BuildingCategory.hostel:
        return const Color(0xFF00695C);
      case BuildingCategory.other:
        return const Color(0xFF546E7A);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          // ① Full-screen map
          _buildMap(),

          // ② Search bar + category chips + animated dropdown
          Positioned(
            top: topPad + 8,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _searchBar(),
                const SizedBox(height: 8),
                _categoryChips(),
                _animatedDropdown(),
              ],
            ),
          ),

          // ③ Bottom building panel
          if (_showBuildingList)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildingListPanel(),
            ),

          // ④ Selected building card
          if (!_showBuildingList && _selectedBuilding != null)
            Positioned(
              bottom: 20,
              left: 12,
              right: 12,
              child: _selectedBuildingCard(),
            ),

          // ⑤ FABs
          Positioned(
            bottom: _showBuildingList ? 270 : 150,
            right: 12,
            child: Column(
              children: [
                _fab('loc', Icons.my_location, () {
                  if (_currentLocation != null) {
                    _mapController.move(_currentLocation!, 17.0);
                  } else {
                    _getCurrentLocation();
                  }
                }),
                const SizedBox(height: 8),
                _fab(
                    'list', _showBuildingList ? Icons.map_outlined : Icons.list,
                    () {
                  setState(() => _showBuildingList = !_showBuildingList);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────

  Widget _searchBar() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          onChanged: _onSearch,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search buildings, rooms, facilities…',
            hintStyle: TextStyle(
              color: Colors.grey[450],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon:
                const Icon(Icons.search, color: Color(0xFF1565C0), size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                      _searchFocus.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
        ),
      );

  // ── Category chips ─────────────────────────────────────────────────────────

  Widget _categoryChips() => SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _chip(null, '🗺️ All'),
            ...BuildingCategory.values.map(
              (c) => _chip(c, '${c.emoji} ${c.label}'),
            ),
          ],
        ),
      );

  Widget _chip(BuildingCategory? cat, String label) {
    final sel = _selectedCategory == cat;
    return GestureDetector(
      onTap: () => _filterByCategory(cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5)
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: sel ? Colors.white : Colors.grey[800],
            fontSize: 12,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Animated search dropdown ───────────────────────────────────────────────

  Widget _animatedDropdown() {
    if (!_showSearchResults && _dropdownAnim.isDismissed) {
      return const SizedBox.shrink();
    }

    final maxItems = _searchResults.length.clamp(0, 6);
    const itemH = 68.0;
    final maxHeight = maxItems == 0 ? 56.0 : maxItems * itemH;

    return FadeTransition(
      opacity: _dropdownOpacity,
      child: SizeTransition(
        sizeFactor: _dropdownHeight,
        axisAlignment: -1,
        child: Container(
          margin: const EdgeInsets.only(top: 6),
          constraints: BoxConstraints(maxHeight: maxHeight + 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.13),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _searchResults.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.search_off, color: Colors.grey, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'No buildings found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: maxItems,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (ctx, i) {
                      final b = _searchResults[i];
                      final color = _catColor(b.category);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectSearchResult(b),
                          splashColor: color.withValues(alpha: 0.08),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                // Icon circle
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: color.withValues(alpha: 0.2)),
                                  ),
                                  child: Center(
                                    child: Text(b.category.emoji,
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Name + subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${b.category.label}  •  ${_currentLocation != null ? _getWalkTime(b) : b.code}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Arrow + Go button
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.chevron_right,
                                        color: Colors.grey[350], size: 20),
                                    GestureDetector(
                                      onTap: () {
                                        _hideDropdown();
                                        _navigateTo(b);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Go',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  // ── Full-screen map ────────────────────────────────────────────────────────

  Widget _buildMap() => FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? _campusCenter,
          initialZoom: 16.0,
          onTap: (_, __) {
            _searchFocus.unfocus();
            _hideDropdown();
            setState(() {
              _selectedBuilding = null;
              _showBuildingList = true;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.campusconnect.app',
          ),
          MarkerLayer(
            markers: [
              // User location dot
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
                            color: Colors.blue, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),

              // Building markers
              ..._allBuildings.map((b) {
                final sel = _selectedBuilding?.id == b.id;
                final color = _catColor(b.category);
                return Marker(
                  point: LatLng(b.latitude, b.longitude),
                  width: sel ? 110 : 90,
                  height: sel ? 62 : 52,
                  child: GestureDetector(
                    onTap: () => _focusOnBuilding(b),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: sel ? 8 : 6,
                            vertical: sel ? 3 : 2,
                          ),
                          decoration: BoxDecoration(
                            color: sel ? color : color.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            b.code,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: sel ? 11 : 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Icon(Icons.location_on,
                            color: color, size: sel ? 30 : 22),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      );

  // ── Bottom building list panel ─────────────────────────────────────────────

  Widget _buildingListPanel() => Container(
        height: 270,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.location_city,
                        color: _primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _currentLocation != null
                        ? 'Nearest to You'
                        : 'All Buildings',
                    style: const TextStyle(
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
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_filteredBuildings.length} buildings',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable horizontal card list
            Expanded(
              child: _filteredBuildings.isEmpty
                  ? Center(
                      child: Text(
                        'No buildings found',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                      itemCount: _filteredBuildings.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (ctx, i) =>
                          _buildingCard(_filteredBuildings[i]),
                    ),
            ),
          ],
        ),
      );

  Widget _buildingCard(BuildingModel b) {
    final color = _catColor(b.category);
    final sel = _selectedBuilding?.id == b.id;

    return GestureDetector(
      onTap: () => _focusOnBuilding(b),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 185,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? color.withValues(alpha: 0.07) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? color : Colors.grey.shade200,
            width: sel ? 2 : 1,
          ),
          boxShadow: sel
              ? [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 8)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${b.category.emoji} ${b.category.label}',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Name
            Text(
              b.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Distance / walk time
            if (_currentLocation != null) ...[
              Row(
                children: [
                  Icon(Icons.straighten, size: 11, color: Colors.grey[500]),
                  const SizedBox(width: 3),
                  Text(
                    _getDistance(b),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.directions_walk,
                      size: 11, color: Colors.green[600]),
                  const SizedBox(width: 3),
                  Text(
                    _getWalkTime(b),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            // Go button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateTo(b),
                icon: const Icon(Icons.directions, size: 14),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Selected building card ─────────────────────────────────────────────────

  Widget _selectedBuildingCard() {
    final b = _selectedBuilding!;
    final color = _catColor(b.category);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(b.category.emoji,
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      '${b.category.label}  •  ${b.floors} floor${b.floors > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _selectedBuilding = null;
                  _showBuildingList = true;
                }),
                icon: Icon(Icons.close, color: Colors.grey[400], size: 22),
              ),
            ],
          ),
          if (_currentLocation != null) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip2(Icons.straighten, _getDistance(b), Colors.blue),
                  const SizedBox(width: 8),
                  _chip2(Icons.directions_walk, _getWalkTime(b), Colors.green),
                  const SizedBox(width: 8),
                  _chip2(Icons.access_time, b.openingTime, Colors.orange),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _navigateTo(b),
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text(
                    'Get Directions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _showDetails(b),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  side: BorderSide(color: color.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Details',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip2(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  // ── FAB helper ─────────────────────────────────────────────────────────────

  Widget _fab(String tag, IconData icon, VoidCallback onPressed) =>
      FloatingActionButton.small(
        heroTag: tag,
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: _primary,
        elevation: 3,
        child: Icon(icon),
      );

  // ── Building details bottom sheet ──────────────────────────────────────────

  void _showDetails(BuildingModel b) {
    final color = _catColor(b.category);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (ctx2, scroll) => SingleChildScrollView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(b.category.emoji,
                            style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            b.code,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (b.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    b.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Info rows
                _infoRow(Icons.access_time, 'Hours',
                    '${b.openingTime} – ${b.closingTime}', color),
                _infoRow(Icons.layers, 'Floors',
                    '${b.floors} floor${b.floors > 1 ? 's' : ''}', color),
                _infoRow(Icons.accessible, 'Accessible',
                    b.isAccessible ? 'Yes' : 'No', color),
                if (_currentLocation != null) ...[
                  _infoRow(
                      Icons.straighten, 'Distance', _getDistance(b), color),
                  _infoRow(
                      Icons.directions_walk, 'Walking', _getWalkTime(b), color),
                ],

                // Facilities
                const SizedBox(height: 16),
                _sectionTitle('Facilities'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: b.facilities
                      .map((f) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: color.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                // Rooms
                if (b.rooms.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('Rooms & Halls'),
                  const SizedBox(height: 8),
                  ...b.rooms.map((r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.meeting_room,
                                color: color, size: 18),
                          ),
                          title: Text(
                            '${r.type} ${r.number}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          subtitle: Text(
                            'Floor ${r.floor}  •  Capacity: ${r.capacity}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              _navigateTo(b);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Go',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _navigateTo(b);
                    },
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text(
                      'Get Directions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
          letterSpacing: 0.2,
        ),
      );

  Widget _infoRow(IconData icon, String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
