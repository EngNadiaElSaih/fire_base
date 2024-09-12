import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class AllCourses extends StatefulWidget {
  const AllCourses({Key? key}) : super(key: key);

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  bool isLoading = true;
  bool isImageDisplayed = true; // لتثبيت الصورة أثناء التحميل
  List<double> progressValues = [];

  @override
  void initState() {
    super.initState();
    // تأخير عرض البيانات لمدة 3 ثوانٍ
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isImageDisplayed = false;
      });
    });
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

        // Initialize progress values for each course
        progressValues = List<double>.filled(courses.length, 0.0);
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
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Courses'),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: 50, // العرض
              height: 50, // الارتفاع
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorUtility.grayExtraLight,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'All',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (FirebaseAuth.instance.currentUser != null)
              Expanded(
                child: isLoading || isImageDisplayed
                    ? Center(
                        child: Image.asset(
                          'assets/images/frame.png', // تأكد من وجود الصورة في مجلد assets
                          fit: BoxFit.cover,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          var course = filteredCourses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(course.title ?? "No title",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      Row(
                                        children: [
                                          Icon(Icons.person, size: 16),
                                          const SizedBox(width: 4),
                                          Text(course.instructor?.name ??
                                              'No Instructor'),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Update progress on tap
                                            progressValues[index] += 0.2;
                                            if (progressValues[index] > 1.0) {
                                              progressValues[index] = 1.0;
                                            }
                                          });
                                        },
                                        child: Text(
                                          progressValues[index] == 0
                                              ? 'Start your course'
                                              : 'Continue',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      LinearProgressIndicator(
                                        backgroundColor:
                                            ColorUtility.grayExtraLight,
                                        value: progressValues[index],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                ColorUtility.deepYellow),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
