class DRUIChatUser {
  int id;
  String name;
  String photo;
  String message;
  String createdAt;
  String totalMessage;
  DRUIChatUser({
    required this.id,
    required this.name,
    this.photo = "",
    this.message = "",
    this.createdAt = "",
    this.totalMessage = "",
  });
}
