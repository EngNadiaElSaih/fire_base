import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/courses_category.dart';

class CoursesByCategoryPage extends StatelessWidget {
  final String categoryValue;

  const CoursesByCategoryPage({super.key, required this.categoryValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses in $categoryValue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CoursesCategory(
          categoryValue: categoryValue,
          onSeeAllClicked: () {
            // التعامل مع حدث "See All"
          },
        ),
      ),
    );
  }
}
