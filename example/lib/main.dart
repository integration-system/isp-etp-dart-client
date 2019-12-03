import 'package:etp_dart_client/etp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';
void main(){
  EtpClient channel = EtpClient(url:'wss://echo.websocket.org');
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
