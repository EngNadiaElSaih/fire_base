import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chats/chat_detail_page.dart';

import 'package:flutter_application_1/widgets/navigator_bar.dart';
// تأكد من استيراد صفحة تفاصيل المحادثة

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getChats();
  }

  Future<void> getChats() async {
    setState(() {
      isLoading = true;
    });

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: user.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          chats = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        } else {
          chats = [];
        }
      } else {
        chats = [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching chats: $e'),
      ));
      chats = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? Center(child: Text('No chats available'))
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var chat = chats[index];
                    var participant = chat['participants'].firstWhere(
                      (id) => id != FirebaseAuth.instance.currentUser!.uid,
                      orElse: () => '',
                    );

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          chat['avatarUrl'] ??
                              'https://example.com/default-avatar.png',
                        ),
                      ),
                      title: Text(chat['name'] ?? 'No Name'),
                      subtitle: Text(chat['lastMessage'] ?? 'No Messages'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailPage(
                              chatId: chat['id'], // تمرير المعلمة بشكل صحيح
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
