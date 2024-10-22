import 'package:icalendar_plus/icalendar.dart';

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
    status: EVENTStatus.confirmed,
    attendees: [Attendee(mailto:MailTo('member1@example.com')), Attendee(mailto:MailTo('member2@example.com'), cutype: Cutype.individual)],
    organizer: MailTo.parse('mailto:manager@example.com'),
  );

  // Create a VAlarm for the event
  final alarm = VAlarm(
    action: VAlarmAction.display,
    trigger: RelativeTime.parse('-PT15M'), // 15 minutes before the event
    description: 'Reminder: Team Meeting in 15 minutes.',
  );

  // Create a VTodo
  final todo = VTodo(
    uid: 'todo456@example.com',
    dtstamp: DateTime.now(),
    summary: 'Prepare Presentation',
    due: DateTime(2024, 11, 1, 12, 0),
    description: 'Create slides for the quarterly review.',
    status: TODOStatus.needsAction,
    priority: '1',
  );

  // Create a VFreeBusy
  final freeBusy = VFreeBusy(
    uid: 'freebusy789@example.com',
    dtstamp: DateTime.now(),
    dtstart: DateTime(2024, 11, 1, 8, 0),
    dtend: DateTime(2024, 11, 1, 18, 0),
    freeTimes: [DateRangeUtil.parse('20241101T080000Z/20241101T090000Z')],
    busyTimes: [DateRangeUtil.parse('20241101T100000Z/20241101T110000Z')],
  );

  // Add components to the calendar
  calendar.add(event);
  calendar.add(alarm);
  calendar.add(todo);
  calendar.add(freeBusy);

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
