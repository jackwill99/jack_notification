class NotificationMessage {
  const NotificationMessage({
    this.data,
    this.title,
    this.body,
  });

  final Map<String, dynamic>? data;
  final String? title;
  final String? body;
}
