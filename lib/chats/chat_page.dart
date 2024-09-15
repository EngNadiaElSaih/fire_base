import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserImageUrl();
  }

  Future<void> _getUserImageUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userImageUrl =
          user?.photoURL ?? 'https://example.com/default-avatar.png';
    });
  }

  Future<void> _sendMessage(String receiverId) async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('messages').add({
        'senderId': _currentUserId,
        'receiverId': receiverId,
        'text': _messageController.text,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
    }
  }

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150, // تحديد ارتفاع الـ AppBar
        flexibleSpace: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                CircleAvatar(
                  radius: 40, // زيادة حجم الصورة
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : const NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQgkH2cbQhMnS7wT5kwXg2St0oExJIVuIsQ&s",
                        ),
                ),
                const SizedBox(width: 10),
                Text(
                  user?.displayName?.isNotEmpty == true
                      ? user!.displayName!
                      : 'No Name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1D1B20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var message = docs[index];
                      var isCurrentUser = message['senderId'] == _currentUserId;
                      var messageText = message['text'];

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(15),
                          constraints: BoxConstraints(
                              maxWidth: 250), // تحديد العرض الأقصى
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? ColorUtility.main // لون مختلف للمرسل
                                : ColorUtility.deepYellow, // لون مختلف للمستقبل
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: isCurrentUser
                                  ? Radius.circular(15)
                                  : Radius.circular(0), // حواف دائرية حسب الجهة
                              bottomRight: isCurrentUser
                                  ? Radius.circular(0)
                                  : Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCurrentUser ? "Me" : "Other User",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      decoration: InputDecoration(
                        labelText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage('receiverId'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
