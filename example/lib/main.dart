import 'package:etp_dart_client/etp_dart_client.dart';
import 'package:flutter/material.dart';

void main() {
  var test = new Map();
  test['Usrname'] = 'admin';
  test['Password'] = ['admin@123', 'qwe', 'rerer'];
  EtpClient channel = EtpClient(url: 'wss://echo.websocket.org');
  channel.onConnect(() {
    print('connect onConnect');
    channel.emit('test_event', test);
  });
  channel.on('test_event', (test) {
    print('test_event => $test');
  });

  channel.connect();
  channel.close();
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
