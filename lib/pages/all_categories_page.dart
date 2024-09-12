import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  Map<int, bool> pressedStates = {}; // خريطة لتتبع حالة الضغط لكل عنصر

  // قائمة العناوين
  final List<String> categoryTitles = [
    'Business',
    'UI/UX',
    'Software Engineering'
  ];

  // قائمة البيانات التي سيتم عرضها لكل عنوان
  final List<String> categoryCourses = [
    'Business Course 1',
    'UI/UX Course 1',
    'Software Engineering Course 1'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Categories'),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
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
                // بناء كل عنصر من عناصر التصنيف
                ...categoryTitles.asMap().entries.map((entry) {
                  int index = entry.key;
                  String title = entry.value;

                  return Column(
                    children: [
                      buildCategoryItem(context, index, title),
                      const SizedBox(height: 20), // المسافة الرأسية بين العناصر
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index] ?? false; // التحقق من حالة الضغط

    // بناء عنوان الدورة بناءً على التصنيف
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      default:
    }

    return Column(
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              pressedStates[index] = !isPressed; // تغيير حالة الضغط
            });
            if (!isPressed) {
              // هنا يمكنك إضافة الكود لجلب البيانات من Firestore إذا كنت بحاجة لذلك
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWidget(
                  name: 'Courses in $title',
                  onSeeAllClicked: () {
                    // التعامل مع حدث "See All"
                  },
                ),
                const SizedBox(
                    height: 10), // المسافة بين LabelWidget و CoursesCategory

                if (index == 0)
                  const CoursesWidget(
                    rankValue: 'top rated',
                  ),
                if (index == 1)
                  const CoursesWidget(
                    rankValue: 'search for',
                  ),
                if (index == 2)
                  const CoursesWidget(
                    rankValue: 'top seller',
                  ),
                const SizedBox(height: 20), // المسافة بين العناصر
              ],
            ),
          ),
      ],
    );
  }
}
