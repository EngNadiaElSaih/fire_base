import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // لإحضار اسم الملف
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
  String? imagePath;
  String? imageUrl;

  // دالة لاختيار الصورة ورفعها
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
      await _uploadImageToFirebase(File(pickedFile.path));
    }
  }

  // دالة رفع الصورة إلى Firebase Storage
  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // اسم الملف
      String fileName = basename(imageFile.path);

      // مرجع للصورة في Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      // رفع الصورة
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // انتظار إكمال عملية الرفع
      TaskSnapshot taskSnapshot = await uploadTask;

      // الحصول على رابط الصورة
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });

      // يمكنك هنا تحديث الصورة في Firebase Auth إذا أردت
      await user?.updatePhotoURL(downloadUrl);

      print('Image uploaded successfully: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
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
            const Text('Profile'),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined)),
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
                Container(
                  height: 200,
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
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1D1B20)),
                        ),
                        accountEmail: Text(
                          user?.email ?? 'No Email',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 210,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl!)
                              : const AssetImage("assets/images/profile.jpg")
                                  as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // زر تعديل المعلومات
                ExpansionTile(
                  title: Text('Edit'),
                  children: [
                    ListTile(
                      title: Text('Change Profile Picture'),
                      trailing: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () async {
                          var imageResult = await FilePicker.platform
                              .pickFiles(type: FileType.image, withData: true);
                          if (imageResult != null) {
                            var storageRef = FirebaseStorage.instance
                                .ref('images/${imageResult.files.first.name}');
                            var uploadResult = await storageRef.putData(
                                imageResult.files.first.bytes!,
                                SettableMetadata(
                                  contentType:
                                      'image/${imageResult.files.first.name.split('.').last}',
                                ));

                            if (uploadResult.state == TaskState.success) {
                              var downloadUrl =
                                  await uploadResult.ref.getDownloadURL();
                              print(
                                  'Image uploaded successfully. URL: $downloadUrl');
                            }
                          } else {
                            print('No file selected');
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Change User Name:'),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter new user name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Handle name change logic here
                          print('New User Name: $value');
                        },
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: const Color(0xffEBEBEB),
                    child: InkWell(
                      onTap: _pickImage, // استدعاء اختيار الصورة
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Edit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            Icon(Icons.keyboard_double_arrow_right_sharp),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: const Color(0xffEBEBEB),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Setting",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EditPage(), // استبدل  ال
                              //   ),
                              // );
                            },
                            child: const Icon(
                                Icons.keyboard_double_arrow_right_sharp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //container2
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: const Color(0xffEBEBEB),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Change Profile Image",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var imageResult = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.image, withData: true);
                              if (imageResult != null) {
                                var storageRef = FirebaseStorage.instance.ref(
                                    'images/${imageResult.files.first.name}');
                                var uploadResult = await storageRef.putData(
                                    imageResult.files.first.bytes!,
                                    SettableMetadata(
                                      contentType:
                                          'image/${imageResult.files.first.name.split('.').last}',
                                    ));

                                if (uploadResult.state == TaskState.success) {
                                  var downloadUrl =
                                      await uploadResult.ref.getDownloadURL();
                                  print('>>>>>Image upload${downloadUrl}');
                                }
                              } else {
                                print('No file selected');
                              }
                            },
                            child: const Icon(
                                Icons.keyboard_double_arrow_right_sharp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //container3
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: const Color(0xffEBEBEB),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "About Us",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EditPage(), // استبدل ا
                              //   ),
                              // );
                            },
                            child: const Icon(
                                Icons.keyboard_double_arrow_right_sharp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut(); // تسجيل الخروج
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginPage()));
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
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
}
