class Handlers {
  Map<String,Function> subs = {};

  void on(String type, Function f(dynamic data)) {
    subs[type] = f;
  }

  void off(String type) {
    subs.remove(type);
  }

  Function get(String type) {
    Function h = subs[type];
    return h;
  }
}
