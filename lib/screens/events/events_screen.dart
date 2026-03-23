import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/event_model.dart';
import '../../widgets/event_card.dart';
import 'create_event_screen.dart';
import 'dart:ui';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();

  List<EventModel> events = [];

  final List<String> _categories = [
    'All',
    'Academic',
    'Career',
    'Cultural',
    'Sports',
    'Social',
  ];

  @override
  void initState() {
    super.initState();
    events = EventModel.getMockEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreateEventScreen() async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEventScreen(),
      ),
    );

    if (newEvent != null && newEvent is EventModel) {
      setState(() {
        events.add(newEvent);
      });
    }
  }

  List<EventModel> _getFilteredEvents() {
    List<EventModel> filtered = events;

    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    if (_selectedCategory != 0) {
      filtered = filtered.where((event) {
        return event.category == _categories[_selectedCategory];
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),

      /// 🔥 MODERN BACKGROUND STARTS HERE
      body: Stack(
        children: [
          /// 🌄 BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/cultural.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌫️ DARK + GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// 💎 MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                /// 🔹 GLASS SEARCH + FILTER PANEL
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            /// 🔍 SEARCH
                            TextField(
                              controller: _searchController,
                              onChanged: (value) => setState(() {}),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search events...',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// 📂 CATEGORY FILTER
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _categories.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = entry.key;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _selectedCategory == entry.key
                                            ? AppTheme.primary
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              _selectedCategory == entry.key
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// 📋 EVENTS LIST
                Expanded(
                  child: _buildEventsList(_getFilteredEvents()),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateEventScreen,
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEventsList(List<EventModel> events) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          "No events found",
          style: TextStyle(color: Colors.white), // visible on dark bg
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: events[index],
          onTap: () => _showEventDetails(context, events[index]),
        );
      },
    );
  }

  void _showEventDetails(BuildContext context, EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(event.description),
              const SizedBox(height: 10),
              Text("Location: ${event.location}"),
              Text("Organizer: ${event.organizer}"),
              Text("Date: ${event.date}"),
              Text("Time: ${event.timeRange}"),
            ],
          ),
        );
      },
    );
  }
}
