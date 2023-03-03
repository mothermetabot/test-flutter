import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_2/model/instrument.dart';
import 'package:sample_2/service/notification_service.dart';
import 'package:sample_2/service/real_time_service.dart';

import '../injection.dart';
import '../model/event.dart';
import '../model/measurement.dart';

class SessionPreview extends StatefulWidget {
  const SessionPreview({super.key, required this.session});

  final InstrumentSession session;

  @override
  State<StatefulWidget> createState() => _SessionPreviewState();
}

class _SessionPreviewState extends State<SessionPreview> {
  _SessionPreviewState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rtService.measurements
          .where(_belongsToThis)
          .listen(_handleInstrumentMeasurement);
    });
  }
  final _rtService = getIt<RealTimeService>();
  final _notificationService = getIt<NotificationService>();

  bool ongoing = false;

  Measurement? measurement;

  final List<dynamic> _notifySubscriptions = [];
  bool _notify = false;
  bool get notify => _notify;
  set notify(bool value) {
    if (!value) {
      _notifySubscriptions.map((sub) => sub.cancel());
      _notifySubscriptions.clear();
    } else {
      var measurementSub = _rtService.measurements
          .where(_belongsToThis)
          .listen(_notifyMeasurement);

      var disconnectSub =
          _rtService.instruments.where(_isThis).listen(_notifyInstrument);

      _notifySubscriptions.add(measurementSub);
      _notifySubscriptions.add(disconnectSub);
    }

    setState(() => _notify = value);
  }

  bool _belongsToThis(Event<Measurement> event) =>
      event.data.instrumentId == widget.session.instrument.id;

  bool _isThis(Event<InstrumentSession> event) =>
      event.data.instrument.id == widget.session.instrument.id;

  void _handleInstrumentMeasurement(Event<Measurement> event) {
    switch (event.type) {
      case EventType.start:
        setState(() {
          ongoing = true;
          measurement = event.data;
        });
        break;

      case EventType.end:
        setState(() {
          ongoing = false;
          measurement = null;
        });
        break;

      default:
        // TODO: Handle this case.
        break;
    }
  }

  void _notifyMeasurement(Event<Measurement> event) {
    if (event.type == EventType.end) {
      _notificationService.push(widget.session.instrument.name,
          "A measurement has finished.");
    } else if (event.type == EventType.start) {
      _notificationService.push(widget.session.instrument.name,
          "A measurement started.");
    }
  }

  void _notifyInstrument(Event<InstrumentSession> event) {
    var name = event.data.instrument.name;
    _notificationService.push(
        "Instrument event", "A monitored instrument has disconnected: $name.");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        decoration: const ShapeDecoration(
          color: Color(0xffe9e9e9),
          shape: RoundedRectangleBorder(
            // <--- use this
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Row(
                children: [
                  Expanded(child: Text(widget.session.instrument.name)),
                  Switch(value: notify, onChanged: (val) => notify = val)
                ],
              ),
              if(ongoing) const Expanded(
                child: Text(
                  "Measurement Running"
                )
              )
            ])));
  }
}
