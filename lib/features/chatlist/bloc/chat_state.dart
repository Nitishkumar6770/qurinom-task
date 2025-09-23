part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<Chatmodel> chats;

  ChatLoaded({required this.chats});
}

final class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}