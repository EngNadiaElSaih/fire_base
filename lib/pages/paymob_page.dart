import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

class PayMob extends StatefulWidget {
  const PayMob({super.key});

  @override
  State<PayMob> createState() => _PayMobState();
}

class _PayMobState extends State<PayMob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Method',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorUtility.grayExtraLight, // لون خلفية المستطيل
                borderRadius: BorderRadius.circular(5), // زوايا دائرية للمستطيل
                border: Border.all(
                    color: ColorUtility.grayExtraLight,
                    width: 1), // تحديد حدود المستطيل
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paymob', // نص العنصر
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // لون النص
                    ),
                  ),
                  Icon(
                    Icons.adjust,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtility.deepYellow, // لون المستطيل أصفر
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // مستطيل بدون زوايا دائرية
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 20), // حجم الخط 20
              ),
              child: const Text(
                'CONTINUE',
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
