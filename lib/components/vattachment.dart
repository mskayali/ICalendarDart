import 'package:icalendar_plus/components/icalendar_component.dart';
// VAttachment Class representing an attachment in iCalendar
class VAttachment extends ICalendarComponent {
  String? uri; // URI for the attachment
  String? binaryData; // Binary data for the attachment
  String? mimeType; // MIME type of the attachment

  VAttachment({this.uri, this.binaryData, this.mimeType});

  @override
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('BEGIN:ATTACHMENT\n');
    if (uri != null) buffer.write('ATTACH;FMTTYPE=$mimeType:$uri\n');
    if (binaryData != null) buffer.write('ATTACH;ENCODING=BASE64:$binaryData\n');
    buffer.write('END:ATTACHMENT');
    return buffer.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'URI': uri,
      'BINARY_DATA': binaryData,
      'MIME_TYPE': mimeType,
    };
  }

  // Parsing VAttachment from .ics formatted string
  static VAttachment parse(String vattachmentString) {
    final lines = vattachmentString.split('\n');
    String? uri;
    String? binaryData;
    String? mimeType;

    for (var line in lines) {
      if (line.startsWith('ATTACH')) {
        if (line.contains('FMTTYPE')) {
          final parts = line.split(':');
          mimeType = line.split(';')[1].split('=')[1];
          uri = parts.length > 1 ? parts[1] : null;
        } else if (line.contains('ENCODING')) {
          binaryData = line.split(':')[1];
        }
      }
    }

    return VAttachment(uri: uri, binaryData: binaryData, mimeType: mimeType);
  }
}
