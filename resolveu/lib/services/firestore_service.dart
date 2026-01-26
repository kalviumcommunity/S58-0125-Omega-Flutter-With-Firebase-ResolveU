import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/issue.dart';

class FirestoreService {
  final CollectionReference _issuesCollection =
      FirebaseFirestore.instance.collection('issues');

  Future<void> addIssue(Issue issue) async {
    try {
      await _issuesCollection.doc(issue.id).set(issue.toMap());
    } catch (e) {
      debugPrint('Error adding issue: $e');
      rethrow;
    }
  }

  Future<void> updateIssue(Issue issue) async {
    try {
      await _issuesCollection.doc(issue.id).update(issue.toMap());
    } catch (e) {
      debugPrint('Error updating issue: $e');
      rethrow;
    }
  }

  Stream<List<Issue>> getIssuesByUserId(String userId) {
    return _issuesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> deleteIssue(String issueId) async {
    try {
      await _issuesCollection.doc(issueId).delete();
    } catch (e) {
      debugPrint('Error deleting issue: $e');
      rethrow;
    }
  }
}
