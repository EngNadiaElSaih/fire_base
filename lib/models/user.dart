import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? displayName;
  String? imageUrl;
  String? email;
  String? photoURL;
  String? imageLink;

  User({
    this.id,
    this.displayName,
    this.imageUrl,
    this.email,
    this.photoURL,
    this.imageLink,
  });

  User.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    displayName = data['displayName'];
    imageUrl = data['imageUrl'];
    email = data['email'];
    photoURL = data['photoURL'];
    imageLink = data['imageLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['photoURL'] = photoURL;
    data['imageLink'] = imageLink;
    return data;
  }

  Future<void> addToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    if (id != null) {
      await firestore.collection('users').doc(id).set(toJson());
    } else {
      throw Exception('User ID is required to add data to Firestore');
    }
  }
}
