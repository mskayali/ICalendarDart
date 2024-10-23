import 'package:icalendar_plus/components/icalendar_component.dart';
// EXDATE Class to represent exception dates in recurring components
class ExDate extends ICalendarComponent {
  List<DateTime> exDates;

  ExDate({required this.exDates});

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:EXDATE\n');
    for (var date in exDates) {
      buffer.write('EXDATE:${formatDateTime(date)}\n');
    }
    buffer.write('END:EXDATE');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'EXDATES': exDates.map((date) => formatDateTime(date)).toList(),
    };
  }

  // Parsing EXDATE from .ics formatted string
  static ExDate parse(String exdateString) {
    final lines = exdateString.split('\n');
    List<DateTime> exDates = [];

    for (var line in lines) {
      if (line.startsWith('EXDATE')) {
        final parts = line.split(':');
        if (parts.length > 1) {
          exDates.add(DateTime.parse(parts[1].replaceAll('Z', '')));
        }
      }
    }

    return ExDate(exDates: exDates);
  }
}
