import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/course_details_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';

class CoursesCategory extends StatefulWidget {
  final String categoryValue;

  const CoursesCategory({
    required this.categoryValue,
    super.key,
    required Null Function() onSeeAllClicked,
  });

  @override
  State<CoursesCategory> createState() => _CoursesCategoryState();
}

class _CoursesCategoryState extends State<CoursesCategory> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    super.initState();
    futureCall = FirebaseFirestore.instance
        .collection('categories')
        .where('category', isEqualTo: widget.categoryValue)
        .get(); // جلب الدورات بناءً على الفئة
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: futureCall,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No courses found'),
          );
        }

        var courses = snapshot.data!.docs.map((e) {
          return Course.fromJson({'id': e.id, ...e.data()});
        }).toList();

        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(courses.length, (index) {
            var course = courses[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CourseDetailsPage.id,
                  arguments: course,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: course.image != null
                          ? Image.network(
                              course.image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      course.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0157db),
                      ),
                    ),
                    Row(
                      children: [
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
                        if (course.rating == null) const Text('No Rating'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(course.instructor?.name ?? 'No Instructor'),
                      ],
                    ),
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
              ),
            );
          }),
        );
      },
    );
  }
}
