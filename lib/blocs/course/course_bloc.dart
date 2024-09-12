import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/models/lecture.dart';
import 'package:flutter_application_1/utils/app_enums.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<CourseFetchEvent>(_onGetCourse);
    on<CourseOptionChosenEvent>(_onCourseOptionChosen);
  }

  Course? course;

  // تعديل: هنا جلب المحاضرات من Firebase Firestore
  Future<List<Lecture>?> getLectures() async {
    if (course == null) {
      return null;
    }
    try {
      var result = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course!.id)
          .collection('lectures')
          .get();

      return result.docs
          .map((e) => Lecture.fromJson({
                'id': e.id,
                ...e.data(),
              }))
          .toList();
    } catch (e) {
      print('Error fetching lectures: $e');
      return null;
    }
  }

  FutureOr<void> _onGetCourse(
      CourseFetchEvent event, Emitter<CourseState> emit) async {
    course = event.course; // قم بتحديث الدورة الحالية

    // بعد تحميل الدورة، قم بجلب المحاضرات
    List<Lecture>? lectures = await getLectures();
    if (lectures != null && lectures.isNotEmpty) {
      emit(CourseLecturesFetched(lectures)); // إرسال الحالة مع المحاضرات
    } else {
      emit(CourseLecturesEmpty()); // إرسال حالة فارغة إذا لم توجد محاضرات
    }
  }

  FutureOr<void> _onCourseOptionChosen(
      CourseOptionChosenEvent event, Emitter<CourseState> emit) {
    emit(CourseOptionStateChanges(event.courseOptions));
  }
}
