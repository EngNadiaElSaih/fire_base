import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  Map<int, bool> pressedStates = {}; // خريطة لتتبع حالة الضغط لكل عنصر

  // قائمة العناوين
  final List<String> categoryTitles = [
    'Bussiness',
    'UI/UX',
    'Software Engineer'
  ];

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Categories'),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              child: IconButton(
                onPressed: () {
                  // تعامل مع السلة هنا
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: isHovered ? ColorUtility.deepYellow : Colors.black,
                ),
              ),
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
                ...categoryTitles.asMap().entries.map((entry) {
                  int index = entry.key;
                  String title = entry.value;

                  return Column(
                    children: [
                      buildCategoryItem(context, index, title),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }

  Widget buildCategoryItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index] ?? false;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              pressedStates[index] = !isPressed;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPressed ? Colors.white : ColorUtility.grayExtraLight,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isPressed ? Colors.yellow : ColorUtility.grayExtraLight,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPressed ? ColorUtility.deepYellow : Colors.black,
                  ),
                ),
                Icon(
                  isPressed
                      ? Icons.keyboard_double_arrow_down_sharp
                      : Icons.keyboard_double_arrow_right_sharp,
                  color: isPressed ? ColorUtility.deepYellow : Colors.black,
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
                const SizedBox(height: 10),

                // هنا نعرض الكورسات بناءً على التصنيف باستخدام StreamBuilder
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .where('category.name', isEqualTo: title)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No courses found.'));
                    }

                    final courses = snapshot.data!.docs.map((doc) {
                      return Course.fromJson(
                          doc.data() as Map<String, dynamic>);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: course.image != null
                                ? Image.network(
                                    course.image!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 80),
                          ),
                          title: Text(
                            course.title ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0157db),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 16),
                                  const SizedBox(width: 4),
                                  Text(course.instructor?.name ??
                                      'No Instructor'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    course.rating?.toString() ?? 'No Rating',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtility.gray,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  ...List.generate(
                                    (course.rating ?? 0).floor(),
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                  if (course.rating != null &&
                                      course.rating! % 1 != 0)
                                    const Icon(
                                      Icons.star_half,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ...List.generate(
                                    5 - (course.rating?.ceil() ?? 0),
                                    (index) => const Icon(
                                      Icons.star_border,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${course.price ?? 'No Price'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtility.main,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
      ],
    );
  }
}
