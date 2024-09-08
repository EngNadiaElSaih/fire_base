import 'package:flutter/material.dart';
import 'package:flutter_application_1/posts_screens/posts.dart';
import 'package:flutter_application_1/posts_screens/sql_server.dart';

class EditPostPage extends StatefulWidget {
  final Posts post;

  EditPostPage({required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _postTitleController;
  late TextEditingController _postTextController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.post.username);
    _postTitleController = TextEditingController(text: widget.post.postTitle);
    _postTextController = TextEditingController(text: widget.post.postText);
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState!.validate()) {
      await Services.updatePost(
        widget.post.id,
        _userNameController.text,
        _postTitleController.text,
        _postTextController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postTitleController,
                decoration: InputDecoration(labelText: 'Post Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the post title';
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
                onPressed: _updatePost,
                child: Text('Update Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
