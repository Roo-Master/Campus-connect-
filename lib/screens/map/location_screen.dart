import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure to import this to use launchUrl

class LocationDetailScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? address;

  const LocationDetailScreen({
    super.key,
    this.latitude,
    this.longitude,
    this.locationName,
    this.address,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  bool _isLaunching = false;

  // Common error message to avoid repetition
  static const String locationErrorMessage =
      'Location coordinates not available';
  static const String mapsErrorMessage = 'Failed to open maps: ';

  // Method to handle launching of Google Maps or fallback to Apple Maps
  Future<void> _openGoogleMaps() async {
    if (_hasValidCoordinates()) {
      await _launchMapUrl(
        'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}&travelmode=driving',
      );
    }
  }

  // Method to handle launching Apple Maps as a fallback
  Future<void> _openAppleMaps() async {
    if (_hasValidCoordinates()) {
      await _launchMapUrl(
        'maps://?daddr=${widget.latitude},${widget.longitude}&dirflg=d',
      );
    }
  }

  // Checks if coordinates are valid
  bool _hasValidCoordinates() {
    if (widget.latitude == null || widget.longitude == null) {
      _showError(locationErrorMessage);
      return false;
    }
    return true;
  }

  // Method to launch the URL based on the platform's supported map app
  Future<void> _launchMapUrl(String url) async {
    setState(() => _isLaunching = true);

    final Uri mapUri = Uri.parse(url);

    try {
      if (await canLaunch(mapUri.toString())) {
        await launch(mapUri.toString());
      } else {
        _showError(mapsErrorMessage);
      }
    } catch (e) {
      _showError('$mapsErrorMessage$e');
    } finally {
      setState(() => _isLaunching = false);
    }
  }

  // Method to show an error message as a snack bar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // UI for the location details screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName ?? 'Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location info Card
            _buildLocationInfoCard(),
            const SizedBox(height: 24),
            // Get Directions Button
            _buildGetDirectionsButton(),
            const SizedBox(height: 12),
            // Travel mode options
            _buildTravelModeOptions(),
          ],
        ),
      ),
    );
  }

  // Widget to build the location info card
  Widget _buildLocationInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.locationName ?? 'Unknown Location',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.address ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lat: ${widget.latitude}, Lng: ${widget.longitude}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the 'Get Directions' button
  Widget _buildGetDirectionsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLaunching ? null : _openGoogleMaps,
        icon: _isLaunching
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.directions),
        label: Text(_isLaunching ? 'Opening Maps...' : 'Get Directions'),
      ),
    );
  }

  // Widget to build travel mode options (Driving, Walking, Transit)
  Widget _buildTravelModeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose travel mode:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        _buildTravelModeButton('Driving', Icons.directions_car, 'driving'),
        _buildTravelModeButton('Walking', Icons.directions_walk, 'walking'),
        _buildTravelModeButton(
            'Public Transit', Icons.directions_transit, 'transit'),
      ],
    );
  }

  // Helper widget to create a button for each travel mode
  Widget _buildTravelModeButton(String label, IconData icon, String mode) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openWithMode(mode),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  // Method to handle opening maps with a specific travel mode
  Future<void> _openWithMode(String mode) async {
    if (_hasValidCoordinates()) {
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}&travelmode=$mode',
      );
      await _launchMapUrl(uri.toString());
    }
  }
}
