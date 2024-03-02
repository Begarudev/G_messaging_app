import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:twitter_messaging_app/Widgets/message_card.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';

import '../main.dart';
import '../models/message.dart';
import '../services/apis.dart';

class PersonalChatScreen extends StatefulWidget {
  final ChatUser user;
  const PersonalChatScreen({super.key, required this.user});

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final _textController = TextEditingController();
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                width: mq.width * 0.099,
                imageUrl: widget.user.image,
                placeholder: (context, url) =>
                    const Icon(CupertinoIcons.person).animate().shimmer(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const Gap(
              10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const Text(
                  "Last seen not Available",
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                )
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];
                      log(_list.toString());
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.all(mq.height * 0.01),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: DefaultTextStyle(
                            style: TextStyle(),
                            child: Text(
                              "Say Hi!, 👋",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }
                  }
                }),
          ),
          _chatInput(_textController)
        ],
      ),
    );
  }

  Widget _chatInput(TextEditingController textController) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        // FocusScope.of(context).unfocus();
                        // setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          /*color: Colors.blueAccent,*/ size: 25)),

                  Expanded(
                      child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        // final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        // final List<XFile> images =
                        // await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        // for (var i in images) {
                        //   log('Image Path: ${i.path}');
                        //   setState(() => _isUploading = true);
                        //   await APIs.sendChatImage(widget.user, File(i.path));
                        //   setState(() => _isUploading = false);
                        // }
                      },
                      icon: const Icon(Icons.image,
                          /*color: Colors.blueAccent,*/ size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        // final ImagePicker picker = ImagePicker();
                        //
                        // // Pick an image
                        // final XFile? image = await picker.pickImage(
                        //     source: ImageSource.camera, imageQuality: 70);
                        // if (image != null) {
                        //   log('Image Path: ${image.path}');
                        //   setState(() => _isUploading = true);
                        //
                        //   await APIs.sendChatImage(
                        //       widget.user, File(image.path));
                        //   setState(() => _isUploading = false);
                        // }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          /*color: Colors.blueAccent,*/ size: 26)),

                  //adding some space
                  Gap(mq.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendMessage(
                      widget.user, textController.text /*, Type.text*/);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, textController.text /*, Type.text*/);
                }
                textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            // color: Colors.green,
            child: const Icon(Icons.send_outlined,
                    color: Colors.greenAccent, size: 40)
                .animate(
                  autoPlay: true,
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(duration: const Duration(milliseconds: 1000)),
          )
        ],
      ),
    );
  }
}
