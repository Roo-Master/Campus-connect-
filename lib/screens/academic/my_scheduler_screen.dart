import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  final String title;
  final String type; // 'Event', 'Class', 'Cats/Exams'
  final String venue;
  final DateTime dateTime;
  final Color color;

  Event({
    required this.title,
    required this.type,
    required this.venue,
    required this.dateTime,
    required this.color,
  });
}

class MySchedulerScreen extends StatefulWidget {
  const MySchedulerScreen({super.key});

  @override
  State<MySchedulerScreen> createState() => _MySchedulerScreenState();
}

class _MySchedulerScreenState extends State<MySchedulerScreen> {
  List<Event> events = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Scheduler'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter by type
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'All',
                    decoration: InputDecoration(
                      labelText: 'Filter by Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['All', 'Event', 'Class', 'Cats/Exams']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Implement filtering logic here if needed
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: () => _showAddEventDialog(context),
                  backgroundColor: Colors.blue[700],
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          // Events List
          Expanded(
            child: events.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No events scheduled',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Tap + to add your first event',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      color: event.color.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: event.color,
          child: Text(
            event.dateTime.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${event.type} • ${event.venue}'),
            Text(
              '${dateFormat.format(event.dateTime)} • ${timeFormat.format(event.dateTime)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteEvent(event),
        ),
        onTap: () => _showEditEventDialog(context, event),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    _showEventDialog(context, 'Add Event', null);
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    _showEventDialog(context, 'Edit Event', event);
  }

  void _showEventDialog(BuildContext context, String title, Event? event) {
    String selectedType = event?.type ?? 'Event';
    DateTime selectedDateTime = event?.dateTime ?? DateTime.now();
    _titleController.text = event?.title ?? '';
    _venueController.text = event?.venue ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['Event', 'Class', 'Cats/Exams'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _venueController,
                      decoration: const InputDecoration(
                        labelText: 'Venue',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text('Date & Time'),
                      subtitle: Text(
                        DateFormat('MMM dd, yyyy \'at\' hh:mm a')
                            .format(selectedDateTime),
                      ),
                      trailing: const Icon(Icons.schedule),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(selectedDateTime),
                          );
                          if (time != null) {
                            setState(() {
                              selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final venue = _venueController.text.trim();

                    if (title.isNotEmpty && venue.isNotEmpty) {
                      final color = _getColorForType(selectedType);
                      final newEvent = Event(
                        title: title,
                        type: selectedType,
                        venue: venue,
                        dateTime: selectedDateTime,
                        color: color,
                      );

                      setState(() {
                        if (event != null) {
                          final index = events.indexOf(event);
                          events[index] = newEvent;
                        } else {
                          events.add(newEvent);
                          events
                              .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                        }
                      });

                      Navigator.of(context).pop();
                      _titleController.clear();
                      _venueController.clear();
                    }
                  },
                  child: Text(event != null ? 'Update' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Event':
        return Colors.green;
      case 'Class':
        return Colors.orange;
      case 'Cats/Exams':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                events.remove(event);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    super.dispose();
  }
}
