import 'package:icalendar_plus/components/icalendar_component.dart';
// VJournal Class representing a journal entry in iCalendar
class VJournal extends ICalendarComponent {
  String uid;
  DateTime dtstamp;
  String summary;
  String? description;
  String? status;
  List<String>? attendees;
  String? organizer;
  String? contact;

  VJournal({
    required this.uid,
    required this.dtstamp,
    required this.summary,
    this.description,
    this.status,
    this.attendees,
    this.organizer,
    this.contact,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VJOURNAL\n');
    buffer.write('UID:$uid\n');
    buffer.write('DTSTAMP:${formatDateTime(dtstamp)}\n');
    buffer.write('SUMMARY:$summary\n');
    if (description != null) buffer.write('DESCRIPTION:$description\n');
    if (status != null) buffer.write('STATUS:$status\n');
    if (attendees != null) {
      for (var attendee in attendees!) {
        buffer.write('ATTENDEE:$attendee\n');
      }
    }
    if (organizer != null) buffer.write('ORGANIZER:$organizer\n');
    if (contact != null) buffer.write('CONTACT:$contact\n');
    buffer.write('END:VJOURNAL');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'DTSTAMP': formatDateTime(dtstamp),
      'SUMMARY': summary,
      'DESCRIPTION': description,
      'STATUS': status,
      'ATTENDEE': attendees,
      'ORGANIZER': organizer,
      'CONTACT': contact,
    };
  }

  // Parsing VJournal from .ics formatted string
  static VJournal parse(String vjournalString) {
    final lines = vjournalString.split('\n');
    String? uid;
    DateTime? dtstamp;
    String? summary;
    String? description;
    String? status;
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
        case 'DESCRIPTION':
          description = value;
          break;
        case 'STATUS':
          status = value;
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

    return VJournal(
      uid: uid ?? '',
      dtstamp: dtstamp ?? DateTime.now(),
      summary: summary ?? '',
      description: description,
      status: status,
      attendees: attendees,
      organizer: organizer,
      contact: contact,
    );
  }
}
