import 'package:icalendar/components/exdate.dart';
import 'package:icalendar/components/headers.dart';
import 'package:icalendar/components/icalendar_component.dart';
import 'package:icalendar/components/valarm.dart';
import 'package:icalendar/components/vattachment.dart';
import 'package:icalendar/components/vevent.dart';
import 'package:icalendar/components/vfreebusy.dart';
import 'package:icalendar/components/vjournal.dart';
import 'package:icalendar/components/vparticioant.dart';
import 'package:icalendar/components/vtimezone.dart';
import 'package:icalendar/components/vtodo.dart';
// Main ICalendar class
class ICalendar {
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
          if (currentComponent == 'VEVENT') {
            components.add(VEvent.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VTODO') {
            components.add(VTodo.parse(componentBuffer.toString()));
          } else if (currentComponent == 'ExDate') {
            components.add(ExDate.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VAlarm') {
            components.add(VAlarm.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VAttachment') {
            components.add(VAttachment.parse(componentBuffer.toString()));
          }else if (currentComponent == 'VFreeBusy') {
            components.add(VFreeBusy.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VJournal') {
            components.add(VJournal.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VParticipant') {
            components.add(VParticipant.parse(componentBuffer.toString()));
          } else if (currentComponent == 'VTimezone') {
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
            final value = parts[1];
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
