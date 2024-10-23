import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/utils.dart';
// VEvent Class with attendees, recurrence, and attachments
class VEvent extends ICalendarComponent {
  String uid;
  DateTime dtstamp;
  DateTime dtstart;
  DateTime dtend;
  String summary;
  String? description;
  String? location;
  EVENTStatus? status;
  RecurrenceRule? rrule;
  List<DateTime>? exDates;
  List<Attendee>? attendees;
  MailTo? organizer;
  String? contact;
  String? attachment;

  VEvent({
    required this.uid,
    required this.dtstamp,
    required this.dtstart,
    required this.dtend,
    required this.summary,
    this.description,
    this.location,
    this.status,
    this.rrule,
    this.exDates,
    this.attendees,
    this.organizer,
    this.contact,
    this.attachment,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VEVENT\n');
    buffer.write('UID:$uid\n');
    buffer.write('DTSTAMP:${formatDateTime(dtstamp)}\n');
    buffer.write('DTSTART:${formatDateTime(dtstart)}\n');
    buffer.write('DTEND:${formatDateTime(dtend)}\n');
    buffer.write('SUMMARY:$summary\n');
    if (description != null) buffer.write('DESCRIPTION:$description\n');
    if (location != null) buffer.write('LOCATION:$location\n');
    if (status != null) buffer.write('STATUS:${status != null ? Heplers.camelToSnake(status!.name).toUpperCase() : null}\n');
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
    if (attachment != null) buffer.write('ATTACH:$attachment\n');
    buffer.write('END:VEVENT');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'DTSTAMP': formatDateTime(dtstamp),
      'DTSTART': formatDateTime(dtstart),
      'DTEND': formatDateTime(dtend),
      'SUMMARY': summary,
      'DESCRIPTION': description,
      'LOCATION': location,
      'STATUS': status?.name != null ? Heplers.camelToSnake(status!.name).toUpperCase() : null,
      'RRULE': rrule?.toJson(),
      'EXDATE': exDates?.map((date) => formatDateTime(date)).toList(),
      'ATTENDEE': attendees?.map((e)=>e.toJson()).toList(),
      'ORGANIZER': organizer?.mailto,
      'CONTACT': contact,
      'ATTACH': attachment,
    };
  }

  static VEvent parse(String veventString) {
   
    final lines = veventString.split('\n');
    
    String? uid;
    DateTime? dtstamp;
    DateTime? dtstart;
    DateTime? dtend;
    String? summary;
    String? description;
    String? location;
    EVENTStatus? status;
    RecurrenceRule? rrule;
    List<DateTime>? exDates;
    List<Attendee>? attendees;
    MailTo? organizer;
    String? contact;
    String? attachment;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts.getRange(1, parts.length).join(':');

      switch (key) {
        case 'UID':
          uid = value;
          break;
        case 'DTSTAMP':
          dtstamp = DateTime.parse(value.replaceAll('Z', ''));
          break;
        case 'DTSTART':
          dtstart = DateTime.parse(value.replaceAll('Z', ''));
          break;
        case 'DTEND':
          dtend = DateTime.parse(value.replaceAll('Z', ''));
          break;
        case 'SUMMARY':
          summary = value;
          break;
        case 'DESCRIPTION':
          description = value;
          break;
        case 'LOCATION':
          location = value;
          break;
        case 'STATUS':
          status = EVENTStatus.values.firstWhere((e) => Heplers.camelToSnake(e.name).toUpperCase() == value);
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
          attendees.add(Attendee.parse(value) );
          break;
        case 'ORGANIZER':
          organizer = MailTo.parse(value);
          break;
        case 'CONTACT':
          contact = value;
          break;
        case 'ATTACH':
          attachment = value;
          break;
      }
    }

    return VEvent(
      uid: uid ?? '',
      dtstamp: dtstamp ?? DateTime.now(),
      dtstart: dtstart ?? DateTime.now(),
      dtend: dtend ?? DateTime.now().add(const Duration(hours: 1)),
      summary: summary ?? '',
      description: description,
      location: location,
      status: status,
      rrule: rrule,
      exDates: exDates,
      attendees: attendees,
      organizer: organizer,
      contact: contact,
      attachment: attachment,
    );
  }
}
