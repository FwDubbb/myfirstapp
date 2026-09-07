import 'package:flutter/material.dart';

import '../models/assignment.dart';
import '../models/study_class.dart';

class AssignmentTile extends StatelessWidget {
  const AssignmentTile({
    super.key,
    required this.assignment,
    required this.studyClass,
    required this.onToggle,
    required this.onDelete,
  });

  final Assignment assignment;
  final StudyClass studyClass;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dueDate = MaterialLocalizations.of(context)
        .formatMediumDate(assignment.dueDate);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: assignment.isCompleted,
              semanticLabel: 'Complete ${assignment.title}',
              onChanged: (_) => onToggle(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: studyClass.color),
                      const SizedBox(width: 6),
                      Expanded(child: Text(studyClass.name)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Due $dueDate • ${assignment.priority.label} priority'),
                  if (assignment.isCompleted)
                    const Text(
                      'Completed',
                      style: TextStyle(color: Colors.teal),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete ${assignment.title}',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete assignment?'),
                    content: Text(
                      'Remove “${assignment.title}” from your planner?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
