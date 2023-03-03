enum EventType { register, unregister, update, start, end }

class Event<T> {
  const Event(this._type, this._data);

  final EventType _type;

  final T _data;

  T get data => _data;

  EventType get type => _type;
}