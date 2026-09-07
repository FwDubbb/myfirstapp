import 'package:flutter/material.dart';

import '../data/planner_data.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key, required this.data});

  final PlannerData data;

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Color _color = Colors.indigo;

  static const _colors = {
    'Indigo': Colors.indigo,
    'Teal': Colors.teal,
    'Purple': Colors.deepPurple,
    'Orange': Colors.deepOrange,
    'Blue': Colors.blue,
    'Pink': Colors.pink,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.data.addClass(_nameController.text, color: _color);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add class')),
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
                    'Make room for a new subject',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Class name',
                      hintText: 'e.g. Biology',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a class name.'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Class color (optional)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text('Indigo is selected by default.'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in _colors.entries)
                        ChoiceChip(
                          avatar: Icon(
                            Icons.circle,
                            color: entry.value,
                            size: 18,
                          ),
                          label: Text(entry.key),
                          selected: _color == entry.value,
                          onSelected: (_) =>
                              setState(() => _color = entry.value),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('Save class'),
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
