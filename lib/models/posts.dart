class Posts {
  String id;
  String username;
  String postTitle;
  String postText;

  Posts({
    required this.id,
    required this.username,
    required this.postTitle,
    required this.postText,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json['id'] as String,
      username: json['username'] as String,
      postTitle: json['posttitle'] as String,
      postText: json['posttext'] as String,
    );
  }
}
