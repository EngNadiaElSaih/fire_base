import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/course/course_bloc.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/models/lecture.dart';
import 'package:flutter_application_1/utils/app_enums.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseOptionsWidgets extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;
  const CourseOptionsWidgets(
      {required this.courseOption,
      required this.course,
      required this.onLectureChosen,
      super.key});

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Lecture>? lectures;
  bool isLoading = false;
  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Lecture? selectedLecture;

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      //start from here first case//////////////////////////////////
      case CourseOptions.Lecture:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (lectures == null || (lectures!.isEmpty)) {
          return const Center(
            child: Text('No lectures found'),
          );
        } else {
          return GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(lectures!.length, (index) {
              return InkWell(
                onTap: () {
                  widget.onLectureChosen(lectures![index]);
                  selectedLecture = lectures![index];
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedLecture?.id == lectures![index].id
                        ? ColorUtility.deepYellow
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      lectures![index].title ?? 'No Name',
                      style: TextStyle(
                          color: selectedLecture?.id == lectures![index].id
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              );
            }),
          );
        }

      case CourseOptions.Download:
        return const SizedBox.shrink(
          child: Text("hi ana hona"),
        );
////cerfificate///////////////
      case CourseOptions.Certificate:
        User? user =
            FirebaseAuth.instance.currentUser; // الحصول على المستخدم الحالي
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Certificate Information"),
                content: Container(
                  height: 300,
                  width: 420,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // خلفية الصورة
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/cert2.png', // مسار الصورة
                          fit: BoxFit.cover,
                        ),
                      ),
                      // النصوص فوق الصورة
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Certificate Of Completion",
                              style: TextStyle(
                                fontSize: 21,
                                color: Color(0xff1D1B20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "This Certifies That",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff858383),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.displayName?.isNotEmpty == true
                                  ? user!.displayName!
                                  : 'No Name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff477B72),
                              ),
                            ),
                            const Text(
                              "Has Successfully Completed the Wallace Training",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff858383),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Program, Entitled",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff858383),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.course.title ??
                                  'No Title', // عرض اسم الدورة
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Issued on ${DateTime.now().toLocal().toString().split(' ')[0]}", // تنسيق التاريخ
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Calvin E. McGinnis",
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff477B72),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Virginia M. Patterson",
                              style: TextStyle(
                                fontSize: 23,
                                color: Color(0xff858383),
                                fontWeight: FontWeight.bold,
                                fontFamily: "PlusJakartaSans",
                              ),
                            ),
                            Text(
                              "Issued on ${DateTime.now().toLocal().toString().split(' ')[0]}", // تنسيق التاريخ
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // إغلاق الديالوج
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      // تنفيذ إجراءات عند الضغط على "Print" هنا
                      Navigator.of(context).pop(); // إغلاق الديالوج
                    },
                    child: const Text("Print"),
                  ),
                ],
              );
            },
          );
        });

        // Placeholder مؤقتًا
        return const SizedBox.shrink();

//////////////more/////////////////////
      case CourseOptions.More:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
            ),

            ///container1
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Card(
                color: const Color(0xffEBEBEB),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "About Istractor",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditPage(), // استبدل  ال
                          //   ),
                          // );
                        },
                        child:
                            const Icon(Icons.keyboard_double_arrow_right_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //container2
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Card(
                color: const Color(0xffEBEBEB),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Course Resources",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditPage(), // استبدل ا
                          //   ),
                          // );
                        },
                        child:
                            const Icon(Icons.keyboard_double_arrow_right_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //container3
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Card(
                color: const Color(0xffEBEBEB),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Share This Course",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditPage(), // استبدل ا
                          //   ),
                          // );
                        },
                        child:
                            const Icon(Icons.keyboard_double_arrow_right_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      ////////////////////////end
      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }
}
