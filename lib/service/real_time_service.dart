// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_2/constants.dart';
import 'package:sample_2/model/instrument.dart';
import 'package:signalr_core/signalr_core.dart';

import '../model/event.dart';
import '../model/measurement.dart';

@singleton
class RealTimeService {
  final Subject<Event<InstrumentSession>> _instruments = PublishSubject();
  Stream<Event<InstrumentSession>> get instruments => _instruments;

  final Subject<Event<Measurement>> _measurements = PublishSubject();
  Stream<Event<Measurement>> get measurements => _measurements;

  final List<InstrumentSession> _sessions = [];
  Iterable<InstrumentSession> get sessions => _sessions;

  final _instrumentConnection =
      HubConnectionBuilder().withUrl(Inst.rtRoute).build();

  final _measurementConnection =
      HubConnectionBuilder().withUrl(Meas.rtRoute).build();

  @factoryMethod
  @preResolve
  static Future<RealTimeService> create() async {
    var realTime = RealTimeService();
    await realTime._initialize();

    return realTime;
  }

  Future<void> _initialize() async {
    await _initializeInstruments();
    await _initializeMeasurement();
  }

  Future<void> _initializeInstruments() async {
    _instrumentConnection.on(
        Inst.register, (args) => _notifyInstrument(EventType.register, args));
    _instrumentConnection.on(Inst.unregister,
        (args) => _notifyInstrument(EventType.unregister, args));

    await _instrumentConnection.start();
    await _instrumentConnection
        .send(methodName: Inst.subscribe, args: [clusterId]);

    var instruments = await _instrumentConnection
        .invoke(Inst.fetch, args: [clusterId]) as List<dynamic>;

    for (var instrument in instruments) {
      var session = InstrumentSession.fromJson(instrument);
      _sessions.add(session);
    }
  }

  Future<void> _initializeMeasurement() async {
    _measurementConnection.on(
        Meas.started, (args) => _notifyMeasurement(EventType.start, args));
    _measurementConnection.on(
        Meas.ended, (args) => _notifyMeasurement(EventType.end, args));

    await _measurementConnection.start();
    await _measurementConnection
        .send(methodName: Meas.register, args: [clusterId]);

    var client = http.Client();
    try {
      var uri = Uri(
        scheme: 'https',
        host: Meas.host,
        path: Meas.path,
      );
      log(uri.toString());
      var response = await client.get(uri);

      var list = json.decode(response.body);

      for (var element in list) {
        try {
          if (element["end"] != null) {
            continue;
          }
        } catch (e) {
          continue;
        }

        var measurement = Measurement.fromJson(element);
        var event = Event<Measurement>(EventType.start, measurement);
        _measurements.add(event);
      }
    } finally {
      client.close();
    }
  }

  void _notifyMeasurement(EventType type, List<dynamic>? arguments) {
    if (arguments == null || arguments.length != 1) {
      throw Error();
    }

    var measurement = Measurement.fromJson(arguments.first);
    var event = Event<Measurement>(type, measurement);
    _measurements.add(event);
  }

  void _notifyInstrument(EventType type, List<dynamic>? arguments) {
    if (arguments == null || arguments.length != 1) {
      throw Error();
    }
    var session = InstrumentSession.fromJson(arguments.first);

    if (type == EventType.register)
      _sessions.add(session);
    else if (type == EventType.unregister)
      _sessions.removeWhere((s) => s.instrument.id == session.instrument.id);

    var event = Event<InstrumentSession>(type, session);
    _instruments.add(event);
  }
}
