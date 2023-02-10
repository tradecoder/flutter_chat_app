import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final messages = chatSnapshot.hasData ? chatSnapshot.data!.docs : [];
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (ctx, i) => ChatBubble(
              message: messages[i]['text'],
              isMine: messages[i]['uid'] == uid,
              username: messages[i]['username'],
              userImage: messages[i]['userImage'],
              key: ValueKey(messages[i].id),
            ),
          );
        });
  }
}
