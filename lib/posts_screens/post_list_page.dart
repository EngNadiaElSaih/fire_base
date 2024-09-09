import 'package:flutter/material.dart';
import 'package:flutter_application_1/posts_screens/addpost_page.dart';
import 'package:flutter_application_1/posts_screens/edit_post.dart';
import 'package:flutter_application_1/posts_screens/posts.dart';
import 'package:flutter_application_1/posts_screens/sql_server.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Posts'),
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
