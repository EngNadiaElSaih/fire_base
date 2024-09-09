import 'package:flutter/material.dart';

import 'package:flutter_application_1/pages/all_cources_page.dart';

import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:flutter_application_1/pages/trending_page.dart';

import 'package:flutter_application_1/posts_screens/post_list_page.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key});

  void _navigate(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => _navigate(context, '/home'),
            child: const Icon(Icons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllCourses(),
                ),
              );
            },
            child: const Icon(Icons.menu_book),
          ),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrendingPage(),
                ),
              );
            },
            child: const Icon(Icons.search),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PostsListPage()));
            },
            child: const Icon(Icons.message),
          ),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    selectedIndex: 0,
                    onClicked: (int index) {},
                  ),
                ),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
              //  NetworkImage('https://your-profile-picture-url.com'),
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
