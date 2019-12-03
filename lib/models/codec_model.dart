import 'dart:convert';
class Codec{
  static String marshal(dynamic data) {
  return jsonEncode(data);
  }
  static dynamic unmarshal(String data) {
  return jsonDecode(data);
  }
}