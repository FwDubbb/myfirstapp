import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/study_class.dart';
import 'add_assignment_screen.dart';
import 'assignments_screen.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({
    super.key,
    required this.data,
    required this.studyClass,
  });

  final PlannerData data;
  final StudyClass studyClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(studyClass.name)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            // A pushed route also listens so completing a task updates it.
            child: ListenableBuilder(
              listenable: data,
              builder: (context, child) =>
                  AssignmentsScreen(data: data, classId: studyClass.id),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => AddAssignmentScreen(
                data: data,
                initialClassId: studyClass.id,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add assignment'),
      ),
    );
  }
}
