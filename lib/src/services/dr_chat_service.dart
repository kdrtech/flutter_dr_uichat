import 'package:flutter_dr_uichat/flutter_dr_uichat.dart';

class DRChatService {
  DRChatService._privateConstructor();
  static final DRChatService chatService = DRChatService._privateConstructor();

  Function(DRUIChatMessage)? onAddSender;
  Function(DRUIChatMessage)? onAddReceiver;
  Function(List<DRUIChatUser> messageList)? onSetMessage;
  Function(List<DRUIChatMessage> messageList)? onSetChatMessage;
  Function(String)? onMessage;
  Function(DRUIChatUser chatUser)? onDeleteMessage;

  Future Function()? onMessageRefresh;
  Future Function()? onMessageLoadMore;

  Function(DRUIChatUser)? onChatLoaded;
  Function(String)? onMessageLoaded;

  List<DRUIChatUser>? messageList = [];
  List<DRUIChatMessage>? chatMessageList = [];

  void addSender(
    DRUIChatMessage chMessage,
  ) {
    if (onAddSender != null) {
      onAddSender!(chMessage);
    }
  }

  void addReceiver(
    DRUIChatMessage chMessage,
  ) {
    if (onAddReceiver != null) {
      onAddReceiver!(chMessage);
    }
  }

  void setMessageLists(List<DRUIChatUser> messageList) {
    if (onSetMessage != null) {
      this.messageList = messageList;
      onSetMessage!(messageList);
    }
  }

  void setChatMessageLists(List<DRUIChatMessage> chatMessageList) {
    if (onSetChatMessage != null) {
      this.chatMessageList = chatMessageList;
      onSetChatMessage!(chatMessageList);
    }
  }
}
