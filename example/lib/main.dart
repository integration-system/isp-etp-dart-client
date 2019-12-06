import 'package:etp_dart_client/etp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:etp_dart_client/models/options_model.dart';

void main() {
  var test = new Map();
  test['Usrname'] = 'admin';
  test['Password'] = ['admin@123', 'qwe', 'rerer'];
  EtpClient channel = EtpClient(
      url: 'wss://echo.websocket.org',
      options: Options(
          params: {'token': '1123123123', 'test_params': 'test_string'}));
  channel.onConnect(() {
    print('connect onConnect');
    channel.emit('test_event', test);
  });
  channel.on('test_event', (test) {
    print('test_event => $test');
  });

  channel.connect();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello )'),
        ),
      ),
    );
  }
}
