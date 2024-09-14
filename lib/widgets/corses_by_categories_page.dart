// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widgets/courses_category.dart';
// import 'package:flutter_application_1/widgets/courses_widget.dart'; // تأكد من استيراد هذا
// ///لعرض ال3 حالات كلا على حدى///ربنا يسهل
// class CoursesByCategoryPage extends StatelessWidget {
//   final int index;
//   final String categoryValue;

//   const CoursesByCategoryPage(
//       {super.key, required this.index, required this.categoryValue});

//   @override
//   Widget build(BuildContext context) {
//     String courseCategory;
//     String pageTitle;
//     Widget coursesWidget;

//     // تحديد العنوان والدورات بناءً على الفهرس
//     switch (index) {
//       case 0:
//         courseCategory = 'Bussiness';
//         pageTitle = 'Top Rated Business Courses';
//         coursesWidget = const CoursesWidget(rankValue: 'top rated');
//         break;
//       case 1:
//         courseCategory = 'UI/UX';
//         pageTitle = 'Search for UI/UX Courses';
//         coursesWidget = const CoursesWidget(rankValue: 'search for');
//         break;
//       case 2:
//         courseCategory = 'Software Engineer';
//         pageTitle = 'Top Seller Software Engineer Courses';
//         coursesWidget = const CoursesWidget(rankValue: 'top seller');
//         break;
//       default:
//         courseCategory = 'General';
//         pageTitle = 'General Courses';
//         coursesWidget = const CoursesWidget(rankValue: 'general');
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(pageTitle), // عرض العنوان بناءً على الفئة
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // عرض فئة الدورات بناءً على الفهرس
//             CoursesCategory(
//               categoryValue: '',
//               onSeeAllClicked: () {
//                 // التعامل مع حدث "See All"
//               },
//             ),
//             const SizedBox(height: 20),
//             // عرض تفاصيل الدورات بناءً على الفهرس
//             Expanded(
//                 child: CoursesCategory(
//                     categoryValue: categoryValue, onSeeAllClicked: () {})
//                 // coursesWidget,
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_1/widgets/courses_category.dart';
// // import 'package:flutter_application_1/widgets/courses_widget.dart'; // تأكد من استيراد هذا

// // class CoursesByCategoryPage extends StatelessWidget {
// //   final int index;
// //   final String categoryValue;

// //   const CoursesByCategoryPage(
// //       {super.key, required this.index, required this.categoryValue});

// //   @override
// //   Widget build(BuildContext context) {
// //     String courseCategory;
// //     Widget coursesWidget;

// //     // تحديد فئة الدورة بناءً على index
// //     switch (index) {
// //       case 0:
// //         courseCategory = 'UI/UX';
// //         coursesWidget = const CoursesWidget(rankValue: 'search for');
// //         break;
// //       case 1:
// //         courseCategory = 'Software Engineer';
// //         coursesWidget = const CoursesWidget(rankValue: 'top seller');
// //         break;
// //       case 2:
// //         courseCategory = 'Business';
// //         coursesWidget = const CoursesWidget(rankValue: 'top rated');

// //         break;
// //       default:
// //         courseCategory = 'General';
// //         coursesWidget = const CoursesWidget(rankValue: 'general');
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Courses in $categoryValue'),
// //       ),
// //       backgroundColor: Colors.white,
// //       body: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // عرض فئة الدورات بناءً على الفهرس
// //             CoursesCategory(
// //               categoryValue: courseCategory,
// //               onSeeAllClicked: () {
// //                 // التعامل مع حدث "See All"
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //             // عرض تفاصيل الدورات بناءً على الفهرس
// //             Expanded(
              
// //               if(case==0),
// //               child: coursesWidget,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_1/widgets/courses_category.dart';
// // import 'package:flutter_application_1/widgets/courses_widget.dart'; // تأكد من استيراد هذا

// // class CoursesByCategoryPage extends StatelessWidget {
// //   final int index;
// //   final String categoryValue;

// //   const CoursesByCategoryPage(
// //       {super.key, required this.index, required this.categoryValue});

// //   @override
// //   Widget build(BuildContext context) {
// //     String courseCategory;
// //     Widget coursesWidget;

// //     // تحديد فئة الدورة بناءً على index
// //     switch (index) {
// //       case 0:
// //         courseCategory = 'Business';
// //         coursesWidget = const CoursesWidget(rankValue: 'top rated');
// //         break;
// //       case 1:
// //         courseCategory = 'UI/UX';
// //         coursesWidget = const CoursesWidget(rankValue: 'search for');
// //         break;
// //       case 2:
// //         courseCategory = 'Software Engineer';
// //         coursesWidget = const CoursesWidget(rankValue: 'top seller');
// //         break;
// //       default:
// //         courseCategory = 'General';
// //         coursesWidget = const CoursesWidget(rankValue: 'general');
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Courses in $categoryValue'),
// //       ),
// //       backgroundColor: Colors.white,
// //       body: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Column(
// //           children: [
// //             if (index == 0)
// //               CoursesCategory(
// //                 categoryValue: "Bussiness",
// //                 onSeeAllClicked: () {
// //                   // التعامل مع حدث "See All"
// //                 },
// //               ),
// //             if (index == 1)
// //               CoursesCategory(
// //                 categoryValue: "UI/UX",
// //                 onSeeAllClicked: () {
// //                   // التعامل مع حدث "See All"
// //                 },
// //               ),
// //             if (index == 2)
// //               CoursesCategory(
// //                 categoryValue: "Software Engineer",
// //                 onSeeAllClicked: () {
// //                   // التعامل مع حدث "See All"
// //                 },
// //               ),
// //             const SizedBox(height: 20),
// //             // المسافة بين CoursesCategory و CoursesWidget
// //             if (index == 0) Text("1"),
// //             if (index == 1) Text("2"),
// //             if (index == 2) coursesWidget,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }





