import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinorm_task/features/chatmessagedetails/bloc/chatmessage_bloc.dart';
import 'package:qurinorm_task/features/chatmessagedetails/presentation/chatdetailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/chat_bloc.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late String currentUserId;
  late String token;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchChats();
  }

  Future<void> _loadUserAndFetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId') ?? '';
    token = prefs.getString('token') ?? '';

    if (currentUserId.isNotEmpty && token.isNotEmpty) {
      context.read<ChatBloc>().add(
        LoadChats(userId: currentUserId, token: token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            final chats = state.chats;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                final otherParticipant = chat.participants.firstWhere(
                  (p) => p.id != currentUserId,
                  orElse: () => chat.participants.first,
                );

                final lastMessage = chat.lastMessage?.content ?? '';
                final time =
                    chat.lastMessage != null
                        ? TimeOfDay.fromDateTime(
                          chat.lastMessage!.createdAt,
                        ).format(context)
                        : '';

                return ChatTile(
                  name: otherParticipant.name,
                  lastMessage: lastMessage,
                  time: time,
                  onTap: () {
                    debugPrint('Tapped on chat with ${otherParticipant.name}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider(
                              create: (_) => ChatmessageBloc(),
                              child: ChatDetailPage(
                                chatId: chat.id,
                                token: token,
                                currentUserId: currentUserId,
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.error));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.shade100,
          child: Text(name.isNotEmpty ? name[0] : '?'),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ),
    );
  }
}
