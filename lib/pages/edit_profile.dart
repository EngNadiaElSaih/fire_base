import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';

import 'package:flutter_application_1/widgets/navigator_bar.dart';

class EditProfile extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onClicked;

  const EditProfile({
    super.key,
    required this.selectedIndex,
    required this.onClicked,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false; // متغير لحالة التحميل

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      var imageResult = await FilePicker.platform
          .pickFiles(type: FileType.image, withData: true);

      if (imageResult != null) {
        var storageRef = FirebaseStorage.instance
            .ref('profile_images/${imageResult.files.first.name}');

        var uploadResult = await storageRef.putData(
          imageResult.files.first.bytes!,
          SettableMetadata(
              contentType: 'image/${imageResult.files.first.extension}'),
        );

        if (uploadResult.state == TaskState.success) {
          String downloadUrl = await storageRef.getDownloadURL();

          setState(() {
            imageUrl = downloadUrl; // تحديث رابط الصورة في الحالة
          });

          await user?.updatePhotoURL(
              downloadUrl); // تحديث رابط الصورة في حساب المستخدم

          await FirebaseFirestore.instance
              .collection('userProfile')
              .doc(user?.uid)
              .update({
            'imageLink': downloadUrl,
          });

          print('Image uploaded successfully: $downloadUrl');
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _saveProfileChanges() async {
    try {
      setState(() {
        isLoading = true; // إظهار مؤشر التحميل أثناء الحفظ
      });

      String updatedName = nameController.text.trim();
      String updatedEmail = emailController.text.trim();

      // Update Firebase Authentication user data
      if (updatedName.isNotEmpty) {
        await user?.updateDisplayName(updatedName);
      }
      if (updatedEmail.isNotEmpty && updatedEmail != user?.email) {
        await user?.updateEmail(updatedEmail);
      }

      // Update Firestore with additional data like image and name
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(user?.uid)
          .set({
        'name': updatedName,
        'email': updatedEmail,
        'imageLink':
            imageUrl ?? user?.photoURL, // Use current or uploaded image URL
      });

      print('Profile updated successfully');

      // بعد الانتهاء من الحفظ، الانتقال إلى صفحة البروفايل وإزالة الصفحة الحالية من السجل
      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile changes: $e');
    } finally {
      setState(() {
        isLoading = false; // إخفاء مؤشر التحميل بعد الحفظ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit Profile',
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl!)
                          : (user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : const NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQgkH2cbQhMnS7wT5kwXg2St0oExJIVuIsQ&s'))
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 30),
                        onPressed: _uploadImageToFirebase,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 20),
                _buildTextField(emailController, 'Email'),
                const SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator() // عرض مؤشر التحميل
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _saveProfileChanges,
                            child: const Text('Save Changes'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromRGBO(255, 82, 82, 1)),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavigatorBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
