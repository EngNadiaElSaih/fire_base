import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/posts_screens/post_list_page.dart';
import 'package:flutter_application_1/posts_screens/sql_server.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _postTitleController = TextEditingController();
  final _postTextController = TextEditingController();

  Future<void> _addPost() async {
    if (_formKey.currentState!.validate()) {
      await Services.addPost(
        _userNameController.text,
        _postTitleController.text,
        _postTextController.text,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => PostsListPage()));
    }
  }

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add PostsS'),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true; // تعيين الحالة إلى true عند دخول الماوس
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false; // إعادة الحالة إلى false عند خروج الماوس
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
                  color: isHovered
                      ? ColorUtility.deepYellow
                      : Colors.black, // تغيير اللون بناءً على حالة الوقوف
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                    labelText:
                        ' ${FirebaseAuth.instance.currentUser?.displayName}'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postTitleController,
                decoration: InputDecoration(labelText: 'Post Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postTextController,
                decoration: InputDecoration(labelText: 'Post Text'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the post text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Post'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: _addPost,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
