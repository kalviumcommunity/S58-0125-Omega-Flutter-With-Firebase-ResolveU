import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don't need an AppBar here if the main HomePage has one or if we want a clean look.
      // However, usually inner screens might want one. 
      // Given the persistent bottom nav, the AppBar typically stays or changes title.
      // Let's rely on the HomePage's scaffold to provide the body, 
      // but if we want a distinct header for FAQ, we can add it here or in the body.
      // The prompt says "Persistent bottom navigation pattern so the navigation bar remains visible".
      // Usually this means the AppBar also changes or stays.
      // Let's implement just the body content here.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
           Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ExpansionTile(
            title: Text('How do I report a maintenance issue?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'To report an issue, tap the "Report Issue" button in the center of the bottom navigation bar. Fill in the details and submit.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('What are the hostel quiet hours?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Quiet hours are from 10:00 PM to 7:00 AM daily. Please keep noise levels down during this time.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I check the status of my complaint?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You can check the status of your complaints in the "My Complaints" section, accessible from the profile menu.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('What should I do in an emergency?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'In case of an emergency, please contact the hostel warden immediately or call the emergency helpline provided at the front desk.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Can I request a room change?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Room change requests must be submitted to the administration office in person. They are subject to availability and approval.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I reset my password?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'If you forgot your password, please contact the IT support or system administrator to request a password reset.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
