import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/chats/chat_page.dart';
import 'package:flutter_application_1/chats/message.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
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

  bool isHoveredCart = false;
  bool isHoveredAll = false;
  bool isHoveredLatest = false;
  bool isHoveredMessage = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chats', style: const TextStyle(color: Colors.black)),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHoveredCart = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveredCart = false;
                });
              },
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: isHoveredCart ? ColorUtility.deepYellow : Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredAll = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredAll = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetailPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isHoveredAll
                            ? ColorUtility.deepYellow
                            : ColorUtility.deepYellow,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredLatest = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredLatest = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetailPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isHoveredLatest
                            ? ColorUtility.deepYellow
                            : const Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // صورة المرسل على اليسار دائماً
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(message.senderImageUrl),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // اسم المرسل
                                  Text(
                                    message.senderName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // نص الرسالة
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // زمن الرسالة
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${message.timestamp.hour}:${message.timestamp.minute}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
      floatingActionButton: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHoveredMessage = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHoveredMessage = false;
          });
        },
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ChatPage()));
          },
          child: Icon(Icons.message),
          backgroundColor: isHoveredMessage
              ? ColorUtility.deepYellow
              : ColorUtility.grayExtraLight,
        ),
      ),
    );
  }
}
