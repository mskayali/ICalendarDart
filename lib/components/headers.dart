// Calendar Headers
class CalHeaders {
  String prodId = '-//Your Organization//Your Product//EN';
  String version = '2.0';
  String calScale = 'GREGORIAN';

  CalHeaders({String? prodId, String? version, String? calScale}) {
    if (prodId != null) this.prodId = prodId;
    if (version != null) this.version = version;
    if (calScale != null) this.calScale = calScale;
  }

  @override
  String toString() {
    return 'PRODID:$prodId\nVERSION:$version\nCALSCALE:$calScale';
  }

  Map<String, String> toJson() {
    return {
      'PRODID': prodId,
      'VERSION': version,
      'CALSCALE': calScale,
    };
  }
}
