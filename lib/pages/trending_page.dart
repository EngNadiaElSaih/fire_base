import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/trending.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  // جلب العناصر الأكثر تداولًا من Firestore
  var futureCall = FirebaseFirestore.instance.collection('trending').get();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending',
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHovered = true; // تعيين الحالة إلى true عند دخول الماوس
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false; // إعادة الحالة إلى false عند خروج الماوس
                  });
                },
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: isHovered
                        ? ColorUtility.deepYellow
                        : Colors.black, // تغيير اللون بناءً على حالة الوقوف
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Trending',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
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

                      if (!snapshot.hasData ||
                          (snapshot.data?.docs.isEmpty ?? false)) {
                        return const Center(
                          child: Text('No trending items found'),
                        );
                      }

                      // تحويل البيانات إلى قائمة من العناصر الأكثر تداولًا
                      var trendingItems = List<Trending>.from(snapshot
                              .data?.docs
                              .map((e) =>
                                  Trending.fromJson({'id': e.id, ...e.data()}))
                              .toList() ??
                          []);

                      return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingItems.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 10,
                              ),
                          itemBuilder: (context, index) {
                            return TrendingItemContainer(
                                trendingItem: trendingItems[index]);
                          });
                    })),
            SizedBox(
              height: 20,
            ),
            Text('Based On Your Search',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
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

                      if (!snapshot.hasData ||
                          (snapshot.data?.docs.isEmpty ?? false)) {
                        return const Center(
                          child: Text('No search results found'),
                        );
                      }

                      var searchItems = List<Trending>.from(snapshot.data?.docs
                              .map((e) =>
                                  Trending.fromJson({'id': e.id, ...e.data()}))
                              .toList() ??
                          []);

                      return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: searchItems.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 10,
                              ),
                          itemBuilder: (context, index) {
                            return TrendingItemContainer(
                                trendingItem: searchItems[index]);
                          });
                    })),
          ]),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}

// عنصر الواجهة الخاص بكل كونتينر
class TrendingItemContainer extends StatefulWidget {
  final Trending trendingItem;

  const TrendingItemContainer({super.key, required this.trendingItem});

  @override
  _TrendingItemContainerState createState() => _TrendingItemContainerState();
}

class _TrendingItemContainerState extends State<TrendingItemContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHovered ? ColorUtility.deepYellow : const Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            widget.trendingItem.name ?? 'No Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
