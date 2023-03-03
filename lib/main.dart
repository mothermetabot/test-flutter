import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_2/service/notification_service.dart';
import 'package:sample_2/service/real_time_service.dart';
import 'package:sample_2/widget/session_preview.dart';

import 'injection.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

void setup() {
  var notificationService = NotificationService();
  var realTimeService = RealTimeService();

  GetIt.I.reset(dispose: true);
  GetIt.I.registerSingleton<RealTimeService>(realTimeService);
  GetIt.I.registerSingleton<NotificationService>(notificationService);
}

MaterialColor myColor = MaterialColor(0xFF134640, color);
Map<int, Color> color = {
  50: const Color(0xFFe6efee),
  100: const Color(0xFFc1d6d4),
  200: const Color(0xFF98bbb7),
  300: const Color(0xFF6f9f9a),
  400: const Color(0xFF508b85),
  500: const Color(0xFF31766f),
  600: const Color(0xFF2c6e67),
  700: const Color(0xFF25635c),
  800: const Color(0xFF1f5952),
  900: const Color(0xFF134640),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proteus Now',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffe9e9e9),
        primarySwatch: myColor,
      ),
      home: const MyHomePage(title: 'Proteus.Now'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rtService.instruments.listen((event) {
        setState(() {});
      });
    });
  }

  final _rtService = getIt<RealTimeService>();

  List<Widget> _getInstruments() => _rtService.sessions
      .map((session) => SessionPreview(session: session))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: const EdgeInsets.all(8),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  side: BorderSide(color: Colors.black26)),
            ),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  children: <Widget>[
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text('My Instruments')),
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: _getInstruments(),
                    ),
                  ],
                ))));
  }
}
