import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:qurinorm_task/core/common/config/constants/url.dart';
import 'package:qurinorm_task/features/chatlist/data/models/chatmodel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
  }

  FutureOr<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final response = await http.get(
        Uri.parse('${Url.chatListEndpoint}/${event.userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${event.token}',
        },
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final chats = data.map((json) => Chatmodel.fromJson(json)).toList();
        emit(ChatLoaded(chats: chats));
      } else {
        emit(ChatError(error: 'Error fetching chats: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }
}
