import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/rrule.dart';
// ITodo Class representing a to-do component in iCalendar
class ITodo extends ICalendarComponent {
  String uid;
  DateTime dtstamp;
  String summary;
  DateTime? due;
  String? description;
  String? status; // e.g., "NEEDS-ACTION", "COMPLETED", "IN-PROCESS"
  String? priority; // "1" is the highest priority, "9" is the lowest
  RecurrenceRule? rrule; // Optional recurrence rule
  List<DateTime>? exDates; // Optional exception dates for recurring tasks
  List<String>? attendees;
  String? organizer;
  String? contact;

  ITodo({
    required this.uid,
    required this.dtstamp,
    required this.summary,
    this.due,
    this.description,
    this.status,
    this.priority,
    this.rrule,
    this.exDates,
    this.attendees,
    this.organizer,
    this.contact,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VTODO\n');
    buffer.write('UID:$uid\n');
    buffer.write('DTSTAMP:${formatDateTime(dtstamp)}\n');
    buffer.write('SUMMARY:$summary\n');
    if (due != null) buffer.write('DUE:${formatDateTime(due!)}\n');
    if (description != null) buffer.write('DESCRIPTION:$description\n');
    if (status != null) buffer.write('STATUS:$status\n');
    if (priority != null) buffer.write('PRIORITY:$priority\n');
    if (rrule != null) buffer.write('RRULE:${rrule!.serialize()}\n');
    if (exDates != null) {
      for (var date in exDates!) {
        buffer.write('EXDATE:${formatDateTime(date)}\n');
      }
    }
    if (attendees != null) {
      for (var attendee in attendees!) {
        buffer.write('ATTENDEE:$attendee\n');
      }
    }
    if (organizer != null) buffer.write('ORGANIZER:$organizer\n');
    if (contact != null) buffer.write('CONTACT:$contact\n');
    buffer.write('END:VTODO');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'DTSTAMP': formatDateTime(dtstamp),
      'SUMMARY': summary,
      'DUE': due != null ? formatDateTime(due!) : null,
      'DESCRIPTION': description,
      'STATUS': status,
      'PRIORITY': priority,
      'RRULE': rrule?.toJson(),
      'EXDATE': exDates?.map((date) => formatDateTime(date)).toList(),
      'ATTENDEE': attendees,
      'ORGANIZER': organizer,
      'CONTACT': contact,
    };
  }

  // Parsing ITodo from .ics formatted string
  static ITodo parse(String itodoString) {
    final lines = itodoString.split('\n');
    String? uid;
    DateTime? dtstamp;
    String? summary;
    DateTime? due;
    String? description;
    String? status;
    String? priority;
    RecurrenceRule? rrule;
    List<DateTime>? exDates;
    List<String>? attendees;
    String? organizer;
    String? contact;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts[1];

      switch (key) {
        case 'UID':
          uid = value;
          break;
        case 'DTSTAMP':
          dtstamp = DateTime.parse(value.replaceAll('Z', ''));
          break;
        case 'SUMMARY':
          summary = value;
          break;
        case 'DUE':
          due = DateTime.parse(value.replaceAll('Z', ''));
          break;
        case 'DESCRIPTION':
          description = value;
          break;
        case 'STATUS':
          status = value;
          break;
        case 'PRIORITY':
          priority = value;
          break;
        case 'RRULE':
          rrule = RecurrenceRule.parse(value);
          break;
        case 'EXDATE':
          exDates ??= [];
          exDates.add(DateTime.parse(value.replaceAll('Z', '')));
          break;
        case 'ATTENDEE':
          attendees ??= [];
          attendees.add(value);
          break;
        case 'ORGANIZER':
          organizer = value;
          break;
        case 'CONTACT':
          contact = value;
          break;
      }
    }

    return ITodo(
      uid: uid ?? '',
      dtstamp: dtstamp ?? DateTime.now(),
      summary: summary ?? '',
      due: due,
      description: description,
      status: status,
      priority: priority,
      rrule: rrule,
      exDates: exDates,
      attendees: attendees,
      organizer: organizer,
      contact: contact,
    );
  }
}
