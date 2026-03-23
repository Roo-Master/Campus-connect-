import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - in real app, fetch from backend
    final catList = [
      {'title': 'Math CAT 1', 'date': '2026-03-15'},
      {'title': 'Physics CAT 1', 'date': '2026-03-18'},
    ];

    final examList = [
      {'title': 'Math Final', 'date': '2026-05-10'},
      {'title': 'Physics Final', 'date': '2026-05-12'},
    ];

    final classList = [
      {'name': 'Class A', 'teacher': 'Mr. John Doe', 'time': '08:00 - 10:00'},
      {'name': 'Class B', 'teacher': 'Ms. Jane Smith', 'time': '10:15 - 12:15'},
    ];

    final campusEvents = [
      {'event': 'Sports Day', 'date': '2026-04-01'},
      {'event': 'Guest Lecture', 'date': '2026-04-10'},
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Schedule & Campus Info'),
          backgroundColor: const Color(0xFF202123),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'CATs'),
              Tab(text: 'Exams'),
              Tab(text: 'Classes'),
              Tab(text: 'Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ================= CATs Tab =================
            _buildCardList(catList, cardType: 'CAT'),
            // ================= Exams Tab =================
            _buildCardList(examList, cardType: 'Exam'),
            // ================= Classes Tab =================
            _buildClassList(classList),
            // ================= Campus Events Tab =================
            _buildCardList(campusEvents, cardType: 'Event'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardList(List<Map<String, String>> items,
      {required String cardType}) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return Card(
          color: const Color(0xFF343541),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              item[cardType == 'Event' ? 'event' : 'title']!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            subtitle: Text(
              'Date: ${item['date']}',
              style: const TextStyle(color: Colors.white70),
            ),
            leading: Icon(
              cardType == 'CAT'
                  ? Icons.book
                  : cardType == 'Exam'
                  ? Icons.school
                  : Icons.event,
              color: Colors.greenAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassList(List<Map<String, String>> classItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: classItems.length,
      itemBuilder: (_, index) {
        final cls = classItems[index];
        return Card(
          color: const Color(0xFF343541),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              cls['name']!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            subtitle: Text(
              'Teacher: ${cls['teacher']}\nTime: ${cls['time']}',
              style: const TextStyle(color: Colors.white70),
            ),
            leading: const Icon(Icons.class_, color: Colors.orangeAccent),
          ),
        );
      },
    );
  }
}