import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Writer extends StatefulWidget {
  const Writer({super.key});

  @override
  State<Writer> createState() => _WriterState();
}

class _WriterState extends State<Writer> {
  final _writeController = TextEditingController();
  var _newMessage = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference chats = FirebaseFirestore.instance.collection('chat');
    Future<void> sendMessage() async {
      FocusScope.of(context).unfocus();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (_newMessage.isEmpty) {
        return;
      }
      return chats.add({
        'text': _newMessage,
        'createdAt': Timestamp.now(),
        'uid': uid,
        'username': userData['username'],
        'userImage': userData['imageUrl'],
      }).then((value) {
        _writeController.clear();
        _newMessage = "";
      }).catchError((err) {
        return err;
      });
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _writeController,
              decoration: const InputDecoration(labelText: 'Type here'),
              onChanged: (inputText) {
                setState(() {
                  _newMessage = inputText;
                });
              },
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
