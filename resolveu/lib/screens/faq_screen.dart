import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        Card(
          child: ExpansionTile(
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
        ),
        SizedBox(height: 8),
        Card(
          child: ExpansionTile(
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
        ),
        SizedBox(height: 8),
        Card(
          child: ExpansionTile(
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
        ),
        SizedBox(height: 8),
        Card(
          child: ExpansionTile(
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
        ),
        SizedBox(height: 8),
        Card(
          child: ExpansionTile(
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
        ),
        SizedBox(height: 8),
        Card(
          child: ExpansionTile(
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
        ),
      ],
    );
  }
}
