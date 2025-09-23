import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinorm_task/features/chatmessagedetails/bloc/chatmessage_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String token;
  final String currentUserId;

  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.token,
    required this.currentUserId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ChatmessageBloc>().add(
      LoadChatMessages(chatId: widget.chatId, token: widget.token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatmessageBloc, ChatmessageState>(
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == widget.currentUserId;
                      debugPrint(
                        'Message content: "${msg.content}" (${msg.content.runtimeType})',
                      );

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            // msg.content,
                            msg.content,
                            style: TextStyle(
                              // fontSize: 14,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatMessagesError) {
                  return Center(child: Text(state.error));
                }
                return const SizedBox();
              },
            ),
          ),
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatmessageBloc>().add(
                        SendChatMessage(
                          chatId: widget.chatId,
                          senderId: widget.currentUserId,
                          content: text,
                          token: widget.token,
                        ),
                      );
                      _controller.clear();
                    }
                    debugPrint('Send button pressed');
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
