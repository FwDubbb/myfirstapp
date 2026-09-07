enum Priority { low, medium, high }

extension PriorityLabel on Priority {
  String get label => switch (this) {
    Priority.low => 'Low',
    Priority.medium => 'Medium',
    Priority.high => 'High',
  };
}

enum AssignmentFilter { all, incomplete, completed }

class Assignment {
  Assignment({
    required this.id,
    required this.title,
    required this.classId,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  final int id;
  final String title;
  // An ID connects an assignment to its class, even if names are identical.
  final int classId;
  final DateTime dueDate;
  final Priority priority;
  bool isCompleted;
}
