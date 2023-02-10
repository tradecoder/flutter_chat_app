import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMine;
  final String username;
  final String userImage;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.username,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMine ? Colors.black12 : Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: !isMine
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                  bottomRight: isMine
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                ),
              ),
              width: 180,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMine
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMine
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                    textAlign: isMine ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -5,
          left: isMine ? 185 : null,
          right: isMine ? null : 185,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
