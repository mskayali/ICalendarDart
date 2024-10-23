import 'dart:convert';

import 'package:icalendar_plus/icalendar.dart';
import 'package:test/test.dart';

void main() {

  late ICalendar calendar;
  late String output1;
  late String output2;
  test('initilize the calendar', () {
    // Create Calendar Headers
    final headers = CalHeaders(
      prodId: '-//Your Organization//Your Product//EN',
      version: '2.0',
      calScale: 'GREGORIAN',
    );

    // Create ICalendar instance
    calendar = ICalendar.instance(headers);
    expect(calendar.runtimeType, equals(ICalendar));
  });

  test('createing events', (){
    final event = VEvent(
        uid: 'event123@example.com',
        dtstamp: DateTime.now(),
        dtstart: DateTime.now().add(const Duration(days: 2)),
        dtend: DateTime.now().add(const Duration(days: 2, hours: 1)),
        summary: 'Team Meeting',
        description: 'Weekly sync-up meeting with the project team.',
        location: 'Zoom',
        attendees: [Attendee(mailto: MailTo('member1@example.com')), Attendee(mailto: MailTo('member2@example.com'))],
        organizer: MailTo('manager@example.com'));

    // Create a VAlarm for the event
    final alarm1 = VAlarm(
      action: VAlarmAction.display,
      trigger: TrrigerDuration(-Duration(seconds: 10, minutes: 5, hours: 1, days: 1)), // or use as Trrig.parse('-PT15M') to create 15 minutes before the event
      description: 'Reminder: Team Meeting in 15 minutes.',
    );
    final alarm2 = VAlarm(
      action: VAlarmAction.audio,
      trigger: TrrigerDate(event.dtstart), // on time of the event by exect date
      description: 'Event begins',
    );
    final alarm3 = VAlarm(
      action: VAlarmAction.audio,
      trigger: Trriger.parse('-PT15M'), // on time of the event by exect date
      description: 'Event begins',
    );
    // Add components to the calendar
    calendar.add(event);
    calendar.addAll([alarm1, alarm2, alarm3]);
    expect(calendar.components.length, equals(4));
  });

  test('compare the results', () {
    // Serialize the calendar to an iCalendar string
    final icsContent = calendar.serialize();
    print('Generated iCalendar Content:');
    print(icsContent);
    output1 = jsonEncode(calendar.toJson());
    print(output1);
    // Parse back from the serialized string
    final parsedCalendar = ICalendar.parse(icsContent);
    // Print parsed Calendar to demonstrate parsing
    print('\nParsed Calendar:');
    output2 = jsonEncode(parsedCalendar.toJson());
    print(output2);
    expect(output1.length, equals(output2.length));
  });

}
