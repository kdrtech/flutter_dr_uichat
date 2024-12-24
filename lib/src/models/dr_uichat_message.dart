class DRUIChatMessage {
  int id;
  bool isSender;
  String name;
  String photo;
  String message;
  String createdAt;

  DRUIChatMessage(
      {required this.id,
      required this.name,
      required this.isSender,
      this.photo = "",
      this.message = "",
      this.createdAt = ""});
}
