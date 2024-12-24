class DRChatConfig {
  DRChatConfig._privateConstructor();
  String titleMessage = "Messages";
  static final DRChatConfig config = DRChatConfig._privateConstructor();
  void set({
    String titleMessage = "Messages",
  }) {
    this.titleMessage = titleMessage;
  }
}
