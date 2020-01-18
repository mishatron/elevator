class Bundle {
  Map<String, Object> _mapa;

  Bundle() {
    _mapa = Map();
  }

  void putInt(String key, int value) {
    assert(key != null && value != null);
    _mapa[key] = value;
  }

  void putString(String key, String value) {
    assert(key != null && value != null);
    _mapa[key] = value;
  }

  void putBool(String key, bool value) {
    assert(key != null && value != null);
    _mapa[key] = value;
  }

  void putDynamic(String key, Object value) {
    assert(key != null && value != null);
    _mapa[key] = value;
  }

  int getInt(String key, {int defaultValue}) {
    assert(key != null);
    if (_mapa.containsKey(key) && _mapa[key] is int) return _mapa[key];
    return defaultValue;
  }

  String getString(String key, {String defaultValue}) {
    assert(key != null);
    if (_mapa.containsKey(key) && _mapa[key] is String) return _mapa[key];
    return null;
  }

  bool getBool(String key, {bool defaultValue}) {
    assert(key != null);
    if (_mapa.containsKey(key) && _mapa[key] is bool) return _mapa[key];
    return defaultValue;
  }

  T getDynamic<T>(String key, {T defaultValue}) {
    assert(key != null);
    if (_mapa.containsKey(key) && _mapa[key] is T) return _mapa[key];
    return defaultValue;
  }
}