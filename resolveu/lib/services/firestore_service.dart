import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/issue.dart';

class FirestoreService {
  final CollectionReference _issuesCollection =
      FirebaseFirestore.instance.collection('issues');

  Future<void> addIssue(Issue issue) async {
    try {
      await _issuesCollection.doc(issue.id).set(issue.toMap());
    } catch (e) {
      print('Error adding issue: $e');
      rethrow;
    }
  }
}
