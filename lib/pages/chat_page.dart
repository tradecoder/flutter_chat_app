import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import '../widgets/writer.dart';
import '../widgets/messages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();

    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      // print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // print(message);
      return;
    });
    fcm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat App'),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    color: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        const Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }),
        ],
      ),
      body: Container(
        color: null,
        child: Column(children: const [
          Expanded(child: Messages()),
          SizedBox(),
          Writer(),
        ]),
      ),
    );
  }
}
