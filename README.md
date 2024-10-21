
# iCalendar Dart Plugin

This Dart plugin provides a comprehensive set of classes to create, manage, serialize, and parse iCalendar components. It supports creating events, to-dos, journals, alarms, free/busy times, timezones, and more. The plugin adheres to the iCalendar (`.ics`) format, making it easy to integrate with calendar applications.

## Features

- **Basic Calendar Object**: Create and manage iCalendar objects.
- **Event (`VEVENT`)**: Define and handle events with support for recurrence rules, exceptions, attendees, and more.
- **To-Do (`VTODO`)**: Manage tasks with priorities, due dates, and recurrence.
- **Journal (`VJOURNAL`)**: Create journal entries for diary-like notes.
- **Alarm (`VALARM`)**: Set alarms for reminders with different actions (e.g., display, email).
- **Free/Busy Times (`VFREEBUSY`)**: Define availability and busy slots.
- **Timezones (`VTIMEZONE`)**: Manage time zone information for events.
- **Recurrence Rules (`RRULE`)**: Configure recurring patterns for events and tasks.
- **Attachments**: Attach files, sounds, or documents to events and alarms.
- **Participants (`ATTENDEE`, `CONTACT`, `ORGANIZER`)**: Handle contacts, attendees, and event organizers.

## Getting Started

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  icalendar: ^1.0.0
```

Run `pub get` to install the package.

### Import the Package

```dart
import 'package:icalendar/icalendar.dart';
```

## Usage

### Example: Create and Serialize iCalendar

```dart
import 'package:icalendar/icalendar.dart';

void main() {
  // Create Calendar Headers
  final headers = CalHeaders(
    prodId: '-//Your Organization//Your Product//EN',
    version: '2.0',
    calScale: 'GREGORIAN',
  );

  // Create ICalendar instance
  final calendar = ICalendar.instance(headers);

  // Create a VEvent
  final event = VEvent(
    uid: 'event123@example.com',
    dtstamp: DateTime.now(),
    dtstart: DateTime(2024, 11, 1, 9, 30),
    dtend: DateTime(2024, 11, 1, 10, 30),
    summary: 'Team Meeting',
    description: 'Weekly sync-up meeting with the project team.',
    location: 'Zoom',
    status: 'CONFIRMED',
    attendees: ['mailto:member1@example.com', 'mailto:member2@example.com'],
    organizer: 'mailto:manager@example.com',
  );

  // Create a VAlarm for the event
  final alarm = VAlarm(
    action: 'DISPLAY',
    trigger: '-PT15M', // 15 minutes before the event
    description: 'Reminder: Team Meeting in 15 minutes.',
  );

  // Add components to the calendar
  calendar.add(event);
  calendar.add(alarm);

  // Serialize the calendar to an iCalendar string
  final icsContent = calendar.serialize();
  print('Generated iCalendar Content:');
  print(icsContent);

  // Parse back from the serialized string
  final parsedCalendar = ICalendar.parse(icsContent);

  // Print parsed components to demonstrate parsing
  print('\nParsed Components:');
  parsedCalendar.components.forEach((component) {
    print(component.toJson());
  });
}
```

### Output

The above example will produce an iCalendar `.ics` format string with an event and an alarm, and then demonstrate how to parse it back.

## Integration Tests

To ensure the plugin works as expected, run the integration tests:

1. Create a test file: `test/icalendar_integration_test.dart`
2. Use the example below:

```dart
import 'package:test/test.dart';
import 'package:icalendar/icalendar.dart';

void main() {
  group('ICalendar Integration Test', () {
    test('Create, serialize, and parse iCalendar with multiple components', () {
      // Setup headers, events, todos, and other components as shown in the usage example.
      // Assert the integrity of the parsed components.
    });
  });
}
```

Run the test using:

```bash
dart test test/icalendar_integration_test.dart
```

## Components Overview

### `ICalendar`

The main class to create and manage iCalendar components. Supports adding, serializing, and parsing multiple calendar items.

### `VEvent`

Used to define events with start/end times, recurrence rules, attendees, and more.

### `VTodo`

Manages tasks with support for due dates, priority, recurrence, and alarms.

### `VJournal`

For creating diary-like entries to record notes or logs.

### `VAlarm`

Set reminders or alarms for events or tasks with different actions (display, email, sound).

### `VFreeBusy`

Define periods when you're free or busy, useful for scheduling and availability.

### `VTimezone`

Manage time zone information and specify offsets for standard and daylight saving time.

### `RecurrenceRule`

Configure recurring patterns for events and tasks (e.g., daily, weekly).

### `VParticipant`

Represents attendees, contacts, and organizers, managing emails, roles, and names.

### `VAttachment`

Attach documents, images, or sounds to events or alarms.

### `ExDate`

Specify exception dates for recurring events or tasks, allowing you to skip specific occurrences.

## License

This plugin is open-sourced under the MIT License.

## Contributions

Contributions are welcome! Feel free to submit issues, pull requests, and feature requests. Make sure to include tests for any new features or bug fixes.

---

This `README.md` covers:
- **Overview**: What the plugin offers.
- **Installation**: How to get started with the plugin.
- **Usage Examples**: Demonstrates the core functionality.
- **Integration Testing**: Instructions on how to run tests.
- **Component Descriptions**: Describes each main class.
- **Contribution & License**: Guidelines for contributing.

This will give users a comprehensive understanding of how to use your plugin and get started quickly.