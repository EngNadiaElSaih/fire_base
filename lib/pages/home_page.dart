import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/all_categories_page.dart';
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
            Text(
              'Welcome Back! ${FirebaseAuth.instance.currentUser?.displayName}',
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon:
                  const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عرض الفئات مع إمكانية عرض الكل
                LabelWidget(
                  name: 'Categories',
                  onSeeAllClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllCategories(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // عرض فئات المنتجات باستخدام CategoriesWidget
                CategoriesWidget(
                  onSeeAllClicked: () {}, // تنفيذ إجراء عند الضغط على "See All"
                ),

                const SizedBox(height: 20),

                // عرض الدورات ذات التصنيف الأعلى
                LabelWidget(
                  name: 'Top Rated Courses',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(
                  rankValue: 'top rated',
                ),
                const SizedBox(height: 20),

                // عرض الدورات التي يبحث عنها الطلاب
                LabelWidget(
                  name: 'Students Also Search For',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(
                  rankValue: 'search for',
                ),
                const SizedBox(height: 20),

                // عرض أفضل الدورات من حيث المبيعات
                LabelWidget(
                  name: 'Top Seller Courses',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(
                  rankValue: 'top seller',
                ),

                // عرض أفضل الدورات في مجال تكنولوجيا المعلومات
                LabelWidget(
                  name: 'Top Courses In IT',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(
                  rankValue: 'top courses',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavigatorBar(),
    );
  }
}
