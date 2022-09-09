import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  late String message;

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
            stream: channel.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                snapshot.hasData ? '${snapshot.data}' : '',
                style: Theme.of(context).textTheme.headline6,
              );
            },
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'write something'),
            onChanged: (value) {
              message = value;
            },
          ),
          ElevatedButton(
              onPressed: () {
                channel.sink.add(message);
              },
              child: const Text('Send')),
        ],
      ),
    );
  }
}
