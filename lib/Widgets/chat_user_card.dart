import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_messaging_app/Widgets/profile_dialog.dart';
import 'package:twitter_messaging_app/helper/date_util.dart';
import 'package:twitter_messaging_app/services/apis.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/personal_chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
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
                  user: widget.user,
                ),
              ));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                (_message != null) ? _message!.msg : widget.user.about,
                maxLines: 1,
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: (_message == null)
                  ? null
                  : _message!.read.isEmpty &&
                          _message!.fromId != APIs.currentUser.uid
                      ? const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.greenAccent,
                        )
                      : Text(
                          DateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.white54)),
            );
          },
        ),
      ),
    );
  }
}
