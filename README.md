
# etp_dart_client

- Simple event transport protocol client for Dart for [server](https://github.com/integration-system/isp-etp-go).
- Design API inspired by [socket.io](https://pub.dev/packages/socket_io_client).
- event payload marshaling/unmarshaling to/from `json`

```dart
import 'package:etp_dart_client/etp_dart_client.dart';

void main() {
  var test = new Map();
  test['Usrname'] = 'admin';
  test['Password'] = 'qwerty';
  EtpClient channel = EtpClient(
      url: 'wss://echo.websocket.org',
      options: Options(
      params: {'token': 'token'}//will add to GET params in initial request
      )); 
  channel.onConnect(() { //call every time when connection successfully established
    print('connect');
    channel.emit('test_event', test);
  });
  channel.onError((error) {  //call every time when error occurred while connecting or data deserializing
    print('$error');
  });
  channel.onDisconnect(() { //call every time when connection could not established or closed
    print('close event');
  });

  channel.on('test_event', (test) { //subscribe to any custom events
    print('test_event => $test');
  });
  channel.connect();  // call to open connection

channel.close(); //call to close connection, you can provides two params: num code, String reason
}

```
