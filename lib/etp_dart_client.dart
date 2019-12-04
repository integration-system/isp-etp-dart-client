library etp_dart_client;

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
  print('Сообщение $message');
  return message;
}

DecodeType decodeEvent(String data) {
  List<String> parts = data.split(bodySplitter);
  if (parts.length < 2) {
    throw "invalid message received. Splitter || expected";
  }
  print('Parts' + '${parts[2]}');
  var payload = '';
  if (parts[2] != null) {
    payload = Codec.unmarshal(parts[2]);
    print('UNMARSHAL $payload');
  }
  //print('DECODE ${parts[0]} $payload');
  DecodeType obj = DecodeType(type: parts[0], payload: payload);
  return obj;
}

class EtpClient {
  final String url;
  WebSocket _ws;

  EtpClient({this.url});

  void connect() {
    String url = this.url;
    WebSocket.connect(url.toString()).then((webSocket) {
      print('connect');
      _ws = webSocket;
      //webSocket.add('test string');
      webSocket.listen((data) {
        print('Data ' + '$data');
        decodeEvent('12||0||${{"Usrname":"admin"}}');
      }, onDone: () {
        print('done');
      }, onError: (error) {
        print('error' + '$error');
      });
    }).catchError((error) => print('error $error'));
  }

  void close() {
    if (_ws != null) {
      _ws.close(1000, 'test');
      _ws = null;
    }
    throw ('WebSocket is NULL');
  }

  emit(String type, dynamic payload) {
    var test = new Map();
    test['Usrname'] = 'admin';
    test['Password'] = ['admin@123','qwe','rerer'];
    if (_ws != null) {
      String data = encodeEvent(type, test);
    } else {
      String data = encodeEvent(type, test);
    }
  }
}
