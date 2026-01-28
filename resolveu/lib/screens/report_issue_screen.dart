import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/issue.dart';
import '../services/firestore_service.dart';
import '../widgets/gradient_background.dart';

class ReportIssueScreen extends StatefulWidget {
  final Issue? issue;

  const ReportIssueScreen({super.key, this.issue});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService = FirestoreService();
  String _selectedCategory = 'General';
  String _selectedUrgency = 'Medium';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.issue != null) {
      _titleController.text = widget.issue!.title;
      _descriptionController.text = widget.issue!.description;
      _selectedCategory = widget.issue!.category;
      _selectedUrgency = widget.issue!.urgency;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitIssue() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to report or edit an issue.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.issue != null) {
          // Update existing issue
          final updatedIssue = Issue(
            id: widget.issue!.id,
            userId: widget.issue!.userId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _selectedCategory,
            urgency: _selectedUrgency,
            status: widget.issue!.status,
            timestamp: widget.issue!.timestamp,
            editedAt: DateTime.now(),
          );
          await _firestoreService.updateIssue(updatedIssue);
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Issue updated successfully!')),
            );
            Navigator.pop(context);
          }
        } else {
          // Create new issue
          final issue = Issue(
            id: const Uuid().v4(),
            userId: user.uid,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _selectedCategory,
            urgency: _selectedUrgency,
            status: 'Open',
            timestamp: DateTime.now(),
          );
          await _firestoreService.addIssue(issue);
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Issue reported successfully!')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.issue != null;
    return GradientBackground(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Issue' : 'Report an Issue', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          // Uses Theme elevation and shape
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        hintText: 'Brief summary of the issue',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.length < 5) {
                          return 'Title must be at least 5 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['General', 'Mess', 'Maintenance', 'Facilities', 'Other']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedUrgency,
                      decoration: const InputDecoration(
                        labelText: 'Urgency',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Low', 'Medium', 'High', 'Critical']
                          .map((urgency) => DropdownMenuItem(
                                value: urgency,
                                child: Text(urgency),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUrgency = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        hintText: 'Detailed description of the issue',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitIssue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary, // Ensure Primary used
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(isEditing ? 'Update Issue' : 'Submit Issue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
