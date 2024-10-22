
import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/utils.dart';
// VAlarm Class representing an alarm component in iCalendar
class VAlarm extends ICalendarComponent {
  VAlarmAction action; // e.g., "DISPLAY", "EMAIL"
  RelativeTime trigger; // Time before or after an event when the alarm should go off
  String? description; // Description of the alarm
  String? duration; // Duration for repeating alarms
  int? repeat; // Number of times the alarm should repeat
  String? attach; // URL or binary data (like sound) associated with the alarm

  VAlarm({
    required this.action,
    required this.trigger,
    this.description,
    this.duration,
    this.repeat,
    this.attach,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VALARM\n');
    buffer.write('ACTION:${Heplers.camelToSnake(action.name).toUpperCase()}\n');
    buffer.write('TRIGGER:$trigger\n');
    if (description != null) buffer.write('DESCRIPTION:$description\n');
    if (duration != null) buffer.write('DURATION:$duration\n');
    if (repeat != null) buffer.write('REPEAT:$repeat\n');
    if (attach != null) buffer.write('ATTACH:$attach\n');
    buffer.write('END:VALARM');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ACTION': Heplers.camelToSnake(action.name).toUpperCase(),
      'TRIGGER': trigger,
      'DESCRIPTION': description,
      'DURATION': duration,
      'REPEAT': repeat,
      'ATTACH': attach,
    };
  }

  // Parsing VAlarm from .ics formatted string
  static VAlarm parse(String valarmString) {
    final lines = valarmString.split('\n');
    VAlarmAction? action;
    RelativeTime? trigger;
    String? description;
    String? duration;
    int? repeat;
    String? attach;

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length < 2) continue;
      final key = parts[0];
      final value = parts[1];

      switch (key) {
        case 'ACTION':
          action = VAlarmAction.values.firstWhere((e)=> Heplers.camelToSnake(e.name).toUpperCase() == value);
          break;
        case 'TRIGGER':
          trigger = RelativeTime.parse(value);
          break;
        case 'DESCRIPTION':
          description = value;
          break;
        case 'DURATION':
          duration = value;
          break;
        case 'REPEAT':
          repeat = int.tryParse(value);
          break;
        case 'ATTACH':
          attach = value;
          break;
      }
    }

    if (action == null || trigger == null) {
      throw ArgumentError("ACTION and TRIGGER are required for a VALARM.");
    }

    return VAlarm(
      action: action,
      trigger: trigger,
      description: description,
      duration: duration,
      repeat: repeat,
      attach: attach,
    );
  }
}