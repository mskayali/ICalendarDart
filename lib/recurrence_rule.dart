// Class to manage recurrence rules (RRULE)
class RecurrenceRule {
  String frequency;
  int interval;
  DateTime? until;
  List<String>? byDay;

  RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.until,
    this.byDay,
  });

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }

  String serialize() {
    final buffer = StringBuffer();
    buffer.write('FREQ=$frequency;INTERVAL=$interval');
    if (until != null) {
      buffer.write(';UNTIL=${formatDateTime(until!)}');
    }
    if (byDay != null && byDay!.isNotEmpty) {
      buffer.write(';BYDAY=${byDay!.join(',')}');
    }
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'FREQ': frequency,
      'INTERVAL': interval,
      'UNTIL': until != null ? formatDateTime(until!) : null,
      'BYDAY': byDay,
    };
  }

  // Parsing RRULE from string
  static RecurrenceRule? parse(String ruleString) {
    final parts = ruleString.split(';');
    String? frequency;
    int interval = 1;
    DateTime? until;
    List<String>? byDay;

    for (var part in parts) {
      final keyValue = part.split('=');
      if (keyValue.length == 2) {
        final key = keyValue[0];
        final value = keyValue[1];
        switch (key) {
          case 'FREQ':
            frequency = value;
            break;
          case 'INTERVAL':
            interval = int.tryParse(value) ?? 1;
            break;
          case 'UNTIL':
            until = DateTime.parse(value.replaceAll('Z', ''));
            break;
          case 'BYDAY':
            byDay = value.split(',');
            break;
        }
      }
    }

    if (frequency != null) {
      return RecurrenceRule(
        frequency: frequency,
        interval: interval,
        until: until,
        byDay: byDay,
      );
    }
    return null;
  }
}
