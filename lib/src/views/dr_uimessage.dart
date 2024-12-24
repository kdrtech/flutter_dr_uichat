import 'package:flutter/material.dart';
import 'package:flutter_dr_uichat/flutter_dr_uichat.dart';
import 'package:flutter_pull_up_down_refresh/flutter_pull_up_down_refresh.dart';

import '../services/dr_chat_config.dart';
import '../utils/string_extension.dart';

class DRUIMessage extends StatefulWidget {
  const DRUIMessage({super.key});

  @override
  _DRUIMessage createState() => _DRUIMessage();
}

class _DRUIMessage extends State<DRUIMessage> {
  bool isBottom = false;
  bool isRefresh = true;
  bool isFirst = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DRChatService.chatService.onMessageLoaded != null) {
        isFirst = true;
        DRChatService.chatService.messageList = [];
        DRChatService.chatService.onMessageLoaded!("loading");
      }
    });
    super.initState();
    DRChatService.chatService.onSetMessage = (list) {
      setState(() {
        DRChatService.chatService.messageList = list;
      });
    };
  }

  Future pullRefresh() async {
    if (DRChatService.chatService.onMessageRefresh != null) {
      await DRChatService.chatService.onMessageRefresh!();
    }
  }

  Future onReload() async {
    if (DRChatService.chatService.onMessageLoadMore != null) {
      await DRChatService.chatService.onMessageLoadMore!();
    }
    setState(() {
      isBottom = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (DRUIChatBubble.baseContext != null) {
          DRChatService.chatService.messageList = [];
          DRChatService.chatService.chatMessageList = [];
          DRUIChatBubble.show(DRUIChatBubble.baseContext!);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(DRChatConfig.config.titleMessage),
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
        body: Center(
          child: FlutterPullUpDownRefresh(
            scrollController: ScrollController(),
            showRefreshIndicator: true,
            refreshIndicatorColor: Colors.red,
            isLoading: false,
            loadingColor: Colors.red,
            loadingBgColor: Colors.grey.withAlpha(100),
            isBootomLoading: isBottom,
            bottomLoadingColor: Colors.green,
            scaleBottomLoading: 0.6,
            onRefresh: () async {
              //Start refresh
              await pullRefresh();
              //End refresh
            },
            onAtBottom: (status) {
              if (status) {
                if (!isBottom) {
                  setState(() {
                    isBottom = true;
                    onReload();
                  });
                }
              }
            },
            child: DRChatService.chatService.messageList!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: DRChatService.chatService.messageList?.length,
                    itemBuilder: (context, n) {
                      return InkWell(
                        onTap: () {
                          if (DRUIChatBubble.baseContext != null) {
                            Navigator.push(
                              DRUIChatBubble.baseContext!,
                              MaterialPageRoute(
                                  builder: (context) => DRUIChat(DRChatService
                                      .chatService.messageList![n])),
                            );
                          }
                        },
                        child: getChatItem(
                            DRChatService.chatService.messageList![n], n),
                      );
                    },
                  )
                : isFirst || DRChatService.chatService.messageList!.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: const Text("No message"),
                      ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, int index, DRUIChatUser item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  DRChatService.chatService.messageList?.removeAt(index);
                  if (DRChatService.chatService.onDeleteMessage != null) {
                    DRChatService.chatService.onDeleteMessage!(item);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getChatItem(DRUIChatUser user, int index) {
    return Dismissible(
      key: ValueKey(user),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        confirmDelete(context, index, user);
        return false; // Prevent immediate dismissal
      },
      // onDismissed: (direction) {
      //   //deleteItem(index);
      // },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        color: Colors.white,
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Container(
            width: 70,
            height: 70,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              user.photo != ""
                  ? user.photo
                  : 'https://picsum.photos/seed/picsum/200/300',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  Text(
                    user.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5, right: 10),
            alignment: Alignment.centerRight,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  user.createdAt != ""
                      ? StringExtension.displayTimeAgoFromTimestamp(
                          "2024-09-12T20:42:19Z")
                      : "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                Visibility(
                  visible: user.totalMessage != "" ? true : false,
                  child: Container(
                    alignment: Alignment.center,
                    width: 25,
                    height: 25,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
