import 'package:cloud_firestore/cloud_firestore.dart';

class CampusDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getCampusContext() async {
    String context = "";

    final events = await _db.collection('events').get();
    final services = await _db.collection('services').get();

    context += "Events:\n";
    for (var doc in events.docs) {
      context += "- ${doc['title']} on ${doc['date']}\n";
    }

    context += "\nServices:\n";
    for (var doc in services.docs) {
      context += "- ${doc['name']}: ${doc['hours']}\n";
    }

    return context;
  }
}
