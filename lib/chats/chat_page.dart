import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chats/message.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _sendMessage(String receiverId) async {
    if (_messageController.text.isNotEmpty) {
      Message message = Message(
        senderId: _currentUserId,
        receiverId: receiverId,
        text: _messageController.text,
        timestamp: DateTime.now(),
      );
      await _firestore.collection('messages').add(message.toJson());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<DocumentSnapshot> docs = snapshot.data!.docs;
                List<Message> messages = docs
                    .map((doc) =>
                        Message.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index].text),
                      subtitle: Text(messages[index].timestamp.toString()),
                      leading: messages[index].senderId == _currentUserId
                          ? Icon(Icons.person)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        InputDecoration(labelText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(
                      'receiverId'), // Replace 'receiverId' with actual receiver ID
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
