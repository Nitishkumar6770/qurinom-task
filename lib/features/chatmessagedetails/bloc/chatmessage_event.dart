part of 'chatmessage_bloc.dart';

@immutable
abstract class ChatmessageEvent {}

class LoadChatMessages extends ChatmessageEvent {
  final String chatId;
  final String token;

  LoadChatMessages({required this.chatId, required this.token});
}

class SendChatMessage extends ChatmessageEvent {
  final String chatId;
  final String token;
  final String senderId; 
  final String content;

  SendChatMessage({
    required this.chatId,
    required this.token,
    required this.senderId,
    required this.content,
  });
}