import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/trending.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
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
              icon:
                  const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                          itemBuilder: (context, index) => InkWell(
                                onTap: () async {
                                  // تنفيذ التنقل إلى صفحة جديدة تحتوي على التفاصيل المتعلقة بالعنصر المتداول
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Text(
                                        trendingItems[index].name ?? 'No Name',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ));
                    })),
          ]),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
