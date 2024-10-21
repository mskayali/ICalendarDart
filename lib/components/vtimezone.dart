import 'package:icalendar/components/icalendar_component.dart';
// VTimezone Class representing a timezone component in iCalendar

class VTimezone extends ICalendarComponent {
  String tzid; // Timezone ID
  String? standardOffset; // Standard time offset
  String? daylightOffset; // Daylight saving time offset
  DateTime? standardStart; // Start date of standard time
  DateTime? daylightStart; // Start date of daylight saving time

  VTimezone({
    required this.tzid,
    this.standardOffset,
    this.daylightOffset,
    this.standardStart,
    this.daylightStart,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VTIMEZONE\n');
    buffer.write('TZID:$tzid\n');
    if (standardOffset != null && standardStart != null) {
      buffer.write('BEGIN:STANDARD\n');
      buffer.write('DTSTART:${formatDateTime(standardStart!)}\n');
      buffer.write('TZOFFSETFROM:$standardOffset\n');
      buffer.write('END:STANDARD\n');
    }
    if (daylightOffset != null && daylightStart != null) {
      buffer.write('BEGIN:DAYLIGHT\n');
      buffer.write('DTSTART:${formatDateTime(daylightStart!)}\n');
      buffer.write('TZOFFSETTO:$daylightOffset\n');
      buffer.write('END:DAYLIGHT\n');
    }
    buffer.write('END:VTIMEZONE');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'TZID': tzid,
      'STANDARD_OFFSET': standardOffset,
      'DAYLIGHT_OFFSET': daylightOffset,
      'STANDARD_START': standardStart != null ? formatDateTime(standardStart!) : null,
      'DAYLIGHT_START': daylightStart != null ? formatDateTime(daylightStart!) : null,
    };
  }

  // Parsing VTimezone from .ics formatted string
  static VTimezone parse(String vtimezoneString) {
    final lines = vtimezoneString.split('\n');
    String? tzid;
    String? standardOffset;
    String? daylightOffset;
    DateTime? standardStart;
    DateTime? daylightStart;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts[1];

      switch (key) {
        case 'TZID':
          tzid = value;
          break;
        case 'TZOFFSETFROM':
          standardOffset = value;
          break;
        case 'TZOFFSETTO':
          daylightOffset = value;
          break;
        case 'DTSTART':
          if (line.contains("STANDARD")) {
            standardStart = DateTime.parse(value.replaceAll('Z', ''));
          } else if (line.contains("DAYLIGHT")) {
            daylightStart = DateTime.parse(value.replaceAll('Z', ''));
          }
          break;
      }
    }

    return VTimezone(
      tzid: tzid ?? '',
      standardOffset: standardOffset,
      daylightOffset: daylightOffset,
      standardStart: standardStart,
      daylightStart: daylightStart,
    );
  }
}
