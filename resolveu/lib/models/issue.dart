class Issue {
  final String id;
  final String title;
  final String description;
  final String category;
  final String urgency;
  final String status;
  final DateTime timestamp;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.status,
    required this.timestamp,
  });

  factory Issue.fromMap(Map<String, dynamic> map, String id) {
    return Issue(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      urgency: map['urgency'] ?? '',
      status: map['status'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'urgency': urgency,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
