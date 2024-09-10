import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/courses_category.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart'; // تأكد من استيراد هذا

class CoursesByCategoryPage extends StatelessWidget {
  final int index;
  final String categoryValue;

  const CoursesByCategoryPage(
      {super.key, required this.index, required this.categoryValue});

  @override
  Widget build(BuildContext context) {
    String courseCategory;
    Widget coursesWidget;

    // تحديد فئة الدورة بناءً على index
    switch (index) {
      case 0:
        courseCategory = 'Business';
        coursesWidget = const CoursesWidget(rankValue: 'top rated');
        break;
      case 1:
        courseCategory = 'UI/UX';
        coursesWidget = const CoursesWidget(rankValue: 'search for');
        break;
      case 2:
        courseCategory = 'Software Engineer';
        coursesWidget = const CoursesWidget(rankValue: 'top seller');
        break;
      default:
        courseCategory = 'General';
        coursesWidget = const CoursesWidget(rankValue: 'general');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses in $categoryValue'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (index == 0)
              CoursesCategory(
                categoryValue: "Bussiness",
                onSeeAllClicked: () {
                  // التعامل مع حدث "See All"
                },
              ),
            if (index == 1)
              CoursesCategory(
                categoryValue: "UI/UX",
                onSeeAllClicked: () {
                  // التعامل مع حدث "See All"
                },
              ),
            if (index == 2)
              CoursesCategory(
                categoryValue: "Software Engineer",
                onSeeAllClicked: () {
                  // التعامل مع حدث "See All"
                },
              ),
            const SizedBox(height: 20),
            // المسافة بين CoursesCategory و CoursesWidget

            coursesWidget,
          ],
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widgets/courses_category.dart';

// class CoursesByCategoryPage extends StatelessWidget {
//   final String categoryValue;

//   const CoursesByCategoryPage({super.key, required this.categoryValue});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Courses in $categoryValue'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: CoursesCategory(
//           categoryValue: categoryValue,
//           onSeeAllClicked: () {
//             // التعامل مع حدث "See All"
//           },
//         ),
//       ),
//     );
//   }
// }
