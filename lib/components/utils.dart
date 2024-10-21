class DateRangeUtil{
  final DateTime start;
  final DateTime end;
  final String seperator;
  DateRangeUtil({
    required this.start,
    required this.end,
    this.seperator ='/'
  });
  String formatDateTime(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }
  @override
  String toString() {
    return '${formatDateTime(start)}$seperator${formatDateTime(end)}';
  }

  static DateRangeUtil parse(String daterangeutilString,[String seperator='/']) {
    final lines = daterangeutilString.split(seperator);
    if(lines.length == 2){
      try {
        return DateRangeUtil(start: DateTime.parse(lines[0]), end: DateTime.parse(lines[1]), seperator: seperator);
      } catch (e) {
        throw 'Unexpected date format';
      }
    }
    throw 'Unexpected date range format';
  }
}

class Heplers{
    static String camelToSnake(String camelCase) {
    // Use a regular expression to find uppercase letters and replace them with an underscore followed by the lowercase letter
    String snakeCase = camelCase.replaceAllMapped(RegExp(r'[A-Z]'), (Match match) {
      return '_${match.group(0)!.toLowerCase()}';
    });

    // If the string starts with an underscore, remove it (in case the original string started with an uppercase letter)
    if (snakeCase.startsWith('-')) {
      snakeCase = snakeCase.substring(1);
    }

    return snakeCase;
  }
}

enum Frequancy{daily,weekly,monthly,yearly}
enum Days{
  mo, //Monday
  tu, //Tuesday
  we, //Wednesday
  th, //Thursday
  fr, //Friday
  sa, //Saturday
  su, //Sunday
}
enum TODOStatus{
  needsAction,//NEEDS-ACTION
  completed,//COMPLETED
  inProcess,//IN-PROCESS
  cancelled,//CANCELLED
}
enum JOURNALStatus{
  draft,//DRAFT
  final_,//FINAL
  cancelled,//CANCELLED
}
enum EVENTStatus{
  tentative,//TENTATIVE
  confirmed,//CONFIRMED
  cancelled,//CANCELLED
}
class ByDay{
  final int? preCount;
  final Days day;
  ByDay({this.preCount, required this.day});

  @override
  String toString() {
    return '${preCount ?? ""}${day.name.toUpperCase()}';
  }

  static ByDay parse(String byDayString) {
    return ByDay(
      preCount: int.tryParse(byDayString.length > 2 ? byDayString.substring(0,byDayString.length-2) : ''),
      day: Days.values.firstWhere((e)=>e.name.toUpperCase() ==  byDayString.substring(byDayString.length-2,byDayString.length).toUpperCase())
    );
  }
}
// Class to manage recurrence rules (RRULE)
class RecurrenceRule {
  Frequancy frequency;
  int interval;
  DateTime? until;
  List<ByDay>? byDay;

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
    buffer.write('FREQ=${frequency.name.toUpperCase()};INTERVAL=$interval');
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
      'FREQ': frequency.name.toUpperCase(),
      'INTERVAL': interval,
      'UNTIL': until != null ? formatDateTime(until!) : null,
      'BYDAY': byDay,
    };
  }

  // Parsing RRULE from string
  static RecurrenceRule? parse(String ruleString) {
    final parts = ruleString.split(';');
    Frequancy? frequency;
    int interval = 1;
    DateTime? until;
    List<ByDay>? byDay;

    for (var part in parts) {
      final keyValue = part.split('=');
      if (keyValue.length == 2) {
        final key = keyValue[0];
        final value = keyValue[1];
        switch (key) {
          case 'FREQ':
            frequency = Frequancy.values.firstWhere((e)=> e.name == value,) ;
            break;
          case 'INTERVAL':
            interval = int.tryParse(value) ?? 1;
            break;
          case 'UNTIL':
            until = DateTime.parse(value.replaceAll('Z', ''));
            break;
          case 'BYDAY':
            byDay = value.split(',').map((e)=> ByDay.parse(e)).toList();
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
