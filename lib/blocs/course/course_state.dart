part of 'course_bloc.dart';

@immutable
abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLecturesFetched extends CourseState {
  final List<Lecture> lectures;

  CourseLecturesFetched(this.lectures);
}

class CourseLecturesEmpty extends CourseState {}

class CourseOptionStateChanges extends CourseState {
  final CourseOptions courseOptions;

  CourseOptionStateChanges(this.courseOptions);
}
