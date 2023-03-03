class SignalChannel {}

enum Signals { temperature, dsc, lfaPulseShape, lfaDetector, weight }

const signalMap = <int, Signals>{
  1: Signals.temperature,
  2: Signals.dsc,
  4: Signals.lfaPulseShape,
  5: Signals.lfaDetector,
  9: Signals.weight,
};

const signalUnit = <Signals, String> {
    Signals.temperature : "°C",
    Signals.dsc : "µV",
    Signals.lfaPulseShape: "*",
    Signals.lfaDetector: "*",
    Signals.weight: "g"
};

