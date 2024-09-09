import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة Firebase Firestore
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/courses_category.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';

class AllCategories extends StatefulWidget {
  AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  Map<int, bool> pressedStates = {}; // خريطة لتتبع حالة الضغط لكل عنصر
  Map<int, List<String>> categoryData =
      {}; // تخزين البيانات التي تم جلبها لكل عنصر

  // دالة لجلب البيانات من Firestore
  Future<void> fetchCategoryData(int categoryId) async {
    try {
      // جلب البيانات من Firestore بناءً على category_id
      var snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId.toString())
          .collection('courses')
          .get();

      // حفظ البيانات في الخريطة
      setState(() {
        categoryData[categoryId] =
            snapshot.docs.map((doc) => doc['title'].toString()).toList();
      });
    } catch (error) {
      print("Error fetching category data: $error");
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
            const Text('Categories'),
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                buildCategoryItem(context, 0, 'Business'),
                const SizedBox(height: 10),
                buildCategoryItem(context, 1, 'UI/UX'),
                const SizedBox(height: 10),
                buildCategoryItem(context, 2, 'Accounts'),
                const SizedBox(height: 10),
                buildCategoryItem(context, 3, 'Software Engineering'),
                const SizedBox(height: 10),
                buildCategoryItem(context, 4, 'SEO'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index] ?? false; // التحقق من حالة الضغط
// البيانات المحملة

    return Column(children: [
      InkWell(
        onTap: () async {
          setState(() {
            pressedStates[index] = !isPressed; // تغيير حالة الضغط
          });
          if (!isPressed) {
            // جلب البيانات عند الضغط
            await fetchCategoryData(index);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPressed
                ? Colors.white
                : ColorUtility.grayExtraLight, // لون الخلفية
            borderRadius: BorderRadius.circular(5), // زوايا دائرية
            border: Border.all(
              color: isPressed
                  ? Colors.yellow
                  : ColorUtility.grayExtraLight, // لون الإطار
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, // نص العنصر
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPressed
                      ? ColorUtility.deepYellow
                      : Colors.black, // لون النص
                ),
              ),
              Icon(
                isPressed
                    ? Icons.keyboard_double_arrow_down_sharp
                    : Icons
                        .keyboard_double_arrow_right_sharp, // تغيير الأيقونة حسب الضغط
                color: isPressed
                    ? ColorUtility.deepYellow
                    : Colors.black, // تغيير لون الأيقونة
                size: 24,
              ),
            ],
          ),
        ),
      ),
      if (isPressed)
        SingleChildScrollView(
          child: Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    LabelWidget(
                      name: '',
                      onSeeAllClicked: () {},
                    ),
                    // const CoursesWidget(
                    //   rankValue: 'top rated',
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
////////////////////////////////////////////////////////////////////

                    // const CoursesCategory(
                    //   categoryValue: 'bussiness',
                    // )
                    ////////////////////

                    CoursesCategory(
                      categoryValue: 'Bussiness',
                      onSeeAllClicked: () {},
                    )

////////////////////////////////////
                  ],
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
