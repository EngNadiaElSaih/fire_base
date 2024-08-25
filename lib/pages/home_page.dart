import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/widgets/categories_widget.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //is me
            Text(
                'Welcome Back! ${FirebaseAuth.instance.currentUser?.displayName}'),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {},
              ),
              CategoriesWidget(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Rated Courses',
                onSeeAllClicked: () {},
              ),
              Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                      "whats is wrong? why there is no data from database under this container"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('test')
                        .doc('x')
                        // .update()
                        // .delete();
                        .set({});
                  },
                  child: Text('test'))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Document',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://your-profile-picture-url.com'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
    return scaffold;
  }
}
