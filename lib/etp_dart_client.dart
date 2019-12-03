library etp_dart_client;

import 'package:etp_dart_client/models/codec_model.dart';
import 'package:etp_dart_client/models/decode_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';

const bodySplitter = '||';

String encodeEvent(String type, dynamic payload) {
  String data = "";
  if (payload) {
    data = Codec.marshal(payload);
  }
  return type + bodySplitter + data;
}

DecodeType decodeEvent(String data) {
  List<String> parts = data.split(bodySplitter);
  if (parts.length < 2) {
    throw "invalid message received. Splitter || expected";
  }
  var payload = '';
  if (parts[2] != null) {
    payload = Codec.unmarshal(parts[2]);
  }
  DecodeType obj = DecodeType(type: parts[0], payload: payload);
  return obj;
}

class EtpClient {
  final String url;
  IOWebSocketChannel _ws;

  EtpClient({this.url});

  void connect() {
    String url = this.url;
      IOWebSocketChannel ws = IOWebSocketChannel.connect(url);
      ws.stream.listen((data) {
        print('Data ' + '$data');
      }, onDone: () {
        print('done ' + '${ws.closeCode}');
      }, onError: (error) {
        print('error'+ '$error');
      });
      ws.sink.add('teste test');
      ws.sink.close(status.goingAway);
  }

  void closeSocket() {
    _ws.sink.close(status.goingAway);
  }

  Future<dynamic> emit(String type, dynamic payload) {
    return Future.error("Connection not initialized");
  }
}
