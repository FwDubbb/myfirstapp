# Student Planner

A beginner-friendly Flutter app using Material 3 and in-memory data. No new
packages, accounts, network calls, or persistence are required. Restarting the
app (including hot restart or refreshing the web page) clears all classes and
assignments. Hot reload normally keeps the current data.

## Run the app

From this project folder, run:

```sh
flutter pub get
flutter devices
flutter run
```

Choose a listed device when prompted, or use `flutter run -d chrome` for web.
For Android, start an emulator or connect a device with USB debugging enabled.
While `flutter run` is active, press `r` for hot reload, `R` for hot restart,
or `q` to quit. In VS Code, select a device and press F5 as an alternative.

## What the app does

- Home shows incomplete assignments due today, future assignments ordered by
  due date, overdue assignments, and the current number of completed assignments.
- Classes lets you create a named class with an optional color (default: indigo).
  Tap a class to see only its assignments. Adding from that page preselects it.
- Assignments lets you create a title, select a class, choose a calendar date,
  and select Low, Medium, or High priority. Today and Medium are the defaults.
- Use All, Incomplete, and Completed to filter the list. All lists are ordered
  by due date, earliest first. A checkbox toggles completion in either direction.
- The trash button asks before deleting. Cancel keeps the assignment.

Create a class first: the main add button shows **Add class** until one exists.
Past dates are allowed so you can enter existing overdue work. Date selection
covers five years before the current year through ten years after it. Dashboard
date groups are recalculated when the screen rebuilds; this version has no
background midnight timer.

## Folder guide and suggested reading order

```text
lib/
  main.dart                       App entry point and Material theme
  models/
    study_class.dart              A class's ID, name, and color
    assignment.dart               Assignment fields and priority/filter enums
  data/
    planner_data.dart             Shared lists and operations on them
  screens/
    planner_screen.dart           Owns data and the three-tab navigation
    home_screen.dart              Summary and date-based groups
    classes_screen.dart           Class cards
    assignments_screen.dart       Filter controls and assignment list
    class_detail_screen.dart      Assignments for one class
    add_class_screen.dart         Class form
    add_assignment_screen.dart    Assignment form and date picker
  widgets/
    assignment_tile.dart          Reusable task card
    assignment_list.dart          Scrollable cards or an empty message
    empty_state.dart              Reusable empty-list guidance
test/
  planner_data_test.dart           Data behavior tests
  widget_test.dart                 UI interaction tests
```

Read `main.dart`, the models, and `planner_data.dart` first. Then follow
`planner_screen.dart` into the individual screens. Each form is a useful place
to learn about local state and input validation.

## Flutter concepts used here

**Widgets** describe pieces of the interface. `Scaffold` provides the page
structure, `AppBar` the title bar, and `Card`, `Text`, and buttons fill the page.
Small custom widgets let several screens display assignments consistently.

**StatelessWidget and StatefulWidget:** a stateless widget displays values it is
given. It can still rebuild when its parent supplies updated data. A stateful
widget also remembers changing local values, such as the selected filter or
date. Calling `setState` tells Flutter to rebuild that widget with those values.
`build()` describes the UI; avoid creating your long-lived data inside it.

**Shared state with ChangeNotifier:** `PlannerData` is a single object created
by `PlannerScreen` and passed through constructors. After a data change,
`notifyListeners()` tells the surrounding `ListenableBuilder` to rebuild.
This keeps Home counts and assignment lists in sync without an external state
management package. Local form choices use `setState`; shared lists use the
notifier. `IndexedStack` keeps the tabs alive so switching tabs preserves filters.

For example, checking a task calls the card's `onToggle` callback, which calls
`data.toggleCompleted(assignment)`. That changes the boolean, notifies listeners,
and rebuilds the displayed lists and counts. A callback is simply a function
passed to another widget so it can report an action.

**Models and enums:** model classes describe data, separate from how it looks.
An assignment stores its class's ID to connect the two records. An `enum` limits
a value to named choices, such as `Priority.low`, `medium`, or `high`.
The `PriorityLabel` extension adds a readable `label` to those choices. A switch
expression picks the matching label or filtering rule.

**Forms:** a `Form` groups inputs. Its `GlobalKey<FormState>` lets the Save button
call `validate()` on those inputs. A validator returns an error message for bad
input, or `null` when valid. `TextEditingController` reads entered text. Blank or
whitespace-only titles/names and missing class selections cannot be saved.

**Navigation:** `Navigator.push` opens a page using `MaterialPageRoute`.
`Navigator.pop` closes it after saving or cancelling. The bottom `NavigationBar`
changes which main tab is visible. The same shared data object is passed to
each new route, so navigating does not reset your work.

**Asynchronous dialogs:** `showDatePicker` and `showDialog` return a `Future`,
which is a result that arrives later. `await` waits for the user's choice without
freezing the app. The date picker checks `mounted` before `setState` to confirm
its screen still exists.


**Layout:** `Row` lays out children horizontally and `Column` vertically.
`Expanded` gives a child the available space. `ListView` provides scrolling,
including on forms when the keyboard takes up room. `Wrap` lets filters and
color choices flow to another line on narrow screens. `ConstrainedBox` keeps
content from becoming too wide on desktop. `SafeArea` avoids device cutouts.

**Cleanup:** `dispose()` releases controllers and the shared notifier when their
owner leaves the widget tree. Fields starting with `_` are private to their Dart
library. `final` means a variable cannot be reassigned; `const` creates a
compile-time constant. Neither replaces state management.

**Date filtering:** dates are stored without a time component. Today means the
same calendar day; upcoming means later; overdue means earlier. Completed work
is excluded from those groups. Filtering uses `where`, then `toList` creates a
separate list to sort without rearranging the original stored list.

## Test it yourself

```sh
flutter analyze
flutter test
```

The automated tests cover required fields, class creation and color selection,
assignment creation, class navigation, completion, filters, cancelling and
confirming deletion, narrow-screen cancellation, notification updates, and date
grouping/sorting across a year boundary.

For a manual check:

1. Create Biology with Teal and Math with the default color.
2. Add one assignment due yesterday, one today, and two future assignments in
   reverse date order. Try different priorities and classes.
3. Check the Home groups and verify future assignments appear earliest first.
4. Open each class and confirm it only shows that class's work. Add an assignment
   there and verify that class is already selected in the form.
5. Complete a task, check the Home count, then try all three filters. Uncheck the
   completed task and confirm it returns to Incomplete.
6. Delete a task: first cancel, then confirm. Verify the task and count update.
7. Try an empty name/title or missing class, cancel the date picker, and use a
   narrow window or phone to check scrolling with the keyboard open.
8. Hot restart and confirm the app returns to an empty planner.
