import 'package:flutter/material.dart';

import '../models/assignment.dart';
import '../models/study_class.dart';

// One shared object owns the in-memory data. No database or extra package.
class PlannerData extends ChangeNotifier {
  final List<StudyClass> _classes = [];
  final List<Assignment> _assignments = [];
  int _nextId = 1;

  List<StudyClass> get classes => List.unmodifiable(_classes);
  List<Assignment> get assignments => List.unmodifiable(_assignments);

  int get completedCount =>
      _assignments.where((assignment) => assignment.isCompleted).length;

  StudyClass classFor(int classId) {
    return _classes.firstWhere((studyClass) => studyClass.id == classId);
  }

  void addClass(String name, {Color color = Colors.indigo}) {
    _classes.add(StudyClass(id: _nextId++, name: name.trim(), color: color));
    notifyListeners();
  }

  void addAssignment({
    required String title,
    required int classId,
    required DateTime dueDate,
    required Priority priority,
  }) {
    _assignments.add(
      Assignment(
        id: _nextId++,
        title: title.trim(),
        classId: classId,
        dueDate: dateOnly(dueDate),
        priority: priority,
      ),
    );
    notifyListeners();
  }

  void toggleCompleted(Assignment assignment) {
    assignment.isCompleted = !assignment.isCompleted;
    notifyListeners();
  }

  void deleteAssignment(Assignment assignment) {
    _assignments.remove(assignment);
    notifyListeners();
  }

  List<Assignment> assignmentsFor({
    int? classId,
    AssignmentFilter filter = AssignmentFilter.all,
  }) {
    final result = _assignments.where((assignment) {
      if (classId != null && assignment.classId != classId) return false;
      return switch (filter) {
        AssignmentFilter.all => true,
        AssignmentFilter.incomplete => !assignment.isCompleted,
        AssignmentFilter.completed => assignment.isCompleted,
      };
    }).toList();

    // Sort a new list so reading data never rearranges the stored list.
    result.sort((a, b) {
      final dateOrder = a.dueDate.compareTo(b.dueDate);
      return dateOrder == 0 ? a.id.compareTo(b.id) : dateOrder;
    });
    return result;
  }

  List<Assignment> dueToday(DateTime now) =>
      assignmentsFor(filter: AssignmentFilter.incomplete)
          .where((assignment) => assignment.dueDate == dateOnly(now))
          .toList();

  List<Assignment> upcoming(DateTime now) =>
      assignmentsFor(filter: AssignmentFilter.incomplete)
          .where((assignment) => assignment.dueDate.isAfter(dateOnly(now)))
          .toList();

  List<Assignment> overdue(DateTime now) =>
      assignmentsFor(filter: AssignmentFilter.incomplete)
          .where((assignment) => assignment.dueDate.isBefore(dateOnly(now)))
          .toList();
}

// Dates represent calendar days, so the time of day should not affect grouping.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
