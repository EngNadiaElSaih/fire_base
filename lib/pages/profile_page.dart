import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/pages/login_page.dart';
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

  // دالة لرفع الصورة إلى Firebase Storage باستخدام File Picker
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
          await user?.updatePhotoURL(downloadUrl);
          print('Image uploaded successfully: $downloadUrl');
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  //////////////////// قائمة عناوين التصنيفات //////////////////////
  final List<String> ProfileTitles = ['Edit', 'Setting', 'About Us'];

  // تتبع حالة الضغط على كل عنصر
  List<bool> pressedStates = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profile'),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // عرض معلومات المستخدم
                Container(
                  alignment: Alignment.topCenter,
                  height: 300,
                  width: 300,
                  child: ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        accountName: Text(
                          user?.displayName?.isNotEmpty == true
                              ? user!.displayName!
                              : 'No Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1D1B20)),
                        ),
                        accountEmail: Text(
                          user?.email ?? 'No Email',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.black),
                        ),
                        currentAccountPicture: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 100, // زيادة حجم الصورة
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : const AssetImage(
                                          "assets/images/profile.jpg")
                                      as ImageProvider,
                            ),
                            IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: _uploadImageToFirebase,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                /////////////////////////////////// قائمة التصنيفات
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ProfileTitles.length,
                  itemBuilder: (context, index) {
                    return buildProfileItem(
                        context, index, ProfileTitles[index]);
                  },
                ),

                const SizedBox(height: 20),

                //////////////////logout/////////////////////////// زر تسجيل الخروج
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
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
      bottomNavigationBar: NavigatorBar(),
    );
  }

  Widget buildProfileItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index] ?? false;

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
        SizedBox(height: 20),
        if (isPressed)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (index == 0)
                  Row(
                    children: [
                      const Text("Change Your Profile Picture?"),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: _uploadImageToFirebase,
                      ),
                    ],
                  ),
                if (index == 1)
                  Row(
                    children: [
                      const Text("Change Your theme Color?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorUtility.main,
                          )),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.format_color_fill),
                        onPressed: () {},
                      ),
                    ],
                  ),
                if (index == 2)
                  Text("Egypt Council Is The Best Place \n Thank You For All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorUtility.main,
                      )),
              ],
            ),
          ),
      ],
    );
  }
}
