part of 'chatmessage_bloc.dart';

@immutable
abstract class ChatmessageState {}

final class ChatmessageInitial extends ChatmessageState {}

class ChatMessagesLoading extends ChatmessageState {}
class ChatMessagesLoaded extends ChatmessageState {
  final List<ChatMessage> messages;
  ChatMessagesLoaded(this.messages);
}
class ChatMessagesError extends ChatmessageState {
  final String error;
  ChatMessagesError(this.error);
}
