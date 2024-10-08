import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/pages/coursesby_category_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';

//////from //home page///to /////CoursesByCategoryPage////
class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key, required Null Function() onSeeAllClicked});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();
  Category? selectedcategory;
  int? hoveredIndex; // متغير لتخزين الفهرس عند الوقوف عليه بالماوس

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder(
        future: futureCall,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          var categories = List<Category>.from(snapshot.data?.docs
                  .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemBuilder: (context, index) {
              var category = categories[index];

              ///تغير لون ال3 كونتاينرز فى حالة الوقوف عليها بالماوس
              return MouseRegion(
                onEnter: (_) {
                  setState(() {
                    hoveredIndex = index; // تعيين الفهرس عند دخول الماوس
                  });
                },
                onExit: (_) {
                  setState(() {
                    hoveredIndex = null; // إعادة الفهرس عند خروج الماوس
                  });
                },
                child: InkWell(
                  onTap: () {
                    // التنقل إلى صفحة CoursesByCategoryPage مع تمرير اسم الفئة
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursesByCategoryPage(
                          categoryName:
                              category.name ?? 'No Name', // تمرير اسم الفئة
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedcategory?.name == category.name ||
                              hoveredIndex == index
                          ? ColorUtility.deepYellow
                          : const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        category.name ?? 'No Name',
                        style: TextStyle(
                          color: selectedcategory == category.name ||
                                  hoveredIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
