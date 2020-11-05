import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'firebase/auth.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'firebase/database.dart';

void main(List<String> arguments) {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  WebSocket socket;
  //-----------------------test-------------------------
  var result =
      authMethods.signInWithEmailAndPassword('hosein@gmail.com', '1234567');
  print(result);
//--------------------------start socket--------------------------------------
  const server_ip_address = '192.168.43.23';
  const server_port = 8592;

  uploadUserData(msg) {
    Map<String, dynamic> user = jsonDecode(msg);
    Map<String, String> userInfoMap = {
      "email": '${user['email']}',
      "name": '${user['name']}',
    };
    databaseMethods.uploadUserInfo(userInfoMap);
  }

  Future handleEvent(msg) async {
    Map<String, dynamic> event = jsonDecode(msg);
    if (event['type'] == 'Hello') {
      print('hi');
      socket.add(event['message']);
    } else if (event['type'] == 'AuthSignUp') {
      print(event['email']);
      var user = authMethods.signUpwithEmailAndPassword(
          '${event['email']}', '${event['password']}');
    } else if (event['type'] == 'DatabaseUpload') {
      uploadUserData(msg);
    } else if (event['type'] == 'AuthSignIn') {
      var result = authMethods.signInWithEmailAndPassword(
          '${event['email']}', '${event['password']}');
      print('object');
      print(result);
      socket.add(result);
    } else if (event['type'] == 'DataBaseGetUserByEmail') {
      var username =
          await databaseMethods.getUsersByUserEmail('${event['email']}');
      socket.add(username);
    }
  }

  // runZoned(() async {
  //   var server = await HttpServer.bind(server_ip_address, server_port);
  //   print('Server is listening ...');
  //   await for (var req in server) {
  //     if (req.uri.path == '/ws') {
  //       // Upgrade a HttpRequest to a WebSocket connection.
  //       socket = await WebSocketTransformer.upgrade(req);

  //       socket.listen(handleEvent);
  //     }
  //     ;
  //   }
  // }, onError: (e) {
  //   print('[Error] ${e.toString()}');
  //   if (socket != null) {
  //     socket.add('[Error] ${e.toString()}');
  //     socket.close();
  //   }
  // });
  //---------------------------------------------------------------------------
  // HttpServer.bind('192.168.43.22', 8004).then((HttpServer server) {
  //   print('[+]WebSocket listening at -- ws://192.168.43.22:8003/');
  //   server.listen((HttpRequest request) {
  //     WebSocketTransformer.upgrade(request).then((WebSocket ws) {
  //       ws.listen(
  //         (data) {
  //           print(data.toString());
  //           print(
  //               '\t\t${request?.connectionInfo?.remoteAddress} -- ${Map<String, String>.from(json.decode(data))}');
  //           Timer(Duration(seconds: 1), () {
  //             if (ws.readyState == WebSocket.open)
  //               // checking connection state helps to avoid unprecedented errors
  //               ws.add(json.encode({
  //                 'data': 'from server at ${DateTime.now().toString()}',
  //               }));
  //           });
  //         },
  //         onDone: () => print('[+]Done :)'),
  //         onError: (err) => print('[!]Error -- ${err.toString()}'),
  //         cancelOnError: true,
  //       );
  //     }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  //   }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  // }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}
