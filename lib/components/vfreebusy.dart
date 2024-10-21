import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/utils.dart';
// VFreeBusy Class representing a free/busy time component in iCalendar
class VFreeBusy extends ICalendarComponent {
  String uid;
  DateTime dtstamp;
  DateTime dtstart;
  DateTime dtend;
  List<DateRangeUtil>? freeTimes; // Free periods in "START/END" format
  List<DateRangeUtil>? busyTimes; // Busy periods in "START/END" format
  String? organizer;
  String? contact;

  VFreeBusy({
    required this.uid,
    required this.dtstamp,
    required this.dtstart,
    required this.dtend,
    this.freeTimes,
    this.busyTimes,
    this.organizer,
    this.contact,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VFREEBUSY\n');
    buffer.write('UID:$uid\n');
    buffer.write('DTSTAMP:${formatDateTime(dtstamp)}\n');
    buffer.write('DTSTART:${formatDateTime(dtstart)}\n');
    buffer.write('DTEND:${formatDateTime(dtend)}\n');
    if (freeTimes != null) {
      for (var freeTime in freeTimes!) {
        buffer.write('FREEBUSY;FBTYPE=FREE:$freeTime\n');
      }
    }
    if (busyTimes != null) {
      for (var busyTime in busyTimes!) {
        buffer.write('FREEBUSY;FBTYPE=BUSY:$busyTime\n');
      }
    }
    if (organizer != null) buffer.write('ORGANIZER:$organizer\n');
    if (contact != null) buffer.write('CONTACT:$contact\n');
    buffer.write('END:VFREEBUSY');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'DTSTAMP': formatDateTime(dtstamp),
      'DTSTART': formatDateTime(dtstart),
      'DTEND': formatDateTime(dtend),
      'FREETIMES': freeTimes,
      'BUSYTIMES': busyTimes,
      'ORGANIZER': organizer,
      'CONTACT': contact,
    };
  }

  // Parsing VFreeBusy from .ics formatted string
  static VFreeBusy parse(String vfreebusyString) {
    final lines = vfreebusyString.split('\n');
    String? uid;
    DateTime? dtstamp;
    DateTime? dtstart;
    DateTime? dtend;
    List<DateRangeUtil>? freeTimes;
    List<DateRangeUtil>? busyTimes;
    String? organizer;
    String? contact;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts[1];

      if (key.contains(';')) {
        final keyParts = key.split(';');
        if (keyParts.length == 2 && keyParts[0] == 'FREEBUSY') {
          final fbTypeParts = keyParts[1].split('=');
          if (fbTypeParts.length == 2) {
            final fbType = fbTypeParts[1];
            if (fbType == 'FREE') {
              freeTimes ??= [];
              freeTimes.add(DateRangeUtil.parse(value) );
            } else if (fbType == 'BUSY') {
              busyTimes ??= [];
              busyTimes.add(DateRangeUtil.parse(value));
            }
          }
        }
        continue;
      }

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
        case 'ORGANIZER':
          organizer = value;
          break;
        case 'CONTACT':
          contact = value;
          break;
      }
    }

    return VFreeBusy(
      uid: uid ?? '',
      dtstamp: dtstamp ?? DateTime.now(),
      dtstart: dtstart ?? DateTime.now(),
      dtend: dtend ?? DateTime.now().add(const Duration(hours: 1)),
      freeTimes: freeTimes,
      busyTimes: busyTimes,
      organizer: organizer,
      contact: contact,
    );
  }
}
