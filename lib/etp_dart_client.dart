library etp_dart_client;

import 'package:etp_dart_client/handlers.dart';
import 'package:etp_dart_client/models/codec_model.dart';
import 'package:etp_dart_client/models/decode_model.dart';
import 'dart:io';

const bodySplitter = '||';

String encodeEvent(String type, dynamic payload) {
  String data = "data";
  if (payload != null) {
    data = Codec.marshal(payload);
  }
  String message = type + bodySplitter + '0' + bodySplitter + data;
  return message;
}

DecodeType decodeEvent(String data) {
  List<String> parts = data.split(bodySplitter);
  if (parts.length < 2) {
    throw "invalid message received. Splitter || expected";
  }
  if (parts.length > 2) {
    String str = parts[2];
    for (var i = 2; i < parts.length; i++) {
      str = str + bodySplitter + parts[i];
    }
  }
  dynamic payload;
  if (parts[2] != '') {
    payload = Codec.unmarshal(parts[2]);
  }
  DecodeType obj = DecodeType(type: parts[0], payload: payload);
  return obj;
}

class EtpClient {
  final String url;
  WebSocket _ws;
  Handlers handlers = Handlers();

  EtpClient({this.url});

  Function onConn = () => {};
  Function onDis = () => {};
  Function onErr = () => {};

  EtpClient onConnect(Function f) {
    onConn = f;
    return this;
  }

  EtpClient onDisconnect(Function f(dynamic event)) {
    onDis = f;
    return this;
  }

  EtpClient onError(Function f(Error e)) {
    onErr = f;
    return this;
  }

  EtpClient connect() {
    String url = this.url;
    WebSocket.connect(url.toString()).then((webSocket) {
      _ws = webSocket;
      onConn();
      webSocket.listen((payload) {
        var data = decodeEvent(payload);
         Function f = handlers.get(data.type);
         if(f!= null){
           f(data.payload);
         }
      }, onDone: () {
        onDis();
      });
    }).catchError((error) => onErr(error));
    return this;
  }

  void close() {
    if (_ws != null) {
      _ws.close(1000, 'test');
      _ws = null;
    }
    throw WebSocketException('WebSocket is NULL');
  }

  emit(String type, dynamic payload) {
    var test = new Map();
    test['Usrname'] = 'admin';
    test['Password'] = ['admin@123', 'qwe', 'rerer'];
    if (_ws != null) {
      String data = encodeEvent(type, payload);
      _ws.add(data);
    } else {
      throw ('connection not initialized');
    }
  }

  EtpClient on(String type, Function f) {
    handlers.on(type, f);
    return this;
  }

  EtpClient off(String type) {
    handlers.off(type);
    return this;
  }
}
