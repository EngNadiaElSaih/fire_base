import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/chats/chat_detail_page.dart';
import 'package:flutter_application_1/chats/chat_page.dart';
import 'package:flutter_application_1/chats/message.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class BlankPage extends StatefulWidget {
  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  Future<void> _sendMessage(String receiverId) async {}

  bool isHoveredCart = false;
  bool isHoveredAll = false;
  bool isHoveredLatest = false;
  bool isHoveredMessage = false; // متغير جديد لتتبع التمرير فوق الزر

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      MaterialPageRoute(builder: (context) => ChatDetailPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isHoveredAll
                          ? ColorUtility.deepYellow
                          : const Color(0xffE0E0E0),
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
              const SizedBox(width: 20),
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
                      MaterialPageRoute(builder: (context) => ChatDetailPage()),
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
          SizedBox(
            height: 250,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Start Your Conversation",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorUtility.gray)),
            ],
          ),
        ]),
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
