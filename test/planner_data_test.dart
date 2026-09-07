import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfirstapp/data/planner_data.dart';
import 'package:myfirstapp/models/assignment.dart';

void main() {
  late PlannerData data;

  setUp(() {
    data = PlannerData();
    data.addClass('Biology', color: Colors.teal);
    data.addClass('Math');
  });

  tearDown(() => data.dispose());

  test(
    'Groups calendar days and sorts upcoming work across a year boundary',
    () {
      final now = DateTime(2026, 12, 31, 23, 59);
      final dates = [
        DateTime(2027, 1, 3),
        DateTime(2026, 12, 30),
        DateTime(2027, 1, 1),
        DateTime(2026, 12, 31, 8, 30),
      ];
      for (var i = 0; i < dates.length; i++) {
        data.addAssignment(
          title: 'Task $i',
          classId: data.classes.first.id,
          dueDate: dates[i],
          priority: Priority.medium,
        );
      }
      expect(data.dueToday(now).single.title, 'Task 3');
      expect(data.overdue(now).single.title, 'Task 1');
      expect(data.upcoming(now).map((a) => a.title), ['Task 2', 'Task 0']);
      data.toggleCompleted(data.dueToday(now).single);
      data.toggleCompleted(data.upcoming(now).first);
      data.toggleCompleted(data.overdue(now).single);
      expect(data.dueToday(now), isEmpty);
      expect(data.overdue(now), isEmpty);
      expect(data.upcoming(now).single.title, 'Task 0');
      expect(data.completedCount, 3);
    },
  );

  test('Class filtering, completion reversal, deletion, and notifications', () {
    var notifications = 0;
    data.addListener(() => notifications++);
    for (final studyClass in data.classes) {
      data.addAssignment(
        title: '  Homework  ',
        classId: studyClass.id,
        dueDate: DateTime(2026, 9, 10),
        priority: Priority.high,
      );
    }
    final assignment = data.assignments.first;
    expect(assignment.title, 'Homework');
    expect(data.classFor(assignment.classId).color, Colors.teal);
    expect(data.assignmentsFor(classId: data.classes.last.id).length, 1);
    data.toggleCompleted(assignment);
    expect(data.assignmentsFor(filter: AssignmentFilter.completed), [
      assignment,
    ]);
    expect(data.assignmentsFor(filter: AssignmentFilter.incomplete).length, 1);
    expect(
      data.assignmentsFor(
        classId: data.classes.last.id,
        filter: AssignmentFilter.completed,
      ),
      isEmpty,
    );
    data.toggleCompleted(assignment);
    expect(data.completedCount, 0);
    data.deleteAssignment(assignment);
    expect(data.assignments, hasLength(1));
    expect(data.assignmentsFor(classId: data.classes.first.id), isEmpty);
    expect(notifications, 5);
  });
}
