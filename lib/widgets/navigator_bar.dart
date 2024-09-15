import 'package:flutter/material.dart';
import 'package:flutter_application_1/chats/chat_detail_page.dart';
import 'package:flutter_application_1/chats/chat_list_page.dart';
import 'package:flutter_application_1/chats/chat_page.dart';
import 'package:flutter_application_1/chats/login_chat.dart';
import 'package:flutter_application_1/pages/all_cources_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:flutter_application_1/pages/trending_page.dart';

import 'package:flutter_application_1/utils/color_utilis.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  // متغيرات منفصلة لحالة التحويم لكل أيقونة
  bool isHomeHovered = false;
  bool isCoursesHovered = false;
  bool isSearchHovered = false;
  bool isChatsHovered = false;
  bool isProfileHovered = false;

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
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHomeHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHomeHovered = false;
                });
              },
              child: Icon(
                Icons.home,
                color: isHomeHovered ? ColorUtility.deepYellow : Colors.black,
              ),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllCourses(
                    categoryValue: ' courseCategory',
                  ),
                ),
              );
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isCoursesHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isCoursesHovered = false;
                });
              },
              child: Icon(
                Icons.menu_book,
                color:
                    isCoursesHovered ? ColorUtility.deepYellow : Colors.black,
              ),
            ),
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
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isSearchHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isSearchHovered = false;
                });
              },
              child: Icon(
                Icons.search,
                color: isSearchHovered ? ColorUtility.deepYellow : Colors.black,
              ),
            ),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => AddPostPage()));
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ChatPage()));
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => ChatListPage()));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => ChatDetailPage(
              //               chatId: '0',
              //             )));
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isChatsHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isChatsHovered = false;
                });
              },
              child: Icon(
                Icons.chat_bubble_outline,
                color: isChatsHovered ? ColorUtility.deepYellow : Colors.black,
              ),
            ),
          ),
          label: 'Chats',
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
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isProfileHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isProfileHovered = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isProfileHovered
                        ? ColorUtility.deepYellow
                        : Colors.black,
                    width: 2.0, // سمك الحدود
                  ),
                ),
                child: CircleAvatar(
                  radius: 20, // يمكنك تعديل الحجم حسب الحاجة
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQgkH2cbQhMnS7wT5kwXg2St0oExJIVuIsQ&s',
                  ),
                  backgroundColor: Colors.transparent, // اجعل الخلفية شفافة
                ),
              ),
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
