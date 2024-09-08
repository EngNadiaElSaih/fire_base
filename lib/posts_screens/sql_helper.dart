import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/posts_screens/posts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

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
