import 'package:icalendar/components/icalendar_component.dart';
// VParticipant Class to represent attendees, contacts, and organizers
class VParticipant extends ICalendarComponent {
  String role; // e.g., "ATTENDEE", "ORGANIZER", "CONTACT"
  String email;
  String? name; // Optional name for the participant

  VParticipant({
    required this.role,
    required this.email,
    this.name,
  });

  @override
  String serialize() {
    final buffer = StringBuffer();
    if (name != null) {
      buffer.write('$role;CN=$name:mailto:$email\n');
    } else {
      buffer.write('$role:mailto:$email\n');
    }
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ROLE': role,
      'EMAIL': email,
      'NAME': name,
    };
  }

  // Parsing VParticipant from .ics formatted string
  static VParticipant parse(String vparticipantString) {
    String? role;
    String? email;
    String? name;

    if (vparticipantString.contains('mailto')) {
      final parts = vparticipantString.split(':');
      role = parts[0].split(';')[0];
      email = parts[1];
      if (parts[0].contains('CN=')) {
        name = parts[0].split('CN=')[1];
      }
    }

    return VParticipant(
      role: role ?? '',
      email: email ?? '',
      name: name,
    );
  }
}
