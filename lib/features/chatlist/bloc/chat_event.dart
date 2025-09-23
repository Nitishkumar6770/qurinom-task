part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

final class LoadChats extends ChatEvent {
  final String userId;
  final String token;

  LoadChats({required this.userId, required this.token});
}
