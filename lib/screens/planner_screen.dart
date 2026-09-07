import 'package:flutter/material.dart';

import '../data/planner_data.dart';
import 'add_assignment_screen.dart';
import 'add_class_screen.dart';
import 'assignments_screen.dart';
import 'classes_screen.dart';
import 'home_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  // Create this once, not inside build(), which runs many times.
  final PlannerData _data = PlannerData();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _data,
      builder: (context, child) {
        final addClass = _selectedIndex == 1 || _data.classes.isEmpty;
        return Scaffold(
          appBar: AppBar(title: const Text('Student Planner')),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                // Keeps each tab's filter and scroll position when switching.
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    HomeScreen(data: _data),
                    ClassesScreen(data: _data),
                    AssignmentsScreen(data: _data),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => addClass
                      ? AddClassScreen(data: _data)
                      : AddAssignmentScreen(data: _data),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(addClass ? 'Add class' : 'Add assignment'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Classes',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Assignments',
              ),
            ],
          ),
        );
      },
    );
  }
}
