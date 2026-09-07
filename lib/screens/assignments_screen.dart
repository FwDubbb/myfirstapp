import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/assignment.dart';
import '../widgets/assignment_list.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key, required this.data, this.classId});

  final PlannerData data;
  final int? classId;

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  AssignmentFilter _filter = AssignmentFilter.all;

  @override
  Widget build(BuildContext context) {
    final assignments = widget.data.assignmentsFor(
      classId: widget.classId,
      filter: _filter,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assignments',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text('Sorted by due date, earliest first.'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final filter in AssignmentFilter.values)
                    ChoiceChip(
                      label: Text(switch (filter) {
                        AssignmentFilter.all => 'All',
                        AssignmentFilter.incomplete => 'Incomplete',
                        AssignmentFilter.completed => 'Completed',
                      }),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: AssignmentList(
            data: widget.data,
            assignments: assignments,
            emptyMessage: widget.data.classes.isEmpty
                ? 'Add a class first, then create an assignment.'
                : _filter == AssignmentFilter.all
                ? 'Tap Add assignment to plan your next task.'
                : 'No assignments match this filter. Try All to see every task.',
          ),
        ),
      ],
    );
  }
}
