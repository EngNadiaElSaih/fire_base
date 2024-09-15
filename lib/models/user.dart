class User {
  String? id;
  String? displayName;
  String? imageUrl;
  String? email;
  String? photoURL;
  String? imageLink;

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
    photoURL = data['photoURL'];
    imageLink = data['imageLink'];
    return data;
  }
}
