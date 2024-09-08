import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/paymob_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  bool isAscending = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  Future<void> getCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      if (snapshot.docs.isNotEmpty) {
        courses = snapshot.docs
            .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        filteredCourses = List.from(courses);
      } else {
        courses = [];
        filteredCourses = [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching data: $e'),
      ));
      courses = [];
      filteredCourses = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        var course = filteredCourses[index];
                        return ExpansionTile(
                          title: Row(
                            children: [
                              Hero(
                                tag: course.image ?? '',
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    course.image ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        Icon(Icons.person, size: 16),
                                        const SizedBox(width: 4),
                                        Text(course.instructor?.name ??
                                            'No Instructor'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          course.rating?.floor() ??
                                              0, // توليد عدد النجوم الكاملة
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors
                                                .green, // لون النجمة الخضراء
                                            size: 20,
                                          ),
                                        ),
                                        if (course.rating != null &&
                                            course.rating! % 1 !=
                                                0) // تحقق من وجود نصف نجمة
                                          const Icon(
                                            Icons.star_half,
                                            color:
                                                Colors.green, // نصف نجمة خضراء
                                            size: 20,
                                          ),
                                        ...List.generate(
                                          5 -
                                              course.rating!
                                                  .ceil(), // توليد النجوم البيضاء المتبقية
                                          (index) => const Icon(
                                            Icons.star_border,
                                            color: Colors
                                                .green, // لون النجمة البيضاء
                                            size: 20,
                                          ),
                                        ),
                                        if (course.rating == null)
                                          const Text('No Rating'),
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
                            ],
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorUtility
                                          .grayExtraLight, // لون المستطيل رمادي
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // مستطيل بدون زوايا دائرية
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 15), // حجم الخط 20
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black), // حجم الخط 20
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PayMob()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorUtility
                                          .deepYellow, // لون المستطيل أصفر
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // مستطيل بدون زوايا دائرية
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 15), // حجم الخط 20
                                    ),
                                    child: const Text(
                                      'Buy Now',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
