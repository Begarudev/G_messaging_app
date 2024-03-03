import 'package:flutter/material.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';
import 'package:twitter_messaging_app/screens/splash_screen.dart';

import '../Widgets/chat_user_card.dart';
import '../main.dart';
import '../services/apis.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];

    return StreamBuilder(
      stream: APIs.getAllUsers(),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(child: SplashScreen());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            // list.sort(
            //   (a, b) => b.lastActive.compareTo(a.lastActive),
            // );
            if (list.isNotEmpty) {
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
            } else {
              return const Text("No Connections Found");
            }
        }
      },
    );
  }
}
