import 'package:icalendar_plus/components/headers.dart';
import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/valarm.dart';
import 'package:icalendar_plus/components/vattachment.dart';
import 'package:icalendar_plus/components/vevent.dart';
import 'package:icalendar_plus/components/vfreebusy.dart';
import 'package:icalendar_plus/components/vjournal.dart';
import 'package:icalendar_plus/components/vparticioant.dart';
import 'package:icalendar_plus/components/vtimezone.dart';
import 'package:icalendar_plus/components/vtodo.dart';
// Main ICalendar class
class ICalendar implements ICalendarComponent {
  CalHeaders headers;
  List<ICalendarComponent> components = [];

  ICalendar._internal(this.headers);

  static ICalendar instance(CalHeaders headers) {
    return ICalendar._internal(headers);
  }

  void add(ICalendarComponent component) {
    components.add(component);
  }

  void addAll(List<ICalendarComponent> componentsList) {
    for (var component in componentsList) {
      add(component);
    }
  }

  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VCALENDAR\n');
    buffer.write('$headers\n');
    for (var component in components) {
      buffer.write('${component.serialize()}\n');
    }
    buffer.write('END:VCALENDAR');
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'headers': headers.toJson(),
      'components': components.map((component) => component.toJson()).toList(),
    };
  }

  // Parse ICalendar from .ics string
  static ICalendar parse(String icsString) {
    final lines = icsString.split('\n');
    CalHeaders? headers;
    List<ICalendarComponent> components = [];
    String? currentComponent;
    StringBuffer componentBuffer = StringBuffer();

    for (var line in lines) {
      line = line.trim();
      if (line.startsWith('BEGIN:')) {
        currentComponent = line.substring(6);
        componentBuffer = StringBuffer();
        componentBuffer.write('$line\n');
      } else if (line.startsWith('END:')) {
        final endComponent = line.substring(4);
        componentBuffer.write('$line\n');
        if (currentComponent == endComponent) {
          // Complete component
          if (currentComponent?.toUpperCase() == 'VEVENT') {
            components.add(VEvent.parse(componentBuffer.toString()));
          } else if (currentComponent?.toUpperCase() == 'VTODO') {
            components.add(VTodo.parse(componentBuffer.toString()));
          }else if (currentComponent?.toUpperCase() == 'VALARM') {
            components.add(VAlarm.parse(componentBuffer.toString()));
          } else if (currentComponent?.toUpperCase() == 'VATTACHMENT') {
            components.add(VAttachment.parse(componentBuffer.toString()));
          }else if (currentComponent?.toUpperCase() == 'VFREEBUSY') {
            components.add(VFreeBusy.parse(componentBuffer.toString()));
          } else if (currentComponent?.toUpperCase() == 'VJOURNAL') {
            components.add(VJournal.parse(componentBuffer.toString()));
          } else if (currentComponent?.toUpperCase() == 'VPARTICIPANT') {
            components.add(VParticipant.parse(componentBuffer.toString()));
          } else if (currentComponent?.toUpperCase() == 'VTIMEZONE') {
            components.add(VTimezone.parse(componentBuffer.toString()));
          }
          currentComponent = null;
        }
      } else if (currentComponent != null) {
        componentBuffer.write('$line\n');
      } else {
        // Assume header lines
        if (line.startsWith('PRODID') || line.startsWith('VERSION') || line.startsWith('CALSCALE')) {
          headers ??= CalHeaders();
          final parts = line.split(':');
          if (parts.length == 2) {
            final key = parts[0];
            final value = parts.getRange(1, parts.length).join(':');
            switch (key) {
              case 'PRODID':
                headers.prodId = value;
                break;
              case 'VERSION':
                headers.version = value;
                break;
              case 'CALSCALE':
                headers.calScale = value;
                break;
            }
          }
        }
      }
    }

    final calendar = ICalendar._internal(headers ?? CalHeaders());
    calendar.components = components;
    return calendar;
  }
}
