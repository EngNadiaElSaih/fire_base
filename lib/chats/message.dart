import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String text;
  DateTime timestamp;
  String senderName; // إضافة حقل اسم المرسل
  String senderImageUrl; // إضافة حقل صورة المرسل

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.senderName, // حقل الاسم مطلوب
    required this.senderImageUrl, // حقل الصورة مطلوب
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      senderName: json['senderName'] ?? 'No Name', // معالجة عدم وجود الاسم
      senderImageUrl: json['senderImageUrl'] ??
          'https://example.com/default-avatar.png', // معالجة عدم وجود الصورة
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'senderName': senderName, // إضافة الاسم
      'senderImageUrl': senderImageUrl, // إضافة الصورة
    };
  }
}
