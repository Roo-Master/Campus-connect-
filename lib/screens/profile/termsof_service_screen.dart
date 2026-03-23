import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Your Terms of Service content goes here.
            
Include rules, user obligations, disclaimers, and limitations of liability.''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}