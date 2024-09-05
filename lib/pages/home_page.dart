import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/categories_widget.dart';
import 'package:flutter_application_1/widgets/courses_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //is me
            Text(
                'Welcome Back! ${FirebaseAuth.instance.currentUser?.displayName}'),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  LabelWidget(
                    name: 'Categories',
                    onSeeAllClicked: () {},
                  ),
                  CategoriesWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Top Rated Courses',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'top rated',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Top Seller Courses',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'top seller',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Students Also Search For ',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'search for',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabelWidget(
                    name: 'Top Courses In IT',
                    onSeeAllClicked: () {},
                  ),
                  const CoursesWidget(
                    rankValue: 'top courses ',
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var imageResult = await FilePicker.platform
                            .pickFiles(type: FileType.image, withData: true);
                        if (imageResult != null) {
                          var storageRef = FirebaseStorage.instance
                              .ref('images/${imageResult.files.first.name}');
                          var uploadResult = await storageRef.putData(
                              imageResult.files.first.bytes!,
                              SettableMetadata(
                                contentType:
                                    'image/${imageResult.files.first.name.split('.').last}',
                              ));

                          if (uploadResult.state == TaskState.success) {
                            var downloadUrl =
                                await uploadResult.ref.getDownloadURL();
                            print('>>>>>Image upload${downloadUrl}');
                          }
                        } else {
                          print('No file selected');
                        }
                      },
                      child: Text('upload Image')),
                  ElevatedButton(
                      onPressed: () async {
                        PaymobPayment.instance.initialize(
                          apiKey: dotenv.env[
                              'apiKey']!, // from dashboard Select Settings -> Account Info -> API Key
                          integrationID: int.parse(dotenv.env[
                              'integrationID']!), // from dashboard Select Developers -> Payment Integrations -> Online Card ID
                          iFrameID: int.parse(dotenv.env[
                              'iFrameID']!), // from paymob Select Developers -> iframes
                        );

                        final PaymobResponse? response =
                            await PaymobPayment.instance.pay(
                          context: context,
                          currency: "EGP",
                          amountInCents: "20000", // 200 EGP
                        );

                        if (response != null) {
                          print('Response: ${response.transactionID}');
                          print('Response: ${response.success}');
                        }
                      },
                      child: Text('paymob pay'))
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
