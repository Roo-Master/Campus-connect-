import 'package:flutter/material.dart';
import '../../models/event_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  final GlobalKey<FormState> final_formKey = GlobalKey<FormState>();

  String eventName = '';
  String description = '';
  String category = 'Academic';
  String location = '';
  String building = '';
  String organizer = '';
  String organizerContact = '';
  int capacity = 100;

  DateTime eventDate = DateTime.now();

  bool isLoading = false;

  final List<String> categories = [
    'Academic',
    'Career',
    'Cultural',
    'Sports',
    'Social'
  ];

  Future<void> _selectEventDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        eventDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {

    if (!final_formKey.currentState!.validate()) return;

    final_formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: eventName,
      description: description,
      category: category,
      date: "${eventDate.day}-${eventDate.month}-${eventDate.year}",
      startTime: "10:00 AM",
      endTime: "12:00 PM",
      location: location,
      building: building,
      organizer: organizer,
      organizerContact: organizerContact,
      capacity: capacity,
      registeredCount: 0,
      imageUrl: "",
      color: Colors.blue,
      isMandatory: false,
      tags: ["Campus Event"],
    );

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context, newEvent);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Create Event'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: final_formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter event title' : null,
                  onSaved: (value) => eventName = value!,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => description = value ?? '',
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => location = value ?? '',
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Building',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => building = value ?? '',
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Organizer',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => organizer = value ?? '',
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Organizer Contact',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => organizerContact = value ?? '',
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                  capacity = int.tryParse(value ?? "100") ?? 100,
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: () => _selectEventDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 10),
                        Text(
                          "Date: ${eventDate.day}-${eventDate.month}-${eventDate.year}",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Create Event"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}