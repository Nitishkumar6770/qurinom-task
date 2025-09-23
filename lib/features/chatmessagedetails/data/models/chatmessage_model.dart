class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final String messageType;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      senderId: json['senderId'],
      content: json['content'],
      messageType: json['messageType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
