import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigator_bar.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Trending'),
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(children: [
          const Text('All Courses'),
          SizedBox(height: 16),
        ]),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}
