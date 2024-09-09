import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart';

class AllCategories extends StatefulWidget {
  AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  Map<int, bool> pressedStates = {}; // خريطة لتتبع حالة الضغط لكل عنصر

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
                icon: const Icon(Icons.shopping_cart_outlined)),
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
                SizedBox(height: 40),
                buildCategoryItem(context, 0, 'Business', [
                  '${CoursesWidget(
                    rankValue: 'search for',
                  )}'
                ]),
                SizedBox(height: 10),
                buildCategoryItem(
                    context, 1, 'UI/UX', ['Design 101', 'Advanced UI/UX']),
                SizedBox(height: 10),
                buildCategoryItem(context, 2, 'Accounts',
                    ['Accounting Basics', 'Finance 101']),
                SizedBox(height: 10),
                buildCategoryItem(context, 3, 'Software Engineering',
                    ['Programming', 'Data Structures']),
                SizedBox(height: 10),
                buildCategoryItem(
                    context, 4, 'SEO', ['SEO for Beginners', 'Advanced SEO']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة لبناء عنصر الفئة مع الدروب داون ليست
  Widget buildCategoryItem(BuildContext context, int index, String title,
      List<String> dropdownItems) {
    bool isPressed = pressedStates[index] ?? false; // التحقق من حالة الضغط

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              pressedStates[index] =
                  !isPressed; // تغيير حالة الضغط للعنصر الحالي
            });
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
                          .keyboard_double_arrow_right_sharp, // أيقونة حسب حالة الضغط
                  color: isPressed
                      ? ColorUtility.deepYellow
                      : Colors.black, // لون الأيقونة
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        // إذا تم الضغط، عرض الدروب داون ليست
        if (isPressed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: dropdownItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
