import 'package:flutter/material.dart';

import '../../l10n/config/theme.dart';

class QuickActionsWidget extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActionsWidget({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.menu_book, 'label': 'Courses', 'color': Colors.blue},
      {'icon': Icons.grade, 'label': 'Grades', 'color': Colors.green},
      {'icon': Icons.payment, 'label': 'Fees', 'color': Colors.orange},
      {'icon': Icons.directions_bus, 'label': 'Transport', 'color': Colors.purple},
      {'icon': Icons.local_library, 'label': 'Hostel', 'color': Colors.indigo},
      {'icon': Icons.warning, 'label': 'Emergency', 'color': Colors.red},
      {'icon': Icons.event, 'label': 'Events', 'color': Colors.cyan},
      {'icon': Icons.class_outlined, 'label': 'Scheduler', 'color': Colors.pink},
      {'icon': Icons.check_circle_outline, 'label': 'Attendance', 'color': Colors.lime},
      {'icon': Icons.person, 'label': 'Profile', 'color': Colors.teal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: () => onActionTap(action['label'].toString().toLowerCase()),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(fontSize: 12),
                        selectionColor:Colors.black,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewsFeedWidget extends StatelessWidget {
  const NewsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final news = [
      {'title': 'Mid-Semester Exams Announced', 'date': 'Oct 10', 'category': 'Academic'},
      {'title': 'New Cafeteria Opening Soon', 'date': 'Oct 8', 'category': 'Campus'},
      {'title': 'Guest Lecture on AI', 'date': 'Oct 5', 'category': 'Event'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Campus News',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        ...news.map((item) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.newspaper, color: AppTheme.primary),
            ),
            title: Text(item['title'] as String),
            subtitle: Text(item['date'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['category'] as String,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
