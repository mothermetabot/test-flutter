class Inst {
  static const String register = 'register_instrument';
  static const String fetch = 'Get';
  static const String unregister = 'unregister_instrument';
  static const String status = 'update_instrument_status';
  static const String subscribe = "Subscribe";
  static const String rtRoute =
      'https://proinstruments.azurewebsites.net/rt/instrument';
}

class Meas {
  static const String started = "start_measurement";
  static const String ended = "end_measurement";
  static const String route =
      "https://promeasurement.azurewebsites.net/api/$clusterId/measurement";

  static const String host = "promeasurement.azurewebsites.net";

  static const String path = "api/$clusterId/measurement";

  static const String rtRoute =
      'https://promeasurement.azurewebsites.net/rt/measurement';
  static const String register = "Register";
}

const String clusterId = "ef91bcb7-a3d0-4add-9af9-500a64461923";
