import 'package:flutter/material.dart';

import 'package:flutter_application_1/blocs/course/course_bloc.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/widgets/course_options_widgets.dart';
import 'package:flutter_application_1/widgets/lecture_chips.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsPage extends StatefulWidget {
  static const String id = 'course_details';
  final Course course;
  const CourseDetailsPage({required this.course, super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.course.videoUrl!)
          ..initialize().then((_) {
            setState(() {}); // Update the UI when the video is initialized
          });

    context.read<CourseBloc>().add(CourseFetchEvent(widget.course));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<CourseBloc, CourseState>(builder: (ctx, state) {
          if (state is! LectureState) return const SizedBox();
          var stateEx = state is LectureChosenState ? state : null;
          return SizedBox(
            height: 250,
            child: _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<CourseBloc, CourseState>(
            buildWhen: (previous, current) => current is LectureState,
            builder: (context, state) {
              var applyChanges = (state is LectureChosenState) ? true : false;
              return AnimatedContainer(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: applyChanges
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))
                        : null),
                duration: const Duration(seconds: 3),
                alignment: Alignment.bottomCenter,
                height: applyChanges
                    ? MediaQuery.sizeOf(context).height - 220
                    : null,
                curve: Curves.easeInOut,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.course.title ?? 'No Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.course.instructor?.name ??
                              'No Instructor Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: BlocBuilder<CourseBloc, CourseState>(
                              buildWhen: (previous, current) => false,
                              builder: (ctx, state) {
                                print('>>>>>>>>build $state');
                                return Column(
                                  children: [
                                    LectureChipsWidget(
                                      selectedOption:
                                          (state is CourseOptionStateChanges)
                                              ? state.courseOption
                                              : null,
                                      onChanged: (courseOption) {
                                        context.read<CourseBloc>().add(
                                            CourseOptionChosenEvent(
                                                courseOption));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: (state
                                                is CourseOptionStateChanges)
                                            ? CourseOptionsWidgets(
                                                course: context
                                                    .read<CourseBloc>()
                                                    .course!,
                                                courseOption:
                                                    state.courseOption,
                                                onLectureChosen: (lecture) {
                                                  context
                                                      .read<CourseBloc>()
                                                      .add(LectureChosenEvent(
                                                          lecture));
                                                },
                                              )
                                            : const SizedBox.shrink())
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
