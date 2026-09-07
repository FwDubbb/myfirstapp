import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/assignment.dart';
import 'assignment_tile.dart';
import 'empty_state.dart';

class AssignmentList extends StatelessWidget {
  const AssignmentList({
    super.key,
    required this.data,
    required this.assignments,
    this.emptyMessage = 'Add an assignment to start planning your work.',
  });

  final PlannerData data;
  final List<Assignment> assignments;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return ListView(
        children: [
          EmptyState(
            icon: Icons.assignment_outlined,
            title: 'No assignments here',
            message: emptyMessage,
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return AssignmentTile(
          key: ValueKey(assignment.id),
          assignment: assignment,
          studyClass: data.classFor(assignment.classId),
          onToggle: () => data.toggleCompleted(assignment),
          onDelete: () => data.deleteAssignment(assignment),
        );
      },
    );
  }
}
