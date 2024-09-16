import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String email;
  String name;
  String profileImageUrl;
  String coverImageUrl;
  String downloadUrl;

  UserProfile({
    required this.email,
    required this.name,
    required this.profileImageUrl,
    required this.coverImageUrl,
    required this.downloadUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'],
      name: json['name'] ?? 'No Name',
      profileImageUrl:
          json['profileImageUrl'] ?? 'https://example.com/default-avatar.png',
      coverImageUrl:
          json['coverImageUrl'] ?? 'https://example.com/default-cover.png',
      downloadUrl: json['downloadUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'downloadUrl': downloadUrl,
    };
  }
}
