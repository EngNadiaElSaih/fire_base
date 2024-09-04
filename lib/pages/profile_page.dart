import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  alignment:
                      Alignment.center, // يجعل محتويات `Container` في المنتصف
                  child: ListView(
                    children: const [
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // يجعل خلفية `UserAccountsDrawerHeader` بيضاء
                        ),
                        accountName: Text(
                          "Eng_Nadia El_Saih",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1D1B20)),
                        ),
                        accountEmail: Text(
                          "nadiaelsaih@yahoo.com",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 210,
                          backgroundImage: AssetImage("assets/nadia.jpg"),
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
                  decoration:
                      const BoxDecoration(borderRadius: BorderRadius.zero),
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {},
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
