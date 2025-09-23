
class Participant {
  final String id;
  final String name;
  final String profile;

  Participant({required this.id, required this.name, required this.profile});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      name: json['name'] ?? '',
      profile: json['profile'] ?? '',
    );
  }
}

class LastMessage {
  final String content;
  final DateTime createdAt;

  LastMessage({required this.content, required this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Chatmodel {
  final String id;
  final List<Participant> participants;
  final LastMessage? lastMessage;

  Chatmodel({required this.id, required this.participants, this.lastMessage});

  factory Chatmodel.fromJson(Map<String, dynamic> json) {
    return Chatmodel(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}
// class ChatModel {
//   final String id;
//   final List<Participant> participants;
//   final LastMessage? lastMessage;

//   ChatModel({
//     required this.id,
//     required this.participants,
//     this.lastMessage,
//   });

//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//       id: json['_id'],
//       participants: (json['participants'] as List)
//           .map((p) => Participant.fromJson(p))
//           .toList(),
//       lastMessage: json['lastMessage'] != null
//           ? LastMessage.fromJson(json['lastMessage'])
//           : null,
//     );
//   }
// }

// class Participant {
//   final String id;
//   final String name;
//   final String? profile;

//   Participant({required this.id, required this.name, this.profile});

//   factory Participant.fromJson(Map<String, dynamic> json) {
//     return Participant(
//       id: json['_id'],
//       name: json['name'] ?? '',
//       profile: json['profile'],
//     );
//   }
// }

// class LastMessage {
//   final String content;
//   final String senderId;
//   final DateTime createdAt;

//   LastMessage({
//     required this.content,
//     required this.senderId,
//     required this.createdAt,
//   });

//   factory LastMessage.fromJson(Map<String, dynamic> json) {
//     return LastMessage(
//       content: json['content'] ?? '',
//       senderId: json['senderId'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }
