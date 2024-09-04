import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/services/pref.service.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/utils/image_utility.dart';
import 'package:flutter_application_1/widgets/custom_elevated_button.dart';
import 'package:flutter_application_1/widgets/onboarding/elevated_button_rounded.dart';
import 'package:flutter_application_1/widgets/onboarding/onboard_indicator.dart';
import 'package:flutter_application_1/widgets/onboarding/onboard_item_widget.dart';

class OnBoardingPage extends StatefulWidget {
  static const String id = 'OnBoardingPage';

  const OnBoardingPage({super.key});

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final Duration _kDuration = const Duration(milliseconds: 300);
  final Curve _kCurve = Curves.ease;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    currentIndex == 3
                        ? TextButton(
                            onPressed: () {
                              _skipFunction(2);
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ))
                        : TextButton(
                            onPressed: () {
                              _skipFunction(3);
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: onChangedFunction,
                  children: const <Widget>[
                    SingleChildScrollView(
                      child: OnBoardItemWidget(
                        title: 'Certification and Badges',
                        image: ImageUtility.badges,
                        description:
                            'Earn a certificate after completion of every course',
                      ),
                    ),
                    SingleChildScrollView(
                      child: OnBoardItemWidget(
                        title: 'Progress Tracking',
                        image: ImageUtility.progresTraking,
                        description: 'Check your Progress of every course',
                      ),
                    ),
                    SingleChildScrollView(
                      child: Expanded(
                        child: OnBoardItemWidget(
                          title: 'Offline Access',
                          image: ImageUtility.offLine,
                          description: 'Offline Access',
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: OnBoardItemWidget(
                          title: 'Course Catalog',
                          image: ImageUtility.curseCategory,
                          description: 'View in which courses you are enrolled',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        OnBoardIndicator(
                          positionIndex: 0,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(width: 10),
                        OnBoardIndicator(
                          positionIndex: 1,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(width: 10),
                        OnBoardIndicator(
                          positionIndex: 2,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(width: 10),
                        OnBoardIndicator(
                          positionIndex: 3,
                          currentIndex: currentIndex,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    _getButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getButtons() {
    return currentIndex == 3
        ? CustomElevatedButton(onPressed: () => _onLogin(), text: 'Login')
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex != 0 && currentIndex != 3)
                  ElevatedButtonRounded(
                    onPressed: previousFunction,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorUtility.grayLight,
                    ),
                  ),
                if (currentIndex != 3)
                  ElevatedButtonRounded(
                    onPressed: nextFunction,
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorUtility.deepYellow,
                    ),
                  ),
              ],
            ),
          );
  }

  void nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  void previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _skipFunction(int index) {
    _pageController.jumpToPage(index);
  }

  void _onLogin() {
    PreferencesService.isOnBoardingSeen = true;
    Navigator.pushReplacementNamed(context, LoginPage.id);
  }
}
