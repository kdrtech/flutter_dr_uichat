import 'package:flutter/material.dart';
import 'package:flutter_dr_uichat/src/services/dr_chat_service.dart';
import 'package:flutter_pull_up_down_refresh/flutter_pull_up_down_refresh.dart';

import '../../flutter_dr_uichat.dart';
import '../utils/date_format.dart';
import '../utils/dr_logger.dart';
import '../utils/string_extension.dart';

class DRUIChat extends StatefulWidget {
  DRUIChatUser? druiChatUser;
  DRUIChat(this.druiChatUser, {super.key});
  @override
  _DRUIChat createState() => _DRUIChat();
}

class _DRUIChat extends State<DRUIChat> {
  TextEditingController? textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    DRChatService.chatService.onAddSender = (dRUIChatMessage) {
      setState(() {
        DRChatService.chatService.chatMessageList?.add(dRUIChatMessage);
        _scrollDown();
      });
    };
    DRChatService.chatService.onAddReceiver = (dRUIChatMessage) {
      setState(() {
        DRChatService.chatService.chatMessageList?.add(dRUIChatMessage);
        _scrollDown();
      });
      //DrLogger.logger.log("onAddReceiver", message.message);
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DRChatService.chatService.onChatLoaded != null &&
          widget.druiChatUser != null) {
        DRChatService.chatService.onChatLoaded!(widget.druiChatUser!);
      }
    });
    super.initState();
    DRChatService.chatService.onSetChatMessage = (list) {
      setState(() {
        DRChatService.chatService.chatMessageList = list;
      });
    };
  }

  void onSend(String text) {
    if (text.trim() == "") {
      return;
    }
    if (DRChatService.chatService.onMessage != null) {
      DRChatService.chatService.onMessage!(textEditingController!.text);
    }
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                widget.druiChatUser != null
                    ? widget.druiChatUser!.photo != ""
                        ? widget.druiChatUser!.photo
                        : 'https://picsum.photos/seed/picsum/200/300'
                    : 'https://picsum.photos/seed/picsum/200/300',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: widget.druiChatUser != null
                    ? Text(widget.druiChatUser!.name)
                    : const Text("")),
          ],
        ),
        backgroundColor: Colors.white,
        //actions: [const Text("action")],
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterPullUpDownRefresh(
              scrollController: _controller,
              showRefreshIndicator: true,
              refreshIndicatorColor: Colors.red,
              isLoading: false,
              loadingColor: Colors.red,
              loadingBgColor: Colors.grey.withAlpha(100),
              isBootomLoading: false,
              bottomLoadingColor: Colors.green,
              scaleBottomLoading: 0.6,
              onRefresh: () async {
                //Start refresh
                //await pullRefresh();
                //End refresh
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: DRChatService.chatService.chatMessageList?.length,
                itemBuilder: (context, n) {
                  DRUIChatMessage druiChatMessage =
                      DRChatService.chatService.chatMessageList![n];
                  bool isSender = druiChatMessage.isSender;

                  if (!isSender) {
                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                        top: 5,
                        left: 5,
                        bottom: 5,
                      ),
                      child: Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // To avoid occupying unnecessary space
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(druiChatMessage
                                                .photo !=
                                            ""
                                        ? druiChatMessage.photo
                                        : 'https://picsum.photos/seed/picsum/200/300'),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  constraints: const BoxConstraints(
                                      maxWidth:
                                          200), // Max width for message container
                                  decoration: BoxDecoration(
                                    color: isSender
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    druiChatMessage.message,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: isSender
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      druiChatMessage.createdAt != ""
                                          ? DateExtension().getDate(
                                              DateTime.parse(
                                                  druiChatMessage.createdAt),
                                              format: 'yy-M-d, HH:MM a')
                                          : ""),
                                ),
                              ]),
                        ),
                      ),
                    );
                  }
                  return Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      bottom: 5,
                    ),
                    child: Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 5.0),
                        child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // To avoid occupying unnecessary space
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    druiChatMessage.createdAt != ""
                                        ? DateExtension().getDate(
                                            DateTime.parse(
                                                druiChatMessage.createdAt),
                                            format: 'yy-M-d, HH:MM a')
                                        : ""),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                constraints: const BoxConstraints(
                                    maxWidth:
                                        200), // Max width for message container
                                decoration: BoxDecoration(
                                  color:
                                      isSender ? Colors.blue : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  druiChatMessage.message,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: isSender
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(druiChatMessage
                                              .photo !=
                                          ""
                                      ? druiChatMessage.photo
                                      : 'https://picsum.photos/seed/picsum/200/300'),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );

                  // return Text(DateExtension()
                  //     .getDate(DateTime.parse("2024-09-12T20:42:19Z").toUtc()));
                },
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      print(value);
                      onSend(value);
                      textEditingController?.text = "";
                    },
                    controller: textEditingController,
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 69, 69, 69), width: 0.0),
                      ),
                      hintText: "Type message here",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
