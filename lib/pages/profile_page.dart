import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  // alignment: Alignment.center,
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
                        currentAccountPicture: const CircleAvatar(
                          radius: 210,
                          backgroundImage:
                              AssetImage("assets/images/profile.jpg"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: const Color(0xffEBEBEB),
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
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
                            "Edit",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit Profile"),
                                    content: const Text(
                                        "Would you like to edit your profile?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // إغلاق الديالوج
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // تنفيذ إجراءات التعديل هنا
                                          Navigator.of(context)
                                              .pop(); // إغلاق الديالوج
                                        },
                                        child: const Text("Edit"),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut(); // تسجيل الخروج
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LoginPage()));
                          // Navigator.pushReplacementNamed(context,
                          //     '/login'); // توجيه المستخدم إلى صفحة تسجيل الدخول
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(255, 82, 82, 1)),
                        )),
                  ],
                ),
              ]),
        ),
      ),
      bottomNavigationBar: const NavigatorBar(),
    );
  }
}
