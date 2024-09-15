import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/posts_screens/addpost_page.dart';
import 'package:flutter_application_1/posts_screens/edit_post.dart';
import 'package:flutter_application_1/posts_screens/posts.dart';
import 'package:flutter_application_1/posts_screens/sql_server.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

//2//page//
class PostsListPage extends StatefulWidget {
  @override
  _PostsListPageState createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  late Future<List<Posts>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = Services.getAllPosts();
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
            const Text('All Posts'),
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
      body: FutureBuilder<List<Posts>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading posts'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post.postTitle),
                  subtitle: Text(post.username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostPage(post: post),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
