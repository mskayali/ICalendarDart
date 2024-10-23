import 'package:icalendar_plus/icalendar.dart';

class VTimezone extends ICalendarComponent {
  String tzid; // Timezone ID
  Duration? standardOffset; // Standard time offset as Duration
  Duration? daylightOffset; // Daylight saving time offset as Duration
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
      buffer.write('TZOFFSETFROM:${Heplers.durationToOffsetString(standardOffset!)}\n');
      buffer.write('END:STANDARD\n');
    }
    if (daylightOffset != null && daylightStart != null) {
      buffer.write('BEGIN:DAYLIGHT\n');
      buffer.write('DTSTART:${formatDateTime(daylightStart!)}\n');
      buffer.write('TZOFFSETTO:${Heplers.durationToOffsetString(daylightOffset!)}\n');
      buffer.write('END:DAYLIGHT\n');
    }
    buffer.write('END:VTIMEZONE');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'TZID': tzid,
      'STANDARD_OFFSET': standardOffset != null ? Heplers.durationToOffsetString(standardOffset!) : null,
      'DAYLIGHT_OFFSET': daylightOffset != null ? Heplers.durationToOffsetString(daylightOffset!) : null,
      'STANDARD_START': standardStart != null ? formatDateTime(standardStart!) : null,
      'DAYLIGHT_START': daylightStart != null ? formatDateTime(daylightStart!) : null,
    };
  }



  // Parsing VTimezone from .ics formatted string
  static VTimezone parse(String vtimezoneString) {
    final lines = vtimezoneString.split('\n');
    String? tzid;
    Duration? standardOffset;
    Duration? daylightOffset;
    DateTime? standardStart;
    DateTime? daylightStart;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts.getRange(1, parts.length).join(':');

      switch (key) {
        case 'TZID':
          tzid = value;
          break;
        case 'TZOFFSETFROM':
          standardOffset = parseOffsetToDuration(value);
          break;
        case 'TZOFFSETTO':
          daylightOffset = parseOffsetToDuration(value);
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

  // Convert offset string to Duration (e.g., "+0200" -> Duration(hours: 2))
  static Duration parseOffsetToDuration(String offset) {
    // Check if it's a negative offset
    bool isNegative = offset.startsWith('-');
    int hours = int.parse(offset.substring(1, 3));
    int minutes = int.parse(offset.substring(3, 5));

    Duration duration = Duration(hours: hours, minutes: minutes);
    return isNegative ? -duration : duration;
  }
}
