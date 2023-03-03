class Measurement {
  Measurement(this.start, this.end, this.instrumentId);

  final DateTime start;
  final DateTime? end;

  final String instrumentId;

  factory Measurement.fromJson(dynamic argument) {
    var startString = argument["start"];
    var endString = argument["end"];

    DateTime? end;

    if (endString != null) {
      end = DateTime.parse(endString);
    }
    var instrumentId = argument["instrument"]["id"];

    return Measurement(DateTime.parse(startString), end, instrumentId);
  }
}
