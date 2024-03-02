import 'package:flutter/material.dart';
import 'package:twitter_messaging_app/helper/date_util.dart';

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
    return APIs.currentUser.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
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
                  Text(
                    softWrap: true,
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
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
                  Text(
                    softWrap: true,
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
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
}
