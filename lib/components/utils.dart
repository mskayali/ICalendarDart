class DateRangeUtil{
  final DateTime start;
  final DateTime end;
  final String seperator;
  DateRangeUtil({
    required this.start,
    required this.end,
    this.seperator ='/'
  });
  @override
  String toString() {
    return '${Heplers.formatDateTime(start)}$seperator${Heplers.formatDateTime(end)}';
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

  static String durationToOffsetString(Duration duration) {
    int hours = duration.inHours.abs();
    int minutes = (duration.inMinutes.abs() % 60);
    String sign = duration.isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}${minutes.toString().padLeft(2, '0')}';
  }

  static Duration triggerToDuration(String trigger) {
      // Check if the trigger is negative
      bool isNegative = trigger.startsWith('-');

      // Remove the negative sign if present
      String normalizedTrigger = isNegative ? trigger.substring(1) : trigger;

      // Regular expression to match the trigger components
      RegExp regExp = RegExp(r'P((\d+)D)?(T((\d+)H)?((\d+)M)?((\d+)S)?)?');
      Match? match = regExp.firstMatch(normalizedTrigger);

      if (match != null) {
        int days = int.tryParse(match.group(2) ?? '0') ?? 0;
        int hours = int.tryParse(match.group(5) ?? '0') ?? 0;
        int minutes = int.tryParse(match.group(7) ?? '0') ?? 0;
        int seconds = int.tryParse(match.group(9) ?? '0') ?? 0;

        // Create the Duration object
        Duration duration = Duration(
          days: days,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        );

        // If the trigger was negative, return a negative duration
        return isNegative ? -duration : duration;
      } else {
        throw 'Invalid trigger format: $trigger';
      }
    }

    static String durationToTrigger(Duration duration) {
      // Check if the duration is negative
      bool isNegative = duration.isNegative;

      // Get the absolute values of the duration components
      int totalDays = duration.inDays.abs();
      int totalHours = duration.inHours.abs() % 24;
      int totalMinutes = duration.inMinutes.abs() % 60;
      int totalSeconds = duration.inSeconds.abs() % 60;

      // Create the trigger string parts
      StringBuffer buffer = StringBuffer();

      // Prefix with '-' if the duration is negative
      if (isNegative) {
        buffer.write('-');
      }

      buffer.write('P');

      // Add the day part if greater than zero
      if (totalDays > 0) {
        buffer.write('${totalDays}D');
      }

      // If there are hours, minutes, or seconds, add the time part
      if (totalHours > 0 || totalMinutes > 0 || totalSeconds > 0) {
        buffer.write('T');

        if (totalHours > 0) {
          buffer.write('${totalHours}H');
        }

        if (totalMinutes > 0) {
          buffer.write('${totalMinutes}M');
        }

        if (totalSeconds > 0) {
          buffer.write('${totalSeconds}S');
        }
      }

      return buffer.toString();
    }
    static String formatDateTime(DateTime dateTime) {
      return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
    }

    static String toCamelCase(String input) {
      // Split the input string by spaces, hyphens, or underscores
      List<String> words = input.split(RegExp(r'[\s_-]+'));

      // Convert the first word to lowercase and capitalize the first letter of the subsequent words
      String camelCaseString = words.map((word) {
        if (words.indexOf(word) == 0) {
          return word.toLowerCase();
        } else {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
      }).join('');

      return camelCaseString;
    }

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
  static bool isValidEmail(String email) {
    // Regular expression pattern for validating an email address
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    // Return true if the email matches the regex pattern
    return emailRegExp.hasMatch(email);
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
enum Role{
  chair, // The leader or chairperson of the meeting.
  reqParticipant, // A required participant.
  optParticipant, // An optional participant.
  nonParticipant, // Someone who is not attending but should be aware of the event.
}
enum VAlarmAction{
  display,
  audio,
  email,
  procedure,
}
enum Partstat{
  needsAction, //Awaiting response from the attendee.
  accepted, //The attendee has accepted the invitation.
  declined, //The attendee has declined the invitation.
  tentative, //The attendee tentatively accepted the invitation.
  delegated, //The invitation was delegated to someone else.
}
enum Cutype{
  individual, //A single person.
  group, //A group of individuals.
  resource, //A resource, such as a meeting room.
  room, //A specific room.
  unknown, //An unspecified or unknown user type.
}
enum TimeUnit{
  s, //second,
  m, //minute,
  h, //hour,
  d, //day,
  w, //week,
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

// Abstract class for calendar components
abstract class Trriger {
  static Trriger parse(String timeString) {
    final datetime = DateTime.tryParse(timeString);
    if (datetime == null) {
      try {
        return TrrigerDuration(Heplers.triggerToDuration(timeString));
      } catch (e) {
        throw 'Invalid format for RelativeTime string: $timeString';
      }
    } else {
      return TrrigerDate(datetime);
    }
  }
}

class TrrigerDate extends Trriger{
  final DateTime datetime;

  TrrigerDate(
    // this.type,
    this.datetime,
  );
  @override
  String toString() {
    return Heplers.formatDateTime(datetime);
  }
  static TrrigerDate parse(String timeString) {
    final datetime=DateTime.tryParse(timeString);
    if(datetime == null){
      throw 'Invalid format for RelativeTime string: $timeString';
    }else{
      return TrrigerDate(datetime);
    }
  }
}
class TrrigerDuration extends Trriger{
  final Duration duration;
  TrrigerDuration(
    this.duration,
  );
  @override
  String toString() {
    return Heplers.durationToTrigger(duration);
  }
  static TrrigerDuration parse(String timeString) {
    try {
      return TrrigerDuration(Heplers.triggerToDuration(timeString));
    } catch (e) {
      throw 'Invalid format for RelativeTime string: $timeString';
    }
  }
}
class MailTo{
  String mailto;
  MailTo(this.mailto){
    if (!Heplers.isValidEmail(mailto)) {
      throw 'Invalid MailTo email format';
    }
  }
  static MailTo parse(String mailtoString){
    final line=mailtoString.split(':');
    if(line.length==2 && line[0]=='mailto' && Heplers.isValidEmail(line[1].trim().replaceAll(',', ''))){
      return MailTo(line[1].trim().replaceAll(',', ''));
    }else if(Heplers.isValidEmail(line[0].trim().replaceAll(',', ''))){
        return MailTo(line[0].trim().replaceAll(',', ''));
    }
    throw 'Invalid MailTo format';
  }
  @override
  String toString() {
    return 'mailto:$mailto';
  }
}
class Attendee{
  MailTo mailto;
  String? cn;
  Role? role;
  bool? rsvp;
  Partstat? partstat;
  Cutype? cutype;
  String? delegatedTo;
  String? delegatedFrom;

  Attendee({
    required this.mailto,
    this.cn,
    this.role,
    this.rsvp,
    this.partstat,
    this.cutype,
    this.delegatedTo,
    this.delegatedFrom,
  }){
    int attributeCount=0;
    if(cn != null){attributeCount++;}
    if(role != null){attributeCount++;}
    if(rsvp != null){attributeCount++;}
    if(partstat != null){attributeCount++;}
    if(cutype != null){attributeCount++;}
    if(delegatedTo != null){
      if (!Heplers.isValidEmail(delegatedTo!)) {
        throw 'Invalid Attendee email format for mailTo';
      }
      attributeCount++;
    }
    if(delegatedFrom != null){
      if (!Heplers.isValidEmail(delegatedFrom!)) {
        throw 'Invalid Attendee email format for mailTo';
      }
      attributeCount++;
    }
    if(attributeCount > 1){
      throw 'Attendee cannot have more than one attribute';
    }
  }
  Map<String,dynamic> toJson() {
    return{
      'MAILTO':mailto.mailto,
      'CN': cn,
      'ROLE': role?.name != null ? Heplers.camelToSnake(role!.name).toUpperCase() : null,
      'RSVP': rsvp?.toString(),
      'PARTSTAT': partstat?.name != null ? Heplers.camelToSnake(partstat!.name).toUpperCase() : null,
      'CUTYPE': cutype?.name != null ? Heplers.camelToSnake(cutype!.name).toUpperCase() : null,
      'DELEGATED-TO': delegatedTo,
      'DELEGATED-FROM': delegatedFrom,
    };
  }
  static Attendee parse(String attendeeString) {
    final lines = attendeeString.split(';');
    Map<String,dynamic> attendeeJson={};
    for (String line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        final key = parts[0];
        final value = parts.getRange(1, parts.length).join(':');
        attendeeJson[key]=value;
      }
    }
    if(attendeeJson['mailto'] != null){
      return Attendee(
        mailto: MailTo.parse(attendeeJson['mailto']),
        cn: attendeeJson['CN'],
        role: attendeeJson['ROLE'] != null ? Role.values.firstWhere((e)=>e.name == Heplers.toCamelCase(attendeeJson['ROLE'])) : null,
        rsvp: attendeeJson['RSVP'] != null ? attendeeJson['RSVP'] == 'TRUE' : null,
        partstat: attendeeJson['PARTSTAT'] != null ? Partstat.values.firstWhere((e)=>e.name == Heplers.toCamelCase(attendeeJson['PARTSTAT'])) : null,
        cutype: attendeeJson['CUTYPE'] != null ? Cutype.values.firstWhere((e) => e.name == Heplers.toCamelCase(attendeeJson['CUTYPE'])) : null,
        delegatedTo: attendeeJson['DELEGATED-TO'],
        delegatedFrom: attendeeJson['DELEGATED-FROM']
      );
    }
    throw 'Unable to parse Attendee';
  }

  @override
  String toString() {
    var str= '';

    if(cn != null){
      str+='${Heplers.camelToSnake('cn').toUpperCase()}:$cn;';
    }
    if(role != null){
      str+='${Heplers.camelToSnake('role').toUpperCase()}:${role!.name.toUpperCase()};';
    }
    if(rsvp != null){
      str+='${Heplers.camelToSnake('rsvp').toUpperCase()}:${rsvp.toString().toUpperCase()};';
    }
    if(partstat != null){
      str+='${Heplers.camelToSnake('partstat').toUpperCase()}:${partstat!.name.toString().toUpperCase()};';
    }
    if(cutype != null){
      str+='${Heplers.camelToSnake('cutype').toUpperCase()}:${cutype!.name.toString().toUpperCase()};';
    }
    if(delegatedTo != null){
      str+='${Heplers.camelToSnake('delegatedTo').toUpperCase()}:$delegatedTo;';
    }
    if(delegatedFrom != null){
      str+='${Heplers.camelToSnake('delegatedFrom').toUpperCase()}:$delegatedFrom;';
    }
    str += mailto.toString();
    return str;
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
      'BYDAY': byDay.toString(),
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
