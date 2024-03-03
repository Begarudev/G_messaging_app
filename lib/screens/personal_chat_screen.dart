import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_messaging_app/Widgets/message_card.dart';
import 'package:twitter_messaging_app/helper/date_util.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';
import 'package:twitter_messaging_app/screens/view_profile_screen.dart';
import 'package:twitter_messaging_app/services/riverpod.dart';

import '../main.dart';
import '../models/message.dart';
import '../services/apis.dart';

class PersonalChatScreen extends ConsumerStatefulWidget {
  final ChatUser user;
  const PersonalChatScreen({super.key, required this.user});

  @override
  ConsumerState<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends ConsumerState<PersonalChatScreen> {
  final _textController = TextEditingController();
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user),
              )),
          child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: mq.height * .05,
                      height: mq.height * .05,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  const Gap(
                    10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white70),
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'online'
                                : DateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : DateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white60),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
      body: GestureDetector(
        onTapDown: (details) => ref
            .watch(emojiSelectorStateProvider.notifier)
            .update((state) => false),
        onTap: () => ref
            .watch(emojiSelectorStateProvider.notifier)
            .update((state) => false),
        child: StreamBuilder(
            stream: APIs.getAllMessages(widget.user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const SizedBox();
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  log(_list.toString());
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_list.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.all(mq.height * 0.01),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            },
                          ),
                        )
                      else
                        const Expanded(
                          child: Center(
                            child: DefaultTextStyle(
                              style: TextStyle(),
                              child: Text(
                                "Say Hi!, 👋",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ChatInput(
                        textController: _textController,
                        list: _list,
                        user: widget.user,
                      )
                    ],
                  );
              }
            }),
      ),
    );
  }

  // Widget _chatInput(TextEditingController textController) {
  //   return
  // }
}

class ChatInput extends ConsumerStatefulWidget {
  final List list;
  final ChatUser user;
  final TextEditingController textController;

  const ChatInput(
      {super.key,
      required this.textController,
      required this.list,
      required this.user});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    bool showEmoji = ref.watch(emojiSelectorStateProvider);
    return Column(
      children: [
        if (_isUploading)
          Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.3),
              alignment: Alignment.centerRight,
              child: const Icon(
                color: Colors.tealAccent,
                Icons.cloud_upload,
                size: 50,
              ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                  color: Colors.white,
                  angle: 180,
                  duration: const Duration(seconds: 1))),
        Padding(
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
                            FocusScope.of(context).unfocus();
                            // setState(() => _showEmoji = !_showEmoji);
                            ref
                                .watch(emojiSelectorStateProvider.notifier)
                                .update((state) => true);
                          },
                          icon: const Icon(Icons.emoji_emotions,
                              /*color: Colors.blueAccent,*/ size: 25)),

                      Expanded(
                          child: TextField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        controller: widget.textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (showEmoji) {
                            ref
                                .watch(emojiSelectorStateProvider.notifier)
                                .update((state) => false);
                          }
                          // setState(() => _showEmoji = !_showEmoji);
                        },
                        decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(),
                            border: InputBorder.none),
                      )),

                      //pick image from gallery button
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();

                            // Picking multiple images
                            final List<XFile> images =
                                await picker.pickMultiImage(imageQuality: 70);

                            // uploading & sending image one by one
                            for (var i in images) {
                              log('Image Path: ${i.path}');
                              // ref
                              //     .watch(imageUploadStateProvider.notifier)
                              //     .update((state) => true);
                              setState(() => _isUploading = true);
                              await APIs.sendChatImage(
                                  widget.user, File(i.path));
                            }
                            setState(() => _isUploading = false);

                            // (value) => ref
                            //     .watch(imageUploadStateProvider.notifier)
                            //     .update((state) => false);
                          },
                          icon: const Icon(Icons.image,
                              /*color: Colors.blueAccent,*/ size: 26)),

                      //take image from camera button
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();

                            // Pick an image
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            if (image != null) {
                              log('Image Path: ${image.path}');
                              setState(() => _isUploading = true);

                              await APIs.sendChatImage(
                                  widget.user, File(image.path));
                            }
                            setState(() => _isUploading = false);
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
                  if (widget.textController.text.isNotEmpty) {
                    if (widget.list.isEmpty) {
                      //on first message (add user to my_user collection of chat user)
                      APIs.sendMessage(
                          widget.user, widget.textController.text, Type.text);
                    } else {
                      //simply send message
                      APIs.sendMessage(
                          widget.user, widget.textController.text, Type.text);
                    }
                    widget.textController.text = '';
                  }
                },
                minWidth: 0,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 5, left: 10),
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
        ),
        if (showEmoji)
          SizedBox(
            height: mq.height * .35,
            child: EmojiPicker(
              textEditingController: widget.textController,
              config: const Config(
                bgColor: Colors.transparent,
                columns: 8,
                iconColorSelected: Colors.cyanAccent,
                indicatorColor: Colors.cyanAccent,
                backspaceColor: Colors.redAccent,
              ),
            ),
          )
      ],
    );
  }
}
