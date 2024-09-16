import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة هذه السطر لاستيراد Firestore
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/pages/edit_profile.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onClicked;

  const ProfilePage({
    super.key,
    required this.selectedIndex,
    required this.onClicked,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(user!.uid)
            .get();

        if (userDoc.exists && userDoc.data()!.containsKey('imageUrl')) {
          setState(() {
            imageUrl = userDoc.data()!['imageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
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
            imageUrl = downloadUrl;
          });

          // تحديث رابط الصورة في Firebase Authentication و Firestore
          if (user != null) {
            await user!.updatePhotoURL(downloadUrl);
            await FirebaseFirestore.instance
                .collection('userProfile')
                .doc(user!.uid)
                .update({'imageUrl': downloadUrl});
          }

          print('Image uploaded successfully: $downloadUrl');
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  final List<String> profileTitles = ['Edit', 'Setting', 'About Us'];

  List<bool> pressedStates = [false, false, false];
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
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
                  color: isHovered ? ColorUtility.deepYellow : Colors.black,
                ),
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
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : const NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQgkH2cbQhMnS7wT5kwXg2St0oExJIVuIsQ&s",
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.image, size: 40),
                              color: Colors.black,
                              onPressed: _uploadImageToFirebase,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user?.displayName?.isNotEmpty == true
                            ? user!.displayName!
                            : 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1D1B20),
                        ),
                      ),
                      Text(
                        user?.email ?? 'No Email',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileTitles.length,
                  itemBuilder: (context, index) {
                    return buildProfileItem(
                        context, index, profileTitles[index]);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavigatorBar(),
    );
  }

  Widget buildProfileItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index];

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              pressedStates[index] = !isPressed;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPressed ? Colors.white : ColorUtility.grayExtraLight,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isPressed ? Colors.yellow : ColorUtility.grayExtraLight,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPressed ? ColorUtility.deepYellow : Colors.black,
                  ),
                ),
                Icon(
                  isPressed
                      ? Icons.keyboard_double_arrow_down_sharp
                      : Icons.keyboard_double_arrow_right_sharp,
                  color: isPressed ? ColorUtility.deepYellow : Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isPressed)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                if (index == 0)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text("Edit Your Profile ?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.main,
                              )),
                          const SizedBox(width: 10),
                          IconButton(
                              color: ColorUtility.deepYellow,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfile(
                                      selectedIndex: 0,
                                      onClicked: (int index) {},
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                if (index == 1)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text("Change Your Profile E-mail?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.main,
                              )),
                        ],
                      ),
                    ],
                  ),
                if (index == 2)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text("Change Your Password?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.main,
                              )),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
