import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import '../models/assignment.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({
    super.key,
    required this.data,
    this.initialClassId,
  });

  final PlannerData data;
  final int? initialClassId;

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  int? _classId;
  DateTime _dueDate = dateOnly(DateTime.now());
  Priority _priority = Priority.medium;

  @override
  void initState() {
    super.initState();
    _classId = widget.initialClassId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    // The user could leave this screen while an asynchronous operation runs.
    if (!mounted || selected == null) return;
    setState(() => _dueDate = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.data.addAssignment(
      title: _titleController.text,
      classId: _classId!,
      dueDate: _dueDate,
      priority: _priority,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add assignment')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Plan your next task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: 'Assignment title',
                      hintText: 'e.g. Read chapter 3',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter an assignment title.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _classId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Class'),
                    items: [
                      for (final studyClass in widget.data.classes)
                        DropdownMenuItem(
                          value: studyClass.id,
                          child: Text(
                            studyClass.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) => setState(() => _classId = value),
                    validator: (value) =>
                        value == null ? 'Select a class.' : null,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _chooseDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      'Due date: ${MaterialLocalizations.of(context).formatMediumDate(_dueDate)}',
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<Priority>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      for (final priority in Priority.values)
                        DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _priority = value);
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('Save assignment'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
