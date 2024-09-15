import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String text;
  DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
