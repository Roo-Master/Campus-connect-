import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: _buildIcon(Icons.home_outlined, 0),
          selectedIcon: _buildIcon(Icons.home, 0),
          label: 'Home',
        ),
        NavigationDestination(
          icon: _buildIcon(Icons.calendar_today_outlined, 1),
          selectedIcon: _buildIcon(Icons.calendar_today, 1),
          label: 'Events',
        ),
        NavigationDestination(
          icon: _buildIcon(Icons.map_outlined, 2),
          selectedIcon: _buildIcon(Icons.map, 2),
          label: 'Map',
        ),
        NavigationDestination(
          icon: _buildIcon(Icons.person_outline, 3),
          selectedIcon: _buildIcon(Icons.person, 3),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return Stack(
      children: [
        Icon(icon),
      ],
    );
  }
}