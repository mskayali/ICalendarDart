import 'package:icalendar_plus/components/icalendar_component.dart';
import 'package:icalendar_plus/components/utils.dart';
// VParticipant Class to represent attendees, contacts, and organizers
class VParticipant extends ICalendarComponent {
  Role role; // e.g., "ATTENDEE", "ORGANIZER", "CONTACT"
  MailTo email;
  String? name; // Optional name for the participant

  VParticipant({
    required this.role,
    required this.email,
    this.name,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:VPARTICIPANT\n');
    
    if (name != null) {
      buffer.write('$role;CN=$name:$email\n');
    } else {
      buffer.write('$role:$email\n');
    }
    buffer.write('END:VPARTICIPANT');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ROLE': Helpers.camelToSnake(role.name).toUpperCase(),
      'EMAIL': email.mailto,
      'NAME': name,
    };
  }

  // Parsing VParticipant from .ics formatted string
  static VParticipant parse(String vparticipantString) {
    late Role role;
    late MailTo email;
    String? name;

    if (vparticipantString.contains('mailto')) {
      final parts = vparticipantString.split(':');
      role = Role.values.firstWhere((e)=> Helpers.camelToSnake(e.name).toUpperCase() == parts[0].split(';')[0]);
      email = MailTo.parse(parts[1]) ;
      if (parts[0].contains('CN=')) {
        name = parts[0].split('CN=')[1];
      }
    }

    return VParticipant(
      role: role,
      email: email ,
      name: name,
    );
  }
}
