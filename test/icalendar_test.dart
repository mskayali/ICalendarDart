import 'package:flutter_test/flutter_test.dart';
import 'package:icalendar/icalendar.dart';

void main() {
  group('ICalendar Integration Test', () {
    test('Create, serialize, and parse iCalendar with multiple components', () {
      // Create Calendar Headers
      final headers = CalHeaders(prodId: '-//My Company//My Product//EN');

      // Create ICalendar instance
      final calendar = ICalendar.instance(headers);

      // Create a VEvent
      final event = VEvent(
        uid: 'event1@example.com',
        dtstamp: DateTime.now(),
        dtstart: DateTime(2024, 10, 21, 10, 0),
        dtend: DateTime(2024, 10, 21, 11, 0),
        summary: 'Meeting with Team',
        description: 'Discuss project updates',
        location: 'Conference Room 1',
        status: 'CONFIRMED',
        attendees: ['mailto:john@example.com', 'mailto:jane@example.com'],
        organizer: 'mailto:organizer@example.com',
      );

      // Create a VTodo
      final todo = VTodo(
        uid: 'todo1@example.com',
        dtstamp: DateTime.now(),
        summary: 'Finish Documentation',
        due: DateTime(2024, 10, 22, 17, 0),
        description: 'Complete the API documentation.',
        status: 'IN-PROCESS',
        priority: '1',
      );

      // Add components to the calendar
      calendar.add(event);
      calendar.add(todo);

      // Serialize to iCalendar format
      final icsString = calendar.serialize();

      // Parse the serialized string back into an ICalendar object
      final parsedCalendar = ICalendar.parse(icsString);

      // Assert to check components and attributes
      expect(parsedCalendar.components.length, 2);
      expect(parsedCalendar.components[0].toJson()['SUMMARY'], 'Meeting with Team');
      expect(parsedCalendar.components[1].toJson()['SUMMARY'], 'Finish Documentation');
    });
  });
}
