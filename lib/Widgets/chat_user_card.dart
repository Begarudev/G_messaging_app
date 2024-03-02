import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../screens/personal_chat_screen.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          // context.push('/personalChatScreen');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PersonalChatScreen(
                  user: user,
                ),
              ));
        },
        child: ListTile(
          leading: ClipOval(
            child: CachedNetworkImage(
              width: mq.width * 0.099,
              imageUrl: user.image,
              placeholder: (context, url) =>
                  const Icon(CupertinoIcons.person).animate().shimmer(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(user.name),
          subtitle: Text(
            user.about,
            maxLines: 1,
          ),
          trailing: Text(user.lastActive,
              style: const TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
