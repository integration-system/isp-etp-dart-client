import 'package:etp_dart_client/etp_dart_client.dart';

void main() {
  var test = new Map();
  test['Usrname'] = 'admin';
  test['Password'] = 'qwerty';
  EtpClient channel = EtpClient(
      url: 'wss://echo.websocket.org',
      options: Options(params: {'token': 'token'}));
  channel.onConnect(() {
    print('connect');
    channel.emit('test_event', test);
  });
  channel.onError((error) {
    print('$error');
  });
  channel.onDisconnect(() {
    print('close event');
  });

  channel.on('test_event', (test) {
    print('test_event => $test');
  });
  channel.connect();
}
