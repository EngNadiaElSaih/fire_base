import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/course_details_page.dart';

class CoursesWidget extends StatefulWidget {
  final String rankValue;
  const CoursesWidget({required this.rankValue, super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    super.initState();
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: futureCall,
      builder: (ctx, snapshot) {
        // عند الانتظار للحصول على البيانات
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // عند حدوث خطأ أثناء جلب البيانات
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // تتبع عملية الجلب عبر الطباعة في وحدة التحكم
        print('Rank Value: ${widget.rankValue}');
        print('Documents found: ${snapshot.data?.docs.length}');

        // إذا لم يتم العثور على بيانات
        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(
            child: Text('No courses found'),
          );
        }

        // تحويل المستندات إلى كائنات Course
        var courses = snapshot.data!.docs.map((e) {
          print('Document data: ${e.data()}');
          return Course.fromJson({'id': e.id, ...e.data()});
        }).toList();

        // عرض الدورات في GridView
        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(courses.length, (index) {
            return InkWell(
              onTap: () {
                // الانتقال إلى صفحة تفاصيل الدورة عند الضغط
                Navigator.pushNamed(context, CourseDetailsPage.id,
                    arguments: courses[index]);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(courses[index].title ?? 'No Name'),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
