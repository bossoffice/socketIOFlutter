import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  onPressed() async {
    try {
      socket = IO.io(
          'http://192.168.1.102:3000/',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      socket.connect();
      socket.onConnect((_) {
        log('socket io status : connected');
      });
      socket.emit('chat', 'nice');

      var uri = Uri.parse("http://192.168.1.102:3000/");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = response.body;
        log("success $body");
      }
    } catch (e) {
      log("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Hello World",
              textAlign: TextAlign.center,
            ),
            TextButton(onPressed: onPressed, child: const Text("Hi"))
          ],
        ),
      ),
    );
  }
}
