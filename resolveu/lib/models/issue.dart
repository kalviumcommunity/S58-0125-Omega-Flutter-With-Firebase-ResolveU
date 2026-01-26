class Issue {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String urgency;
  final String status;
  final DateTime timestamp;
  final DateTime? editedAt;

  Issue({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.status,
    required this.timestamp,
    this.editedAt,
  });

  factory Issue.fromMap(Map<String, dynamic> map, String id) {
    return Issue(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      urgency: map['urgency'] ?? '',
      status: map['status'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      editedAt: map['editedAt'] != null ? DateTime.parse(map['editedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'urgency': urgency,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      if (editedAt != null) 'editedAt': editedAt!.toIso8601String(),
    };
  }
}
