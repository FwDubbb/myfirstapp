import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfirstapp/main.dart';

void main() {
  testWidgets('Create, filter, complete, and delete an assignment', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentPlannerApp());
    expect(find.text('0 completed assignments'), findsOneWidget);

    await tester.tap(find.text('Add class'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save class'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a class name.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Biology');
    await tester.tap(find.text('Teal'));
    await tester.tap(find.text('Save class'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add assignment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save assignment'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an assignment title.'), findsOneWidget);
    expect(find.text('Select a class.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Read chapter 3');
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biology').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save assignment'));
    await tester.pumpAndSettle();
    expect(find.text('Due today (1)'), findsOneWidget);

    await tester.tap(find.text('Classes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();
    expect(find.text('Read chapter 3'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Incomplete'));
    await tester.pumpAndSettle();
    expect(find.text('Read chapter 3'), findsNothing);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Read chapter 3'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('1 completed assignments'), findsOneWidget);
    expect(find.text('Due today (0)'), findsOneWidget);

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete Read chapter 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Read chapter 3'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete Read chapter 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Read chapter 3'), findsNothing);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('0 completed assignments'), findsOneWidget);
  });

  testWidgets('Forms fit a narrow phone and cancel without saving', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const StudentPlannerApp());
    await tester.tap(find.text('Add class'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'An unsaved class');
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Classes'));
    await tester.pumpAndSettle();
    expect(find.text('An unsaved class'), findsNothing);
    expect(find.text('Your semester starts here'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
