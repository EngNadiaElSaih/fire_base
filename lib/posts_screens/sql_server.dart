import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/posts_screens/posts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Class for interacting with SQLite database
class SqlHelper {
  Database? db;

  Future<void> init() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
      } else {
        db = await openDatabase(
          'pos.db',
          version: 1,
          onCreate: (db, version) {
            print('Database created successfully');
          },
        );
      }
    } catch (e) {
      print('Error in creating database: $e');
    }
  }

  Future<void> registerForeignKeys() async {
    await db!.rawQuery("PRAGMA foreign_keys = ON");
    var result = await db!.rawQuery("PRAGMA foreign_keys");
    print('Foreign keys result: $result');
  }

  Future<bool> createTables() async {
    try {
      await registerForeignKeys();
      var batch = db!.batch();
      batch.execute("""
        CREATE TABLE IF NOT EXISTS posts(
          id TEXT PRIMARY KEY,
          username TEXT NOT NULL,
          postTitle TEXT NOT NULL,
          postText TEXT NOT NULL
        )
      """);

      var result = await batch.commit();
      print('Results: $result');
      return true;
    } catch (e) {
      print('Error in creating tables: $e');
      return false;
    }
  }

  Future<void> insertPost(Posts post) async {
    try {
      await db!.insert(
          'posts',
          {
            'id': post.id,
            'username': post.username,
            'postTitle': post.postTitle,
            'postText': post.postText
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error inserting post: $e');
    }
  }

  Future<List<Posts>> getAllPosts() async {
    try {
      final List<Map<String, dynamic>> maps = await db!.query('posts');
      return List.generate(maps.length, (i) {
        return Posts.fromJson(maps[i]);
      });
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  Future<void> updatePost(Posts post) async {
    try {
      await db!.update(
        'posts',
        {
          'username': post.username,
          'postTitle': post.postTitle,
          'postText': post.postText
        },
        where: 'id = ?',
        whereArgs: [post.id],
      );
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await db!.delete(
        'posts',
        where: 'id = ?',
        whereArgs: [postId],
      );
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> backupDatabase(String backupFilePath) async {
    // Implement backup functionality if needed
  }
}

// Class for interacting with the server
class Services {
  static var url = Uri.parse(
      'https://salarapiapp.000webhostapp.com/api_post_app/post_api.php');

  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _ADD_POST_ACTION = 'ADD_POST';
  static const _GET_ALL_POSTS_ACTION = 'GET_ALL';
  static const _UPDATE_POST_ACTION = 'UPDATE_POST';
  static const _DELETE_POST_ACTION = 'DELETE_POST';

  static Future<String> createTable() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('Create table response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> addPost(
      String userName, String postTitle, String postText) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _ADD_POST_ACTION;
      map['user_name'] = userName;
      map['post_title'] = postTitle;
      map['post_text'] = postText;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('ADD Post Response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<Posts>> getAllPosts() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_POSTS_ACTION;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('Get All Posts: ${response.body}');
      }
      if (200 == response.statusCode) {
        List<Posts> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      return <Posts>[];
    }
    return getAllPosts();
  }

  static List<Posts> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Posts>((json) => Posts.fromJson(json)).toList();
  }

  static Future<String> updatePost(
    String postId,
    String username,
    String postTitle,
    String postText,
  ) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _UPDATE_POST_ACTION;
      map['post_id'] = postId;
      map['user_name'] = username;
      map['post_title'] = postTitle;
      map['post_text'] = postText;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Update Post Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> deletePost(String postId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_POST_ACTION;
      map['POST_ID'] = postId;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('delete post response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Combine SQL Helper and Services
class PostService {
  final SqlHelper sqlHelper = SqlHelper();

  Future<void> initialize() async {
    await sqlHelper.init();
    await sqlHelper.createTables();
  }

  Future<void> fetchPostsFromServer() async {
    List<Posts> posts = await Services.getAllPosts();
    for (var post in posts) {
      await sqlHelper.insertPost(post);
    }
  }

  Future<void> addPostToServerAndLocal(
      String userName, String postTitle, String postText) async {
    var response = await Services.addPost(userName, postTitle, postText);
    if (response != 'error') {
      // Assuming response contains the ID of the newly created post
      var postId = json.decode(response)['id'];
      await sqlHelper.insertPost(Posts(
        id: postId,
        username: userName,
        postTitle: postTitle,
        postText: postText,
      ));
    }
  }

  Future<void> updatePostOnServerAndLocal(
      String postId, String username, String postTitle, String postText) async {
    var response =
        await Services.updatePost(postId, username, postTitle, postText);
    if (response != 'error') {
      await sqlHelper.updatePost(Posts(
        id: postId,
        username: username,
        postTitle: postTitle,
        postText: postText,
      ));
    }
  }

  Future<void> deletePostFromServerAndLocal(String postId) async {
    var response = await Services.deletePost(postId);
    if (response != 'error') {
      await sqlHelper.deletePost(postId);
    }
  }

  Future<List<Posts>> getAllPosts() async {
    // Fetch from local database
    return await sqlHelper.getAllPosts();
  }
}
