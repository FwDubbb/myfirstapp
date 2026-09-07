import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/assignment.dart';
import '../widgets/assignment_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.data});

  final PlannerData data;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = data.dueToday(now);
    final upcoming = data.upcoming(now);
    final overdue = data.overdue(now);
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text(
          'Your study day',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        const Text('A little planning makes room for progress.'),
        const SizedBox(height: 20),
        Card(
          color: colors.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.task_alt),
                const SizedBox(height: 8),
                Text(
                  '${data.completedCount} completed assignments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text('${today.length} due today • ${upcoming.length} upcoming'),
              ],
            ),
          ),
        ),
        if (data.classes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Welcome! Add your first class, then add an assignment.',
            ),
          ),
        if (overdue.isNotEmpty)
          _AssignmentSection(
            title: 'Overdue',
            assignments: overdue,
            data: data,
          ),
        _AssignmentSection(
          title: 'Due today',
          assignments: today,
          data: data,
          emptyMessage: 'Nothing due today. You have room to plan ahead.',
        ),
        _AssignmentSection(
          title: 'Upcoming',
          assignments: upcoming,
          data: data,
          emptyMessage: 'No upcoming assignments. Add one when you are ready.',
        ),
      ],
    );
  }
}

// This widget is only used on Home, so it stays in this file.
class _AssignmentSection extends StatelessWidget {
  const _AssignmentSection({
    required this.title,
    required this.assignments,
    required this.data,
    this.emptyMessage = '',
  });

  final String title;
  final List<Assignment> assignments;
  final PlannerData data;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          '$title (${assignments.length})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (assignments.isEmpty) Text(emptyMessage),
        for (final assignment in assignments)
          AssignmentTile(
            key: ValueKey(assignment.id),
            assignment: assignment,
            studyClass: data.classFor(assignment.classId),
            onToggle: () => data.toggleCompleted(assignment),
            onDelete: () => data.deleteAssignment(assignment),
          ),
      ],
    );
  }
}
