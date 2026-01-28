import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/issue.dart';
import '../services/firestore_service.dart';
import 'report_issue_screen.dart';
import '../widgets/gradient_background.dart';

enum SortOption {
  newestFirst,
  oldestFirst,
  urgencyHighToLow,
  urgencyLowToHigh,
}

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  SortOption _currentSortOption = SortOption.newestFirst;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Complaints')),
        body: const Center(child: Text('Please log in to view your complaints')),
      );
    }

    final firestoreService = FirestoreService();

    return GradientBackground(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Complaints', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Let gradient show or use Theme
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Options',
            onSelected: (SortOption result) {
              setState(() {
                _currentSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.newestFirst,
                child: Text('Newest First'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.oldestFirst,
                child: Text('Oldest First'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<SortOption>(
                value: SortOption.urgencyHighToLow,
                child: Text('Urgency: High to Low'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.urgencyLowToHigh,
                child: Text('Urgency: Low to High'),
              ),
            ],
          ),
        ],
      ),
      child: StreamBuilder<List<Issue>>(
        stream: firestoreService.getIssuesByUserId(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Issue> issues = snapshot.data ?? [];

          if (issues.isEmpty) {
            return _buildEmptyState(context);
          }

          // Apply Client-side Sorting
          issues.sort((a, b) {
            switch (_currentSortOption) {
              case SortOption.newestFirst:
                return b.timestamp.compareTo(a.timestamp);
              case SortOption.oldestFirst:
                return a.timestamp.compareTo(b.timestamp);
              case SortOption.urgencyHighToLow:
                return _compareUrgency(b.urgency, a.urgency); // Higher urgency first
              case SortOption.urgencyLowToHigh:
                return _compareUrgency(a.urgency, b.urgency); // Lower urgency first
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: issues.length,
            itemBuilder: (context, index) {
              return _buildIssueCard(context, issues[index]);
            },
          );
        },
      ),
    );
  }

  int _compareUrgency(String urgencyA, String urgencyB) {
    final urgencyLevel = {
      'Critical': 3,
      'High': 2,
      'Medium': 1,
      'Low': 0,
    };

    int levelA = urgencyLevel[urgencyA] ?? -1;
    int levelB = urgencyLevel[urgencyB] ?? -1;

    return levelA.compareTo(levelB);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No complaints filed yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Issues you report will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, Issue issue) {
    return Card(
      // Elevation from Theme
      margin: const EdgeInsets.only(bottom: 12),
      // Shape from Theme
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportIssueScreen(issue: issue),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      issue.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(issue.status),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, issue.id),
                    tooltip: 'Delete Complaint',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                issue.description,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildInfoChip(context, issue.category, Colors.blue),
                        const SizedBox(width: 8),
                        _buildInfoChip(context, issue.urgency, _getUrgencyColor(issue.urgency)),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, h:mm a').format(issue.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              if (issue.editedAt != null) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Edited at ${DateFormat('MMM d, h:mm a').format(issue.editedAt!)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[400], fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String issueId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Complaint'),
        content: const Text('Are you sure you want to permanently delete this complaint? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirestoreService().deleteIssue(issueId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complaint deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting complaint: $e')),
          );
        }
      }
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Resolved':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.blue;
        break;
      case 'Open':
      case 'Pending':
      default:
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'High':
      case 'Critical':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
