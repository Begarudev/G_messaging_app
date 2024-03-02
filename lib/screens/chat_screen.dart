import 'package:flutter/material.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';

import '../Widgets/chat_user_card.dart';
import '../main.dart';

class ChatScreen extends StatelessWidget {
  final List<ChatUser> list;
  const ChatScreen({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: mq.height * .01),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ChatUserCard(
          user: list[index],
        );
      },
    );
  }
}
