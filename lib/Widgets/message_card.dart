import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:twitter_messaging_app/helper/date_util.dart';

import '../helper/dialogs.dart';
import '../main.dart';
import '../models/message.dart';
import '../services/apis.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.currentUser.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _tealMessage(),
    );
  }

  Widget _tealMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              // margin: EdgeInsets.symmetric(
              //     horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(216, 105, 224, 252)),
                color: const Color.fromARGB(42, 105, 224, 252),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(mq.width * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.message.type == Type.text
                      ? Text(
                          softWrap: true,
                          widget.message.msg,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white70),
                        )
                      : GestureDetector(
                          onTap: () => showDialog(
                              useSafeArea: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      alignment: Alignment.topLeft,
                                      width: mq.width * 0.6,
                                      imageUrl: widget.message.msg,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.image,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Icon(
                                  Icons.image,
                                  size: 70,
                                )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(
                                        duration: const Duration(seconds: 2)),
                                alignment: Alignment.topLeft,
                                width: mq.width * 0.6,
                                imageUrl: widget.message.msg,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.image,
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                        ),
                  Text(
                    DateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(fontSize: 10, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              // margin: EdgeInsets.symmetric(
              //     horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(216, 137, 252, 105)),
                color: const Color.fromARGB(42, 132, 252, 105),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(mq.width * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.message.type == Type.text
                      ? Text(
                          softWrap: true,
                          widget.message.msg,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white70),
                        )
                      : GestureDetector(
                          onTap: () => showDialog(
                              useSafeArea: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      alignment: Alignment.topLeft,
                                      width: mq.width * 0.6,
                                      imageUrl: widget.message.msg,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.image,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Icon(
                                  Icons.image,
                                  size: 70,
                                )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(
                                        duration: const Duration(seconds: 2)),
                                alignment: Alignment.topLeft,
                                useOldImageOnUrlChange: true,
                                width: mq.width * 0.6,
                                imageUrl: widget.message.msg,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.image,
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                        ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateUtil.getFormattedTime(
                            context: context, time: widget.message.sent),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white54),
                      ),
                      Icon(
                        size: 12,
                        Icons.done_all_rounded,
                        color: (widget.message.read.isNotEmpty)
                            ? Colors.cyanAccent[400]
                            : Colors.white54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              if (widget.message.type == Type.text)
                _OptionItem(
                    icon: const Icon(Icons.copy_all_rounded,
                        color: Colors.teal, size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);

                        Dialogs.showSnackBar(context, 'Text Copied!');
                      });
                    }),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.teal, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.white54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.teal),
                  name:
                      'Sent At: ${DateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${DateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.teal,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.teal, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.teal, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
