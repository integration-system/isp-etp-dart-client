library etp_dart_client;

import 'package:etp_dart_client/handlers.dart';
import 'package:etp_dart_client/models/codec_model.dart';
import 'package:etp_dart_client/models/decode_model.dart';
import 'dart:io';

class Options {
  Map<String, dynamic> params;
  Codec codec;

  Options({this.params, this.codec});
}

const bodySplitter = '||';

String encodeGetParams(Map<String, dynamic> params) {
  var url = params.entries
      .map((kv) =>
          "${Uri.decodeComponent(kv.key)}=${Uri.encodeComponent(kv.value)}")
      .join("&");
  return url;
}

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
  Options options;
  WebSocket _ws;
  Handlers handlers = Handlers();

  EtpClient({this.url, this.options});

  Function onConn = () => {};
  Function onDis = () => {};
  Function onErr = () => {};

  EtpClient onConnect(Function f) {
    onConn = f;
    return this;
  }

  EtpClient onDisconnect(Function f) {
    onDis = f;
    return this;
  }

  EtpClient onError(Function f) {
    onErr = f;
    return this;
  }

  EtpClient connect() {
    String url = this.url;
    if (options != null && options.params.isNotEmpty) {
      url = url + '?' + encodeGetParams(options.params);
    }
    WebSocket.connect(url.toString()).then((webSocket) {
      _ws = webSocket;
      onConn();
      webSocket.listen((payload) {
        var data = decodeEvent(payload);
        Function f = handlers.get(data.type);
        if (f != null) {
          f(data.payload);
        }
      }, onDone: () {
        onDis();
      });
    }).catchError((error) => onErr(error));
    return this;
  }

  void close(num code, String reason) {
    if (_ws != null) {
      _ws.close(code, reason);
      _ws = null;
    }
  }

  emit(String type, dynamic payload) {
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
