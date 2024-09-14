import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/course_details_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart'; // تأكد من وجود هذا المسار

class CoursesByCategoryPage extends StatelessWidget {
  final String categoryName;

  const CoursesByCategoryPage(
      {Key? key, required this.categoryName, String? categoryValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: course.image != null
                      ? Image.network(
                          course.image!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image,
                          size: 80,
                        ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(course.instructor?.name ?? 'No Instructor'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///stars number////////////

                        if (course.rating == null) const Text('No Rating'),
                        if (course.rating != null)
                          Text(
                            course.rating!.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorUtility.gray,
                            ),
                          ),
                        SizedBox(
                          width: 3,
                        ),
                        ...List.generate(
                          (course.rating ?? 0).floor(),
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        if (course.rating != null && course.rating! % 1 != 0)
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
