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
  bool isLoading = true;
  Course? selectedCourse;

  Course? get course => null; // لحفظ الكورس الذي تم اختياره

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
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (selectedCourse != null) // عرض تفاصيل الكورس إذا كان موجودًا
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Hero(
                                tag: selectedCourse?.image ?? '',
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    selectedCourse?.image ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCourse!.title ?? 'No Title',
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
                                  Text(
                                    '${selectedCourse?.instructor?.name ?? 'No Instructor'}',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  if (selectedCourse?.rating == null)
                                    const Text('No Rating'),
                                  if (selectedCourse?.rating != null)
                                    Row(
                                      children: [
                                        Text(
                                          selectedCourse!.rating!.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorUtility.gray,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        // عرض النجوم بناءً على التقييم
                                        ...List.generate(
                                          selectedCourse!.rating!.floor(),
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                        // عرض نصف نجمة إذا كان التقييم يحتوي على كسر
                                        if (selectedCourse!.rating! % 1 != 0)
                                          const Icon(
                                            Icons.star_half,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        // النجوم الفارغة المتبقية
                                        ...List.generate(
                                          5 - selectedCourse!.rating!.ceil(),
                                          (index) => const Icon(
                                            Icons.star_border,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Text(
                                'Price: \$${selectedCourse?.price ?? 'No Price'}',
                                style: TextStyle(
                                    fontSize: 18, color: ColorUtility.main),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCourse = course; // تعيين الكورس
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtility.grayExtraLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 15),
                            ),
                            child: const Text(
                              'Remove',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => PayMob()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtility.deepYellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                            ),
                            child: const Text(
                              'Checkout',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Price: \$${selectedCourse?.price ?? 'No Price'}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (selectedCourse == null) // عرض الكورسات إذا لم يتم اختيار كورس
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          if (course.rating == null)
                                            const Text('No Rating'),
                                          if (course.rating != null)
                                            Text(
                                              course.rating!.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: ColorUtility.gray,
                                              ),
                                            ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          ...List.generate(
                                            course.rating?.floor() ?? 0,
                                            (index) => const Icon(
                                              Icons.star,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ),
                                          if (course.rating != null &&
                                              course.rating! % 1 != 0)
                                            const Icon(
                                              Icons.star_half,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ...List.generate(
                                            5 - course.rating!.ceil(),
                                            (index) => const Icon(
                                              Icons.star_border,
                                              color: Colors.green,
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
                                        backgroundColor:
                                            ColorUtility.grayExtraLight,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 15),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          buyNowAction(
                                              course); // استدعاء نفس الدالةيين الكورس
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorUtility.deepYellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
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

  ///دالة الاستدعاء لنفس الزر
  void buyNowAction(Course course) {
    setState(() {
      selectedCourse = course; // تعيين الكورس
    });
  }
}
