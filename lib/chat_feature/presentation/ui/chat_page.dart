import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _textController;
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _channel = IOWebSocketChannel.connect('ws://localhost:3000/');
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lets Chat"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return ListView(
                    children: [
                      ListTile(
                        title: Text('${snapshot.data}'),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  print('Submitted');
                  _channel.sink.add(value);
                  _textController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
