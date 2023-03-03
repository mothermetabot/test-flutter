class Instrument {
  const Instrument(this._id, this._name, this._minTemperature,
      this._maxTemperature, this._maxHeatingRate);

  final String _id;
  String get id => _id;

  final String _name;
  String get name => _name;

  final double _minTemperature;
  double get minTemperature => _minTemperature;

  final double _maxTemperature;
  double get maxTemperature => _maxTemperature;

  final double _maxHeatingRate;
  double get maxHeatingRate => _maxHeatingRate;
}

class InstrumentState {
  double temperature = double.nan;
}

class InstrumentSession {
  InstrumentSession(this._id, this._clusterId, this._connectionTime,
      this._instrument, this.portState);

  final String _id;
  final String _clusterId;
  final DateTime _connectionTime;
  final Instrument _instrument;

  String get id => _id;
  String get clusterId => _clusterId;
  DateTime get onnectionTime => _connectionTime;
  Instrument get instrument => _instrument;

  bool portState = false;

  factory InstrumentSession.fromJson(dynamic argument) {
    var map = argument as Map<String, dynamic>;
    var id = map["id"];
    var clusterId = map["clusterId"];
    var connectionTime = map["connectionTime"];
    var portState = map["portState"];
    var instrument = map["instrument"] as Map<String, dynamic>;

    var instId = instrument["id"];
    var name = instrument["name"];

    var minTempField = instrument["minTemperature"];
    var maxTempField = instrument["maxTemperature"];
    var maxRateField = instrument["maxHeatingRate"];

    double minTemp =
        minTempField is double ? minTempField : minTempField.toDouble();
    double maxTemp =
        maxTempField is double ? maxTempField : maxTempField.toDouble();
    double maxRate =
        maxRateField is double ? maxRateField : maxRateField.toDouble();

    var instModel = Instrument(instId, name, minTemp, maxTemp, maxRate);
    var session = InstrumentSession(
        id, clusterId, DateTime.parse(connectionTime), instModel, portState);

    return session;
  }
}
