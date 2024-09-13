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

  const CourseOptionsWidgets({
    required this.courseOption,
    required this.course,
    required this.onLectureChosen,
    super.key,
  });

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  List<Lecture>? lectures;
  bool isLoading = false;
  Lecture? selectedLecture;
  Map<int, bool> pressedStates = {};

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      //////////////////lecture////////
      case CourseOptions.Lecture:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (lectures == null || lectures!.isEmpty) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: selectedLecture?.id == lectures![index].id
                        ? ColorUtility.deepYellow
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lectures![index].title ?? 'No Name',
                                style: TextStyle(
                                    color: selectedLecture?.id ==
                                            lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              IconButton(
                                icon: selectedLecture?.id == lectures![index].id
                                    ? Icon(Icons.download, color: Colors.white)
                                    : Icon(Icons.download),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                lectures![index].description ??
                                    'No Description',
                                style: TextStyle(
                                    color: selectedLecture?.id ==
                                            lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'lorem ipsum dolor sit \n amet consectetur.',
                                style: TextStyle(
                                    color: selectedLecture?.id ==
                                            lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    lectures![index].duration?.toString() ??
                                        'No Duration',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'min',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                              IconButton(
                                iconSize: 50,
                                icon: selectedLecture?.id == lectures![index].id
                                    ? Icon(Icons.play_circle_outline,
                                        color: Colors.white)
                                    : Icon(Icons.play_circle_outline),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
////////////////download/////
      case CourseOptions.Download:
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: selectedLecture?.id == lectures![index].id
                        ? ColorUtility.deepYellow
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lectures![index].title ?? 'No Name',
                                style: TextStyle(
                                    color: selectedLecture?.id ==
                                            lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              IconButton(
                                icon: selectedLecture?.id == lectures![index].id
                                    ? Icon(
                                        Icons.download_done,
                                        color: Colors.white,
                                      )
                                    : Icon(Icons.download_done),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                lectures![index].description ??
                                    'No Description',
                                style: TextStyle(
                                    color: selectedLecture?.id ==
                                            lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'lorem ipsum dolor sit \n amet consectetur.',
                                  style: TextStyle(
                                      color: selectedLecture?.id ==
                                              lectures![index].id
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    lectures![index].duration?.toString() ??
                                        'No Duration',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'min',
                                    style: TextStyle(
                                        color: selectedLecture?.id ==
                                                lectures![index].id
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                              IconButton(
                                iconSize: 50,
                                icon: selectedLecture?.id == lectures![index].id
                                    ? Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                      )
                                    : Icon(Icons.play_circle_outline),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
////cerfificate///////////////
      case CourseOptions.Certificate:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Builder(
                  builder: (context) {
                    User? user = FirebaseAuth
                        .instance.currentUser; // الحصول على المستخدم الحالي
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            alignment: Alignment.bottomCenter,
                            // title: const Text("Certificate Information"),
                            content: Container(
                              height: 350,
                              width: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  // خلفية الصورة
                                  Positioned.fill(
                                    child: Image.asset(
                                      // height: 300,
                                      // width: 250,
                                      'assets/images/cert2.png', // مسار الصورة
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // النصوص فوق الصورة
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        const SizedBox(height: 8),
                                        const Text(
                                          "This Certifies That",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff858383),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
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
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Has Successfully Completed the Wallace Training \n Program, Entitled",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff858383),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          widget.course.title ??
                                              'No Title', // عرض اسم الدورة
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Issued on ${DateTime.now().toLocal().toString().split(' ')[0]}", // تنسيق التاريخ
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Virginia M. Patterson',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlusJakartaSans', // تحديد الخط
                                            fontSize: 20,
                                            color: Colors
                                                .yellow, // لتحديد لون النص بالأصفر
                                            fontWeight: FontWeight
                                                .w400, // اختر الوزن المناسب
                                          ),
                                        ),
                                        const Text(
                                          "Calvin E. McGinnis",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff477B72),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Director, Wallace Training Program",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff858383),
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
                                  // تنفيذ إجراءات عند الضغط على "Print"
                                  Navigator.of(context).pop(); // إغلاق الديالوج
                                },
                                child: const Text("Print"),
                              ),
                            ],
                          );
                        },
                      );
                    });

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ],
        );

///////////////////more////////////
      case CourseOptions.More:
        return ListView(
          children: [
            buildCategoryItem(context, 0, 'About Instractor'),
            buildCategoryItem(context, 1, 'Course Resources'),
            buildCategoryItem(context, 2, 'Share This Course'),
          ],
        );

      default:
        return const Center(
          child: Text('Invalid option'),
        );
    }
  }

  Widget buildCategoryItem(BuildContext context, int index, String title) {
    bool isPressed = pressedStates[index] ?? false;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              pressedStates[index] = !isPressed;
            });
            if (!isPressed) {
              // Fetch data from Firestore or perform another action
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPressed ? Colors.white : ColorUtility.grayExtraLight,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isPressed ? Colors.yellow : ColorUtility.grayExtraLight,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPressed ? ColorUtility.deepYellow : Colors.black,
                  ),
                ),
                Icon(
                  isPressed
                      ? Icons.keyboard_double_arrow_down_sharp
                      : Icons.keyboard_double_arrow_right_sharp,
                  color: isPressed ? ColorUtility.deepYellow : Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        if (isPressed)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title == 'About Instractor')
                  Column(
                    children: [
                      Text('About Instractor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorUtility.deepYellow,
                          )),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 25),
                          const SizedBox(width: 4),
                          Text(
                              widget.course.instructor?.name ?? 'No Instructor',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.deepYellow,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("years_of_experience:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.main,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              widget.course.instructor?.years_of_experience
                                      .toString() ??
                                  'years_of_experience',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.deepYellow,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Graduation_from:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.main,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              widget.course.instructor?.graduation_from ??
                                  'graduation_from',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorUtility.deepYellow,
                              )),
                        ],
                      ),
                    ],
                  ),
                if (title == 'Course Resources')
                  Text('Course Resources Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorUtility.main,
                      )),
                if (title == 'Share This Course')
                  Text('Do You Want Share This Course?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorUtility.main,
                      )),
                const SizedBox(height: 20),
              ],
            ),
          ),
      ],
    );
  }
}
