import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:url_launcher/url_launcher.dart';

class PayMob extends StatefulWidget {
  const PayMob({super.key});

  @override
  State<PayMob> createState() => _PayMobState();
}

class _PayMobState extends State<PayMob> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Your Payment Method',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isPressed = !isPressed; // تغيير الحالة عند الضغط
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isPressed
                      ? Colors.white
                      : ColorUtility.grayExtraLight, // لون الخلفية
                  borderRadius: BorderRadius.circular(5), // زوايا دائرية
                  border: Border.all(
                    color: isPressed
                        ? Colors.yellow
                        : ColorUtility.grayExtraLight, // لون الإطار
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paymob', // نص العنصر
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isPressed
                            ? ColorUtility.deepYellow
                            : Colors.black, // لون النص
                      ),
                    ),
                    Icon(
                      Icons.adjust,
                      color: isPressed
                          ? ColorUtility.deepYellow
                          : ColorUtility.grayExtraLight, // لون الأيقونة
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     PaymobPayment.instance.initialize(
            //       apiKey: dotenv.env[
            //           'apiKey']!, // from dashboard Select Settings -> Account Info -> API Key
            //       integrationID: int.parse(dotenv.env[
            //           'integrationID']!), // from dashboard Select Developers -> Payment Integrations -> Online Card ID
            //       iFrameID: int.parse(dotenv.env[
            //           'iFrameID']!), // from paymob Select Developers -> iframes
            //     );

            //     final PaymobResponse? response =
            //         await PaymobPayment.instance.pay(
            //       context: context,
            //       currency: "EGP",
            //       amountInCents: "20000", // 200 EGP
            //     );

            //     if (response != null) {
            //       print('Response: ${response.transactionID}');
            //       print('Response: ${response.success}');
            //     }
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: ColorUtility.deepYellow, // لون المستطيل أصفر
            //     shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.circular(10), // مستطيل بدون زوايا دائرية
            //     ),
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 40, vertical: 20), // حجم الخط 20
            //   ),
            //   child: const Text(
            //     'CONTINUE',
            //     style: TextStyle(fontSize: 20, color: Colors.white),
            //   ),
            // ),

            ElevatedButton(
              onPressed: () async {
                const url = 'https://accept.paymob.com';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtility.deepYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            SizedBox(height: 10), // Add space between the title and the list.
          ]),
        ),
      ),
    );
  }
}
