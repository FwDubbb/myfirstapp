import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/assignment.dart';
import '../widgets/empty_state.dart';
import 'class_detail_screen.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key, required this.data});

  final PlannerData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Your classes', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text('Keep every subject and its assignments together.'),
        const SizedBox(height: 20),
        if (data.classes.isEmpty)
          const EmptyState(
            icon: Icons.school_outlined,
            title: 'Your semester starts here',
            message: 'Tap Add class to create your first subject.',
          ),
        for (final studyClass in data.classes)
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: studyClass.color,
                child: const Icon(Icons.school_outlined, color: Colors.white),
              ),
              title: Text(studyClass.name),
              subtitle: Text(
                '${data.assignmentsFor(classId: studyClass.id, filter: AssignmentFilter.incomplete).length} incomplete assignments',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        ClassDetailScreen(data: data, studyClass: studyClass),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
