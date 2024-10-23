// Abstract class for calendar components


abstract class ICalendarComponent {
  String serialize();
  Map<String, dynamic> toJson();
  String toString();
  static List<ICalendarComponent> parse(String data) {
    throw UnimplementedError();
  }
}
