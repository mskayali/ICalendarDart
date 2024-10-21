// Abstract class for calendar components
abstract class ICalendarComponent {
  String formatDateTime(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }

  String serialize();
  Map<String, dynamic> toJson();
}
