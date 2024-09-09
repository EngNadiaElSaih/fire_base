import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/widgets/categories_widget.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //is me
            Text(
                'Welcome Back! ${FirebaseAuth.instance.currentUser?.displayName}'),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartPage()));
                },
                icon: Icon(Icons.shopping_cart_outlined)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Expanded(
          child: SafeArea(
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
                  const CoursesWidget(
                    rankValue: 'top rated',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Students Also Search For ',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'search for',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Top Courses In IT',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'top courses ',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Top Seller Courses',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'top seller',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
