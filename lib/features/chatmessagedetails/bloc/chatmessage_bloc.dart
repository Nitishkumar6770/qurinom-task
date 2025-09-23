import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qurinorm_task/core/common/config/constants/url.dart';
import 'package:qurinorm_task/features/chatmessagedetails/data/models/chatmessage_model.dart';

part 'chatmessage_event.dart';
part 'chatmessage_state.dart';

class ChatmessageBloc extends Bloc<ChatmessageEvent, ChatmessageState> {
  ChatmessageBloc() : super(ChatmessageInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendChatMessage>(_onSendChatMessage);
  }

  FutureOr<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatmessageState> emit,
  ) async {
    emit(ChatMessagesLoading());
    try {
      final response = await http.get(
        Uri.parse('${Url.loadMessageEndpoint}/${event.chatId}'),
        headers: {'Authorization': 'Bearer ${event.token}'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final messages = data.map((e) => ChatMessage.fromJson(e)).toList();
        debugPrint(response.statusCode.toString());
        emit(ChatMessagesLoaded(messages));
      } else {
        debugPrint('Failed to load messages: =>>>> ${response.statusCode}');
        emit(ChatMessagesError('Failed to load messages'));
      }
    } catch (e) {
      emit(ChatMessagesError(e.toString()));
    }
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<ChatmessageState> emit,
  ) async {
    if (state is ChatMessagesLoaded) {
      final currentMessages = List<ChatMessage>.from(
        (state as ChatMessagesLoaded).messages,
      );

      try {
        final response = await http.post(
          Uri.parse(Url.sendMessageEndpoint),
          headers: {
            'Authorization': 'Bearer ${event.token}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'chatId': event.chatId,
            'senderId': event.senderId,
            'content': event.content,
            'messageType': 'text',
            'fileUrl': '',
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final json = jsonDecode(response.body);
          final newMessage = ChatMessage.fromJson(json);
          debugPrint('New message: $newMessage');
          currentMessages.insert(0, newMessage);
          emit(ChatMessagesLoaded(currentMessages));
        } else {
          debugPrint('Failed to send message: ${response.statusCode}');
          emit(ChatMessagesError('Failed to send message'));
        }
      } catch (e) {
        emit(ChatMessagesError(e.toString()));
      }
    }
  }
}
