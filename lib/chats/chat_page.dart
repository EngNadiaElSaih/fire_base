import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/chats/message.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';
import 'package:flutter_application_1/widgets/onboarding/onboard_indicator.dart';

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
    User? user = FirebaseAuth.instance.currentUser;

    if (_messageController.text.isNotEmpty) {
      final message = Message(
        senderId: _currentUserId,
        receiverId: receiverId,
        text: _messageController.text,
        timestamp: DateTime.now(),
        senderName: user?.displayName ?? 'No Name',
        senderImageUrl:
            user?.photoURL ?? 'https://example.com/default-avatar.png',
      );

      await _firestore.collection('messages').add(message.toJson());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        flexibleSpace: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(width: 40),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    _userImageUrl ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQgkH2cbQhMnS7wT5kwXg2St0oExJIVuIsQ&s',
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
                      final message = Message.fromJson(
                          docs[index].data() as Map<String, dynamic>);
                      final isCurrentUser = message.senderId == _currentUserId;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              // العمود الثالث: صورة المستخدم
                              if (!isCurrentUser)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(message.senderImageUrl),
                                  ),
                                ),
                              // العمود الثاني: اسم المستخدم ونص الرسالة
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (!isCurrentUser)
                                      Text(
                                        message.senderName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 5.0),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? ColorUtility.main
                                            : ColorUtility.deepYellow,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                          bottomLeft: isCurrentUser
                                              ? Radius.circular(30)
                                              : Radius.circular(0),
                                          bottomRight: isCurrentUser
                                              ? Radius.circular(0)
                                              : Radius.circular(30),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.text,
                                            style: TextStyle(
                                              color: isCurrentUser
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          if (!isCurrentUser) ...[
                                            OnBoardIndicator(), // وضع الـ OnBoardIndicator فقط للرسائل من الشخص الآخر
                                          ]
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // العمود الأول: زمن إرسال الرسالة
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${message.timestamp.hour}:${message.timestamp.minute}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorUtility.deepYellow,
                                  ),
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
                    onPressed: () => _sendMessage(
                        'receiverId'), // استخدم ID المستقبل الفعلي هنا
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
