import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/course_details_page.dart'; // تأكد من وجود هذا المسار

class CoursesByCategoryPage extends StatelessWidget {
  final String categoryName;

  const CoursesByCategoryPage(
      {Key? key, required this.categoryName, String? categoryValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses in $categoryName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('category.name',
                isEqualTo: categoryName) // البحث حسب اسم الفئة
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No courses found.'));
          }

          final courses = snapshot.data!.docs.map((doc) {
            return Course.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                leading: course.image != null
                    ? Image.network(course.image!, width: 50, height: 50)
                    : const Icon(Icons.image),
                title: Text(course.title ?? 'No Title'),
                subtitle: Text('${course.price} ${course.currency}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsPage(course: course),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
