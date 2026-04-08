// File: lib/screens/id_card/id_card_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
// Uncomment below when you implement backend upload
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../l10n/config/theme.dart';
import '../services/profile_services.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  File? frontId;
  File? backId;

  final ImagePicker picker = ImagePicker();

  /// Pick image from camera
  Future<void> _pickImage(bool isFront) async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        if (isFront) {
          frontId = File(picked.path);
        } else {
          backId = File(picked.path);
        }
      });
    }
  }

  /// Upload IDs to backend (example, uncomment & implement backend)
  Future<void> _uploadIds() async {
    if (frontId == null || backId == null) return;

    final uri = Uri.parse("http://localhost:3000/");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'frontId',
      frontId!.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'backId',
      backId!.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("ID uploaded successfully"),
            backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Upload failed"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileService>(context).userProfile;

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text("No profile found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student ID Verification"),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Student Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Text(
                        "${profile.firstName[0]}${profile.lastName[0]}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${profile.firstName} ${profile.lastName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profile.program ?? "",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "ID: ${profile.studentId}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // FRONT ID
              _buildUploadCard(
                title: "Scan Front of ID",
                image: frontId,
                onTap: () => _pickImage(true),
              ),
              const SizedBox(height: 20),
              // BACK ID
              _buildUploadCard(
                title: "Scan Back of ID",
                image: backId,
                onTap: () => _pickImage(false),
              ),
              const SizedBox(height: 30),
              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (frontId == null || backId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Please upload both sides of the ID card"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Uncomment below to call backend upload
                    // _uploadIds();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("ID Uploaded Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Submit ID",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Upload card UI
  Widget _buildUploadCard({
    required String title,
    required File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 40),
                  const SizedBox(height: 10),
                  Text(title),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
