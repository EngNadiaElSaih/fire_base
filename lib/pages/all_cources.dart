// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AllCourses extends StatelessWidget {
//   const AllCourses({super.key});

//   // جلب الكورسات من Firestore
//   Stream<QuerySnapshot> getCourses() {
//     return FirebaseFirestore.instance.collection('courses').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Courses'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: getCourses(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No courses available'));
//           }

//           final courses = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: courses.length,
//             itemBuilder: (context, index) {
//               var course = courses[index].data() as Map<String, dynamic>;

//               return Card(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: ListTile(
//                   leading: Image.network(
//                     course["image"] ?? 'https://via.placeholder.com/50',
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(course["title"] ?? 'Course Title'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(course["instructor"] ?? 'Instructor'),
//                       const SizedBox(height: 4),
//                       Text('Price: ${course["price"]}\$',
//                           style: const TextStyle(color: Colors.green)),
//                     ],
//                   ),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('${course["rating"] ?? 0} ★',
//                           style: const TextStyle(
//                               color: Colors.orange,
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       const Icon(Icons.arrow_forward_ios, size: 16),
//                     ],
//                   ),
//                   onTap: () {
//                     // التنقل إلى صفحة تفاصيل الكورس
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllCourses extends StatelessWidget {
  const AllCourses({super.key});

  // جلب الكورسات من Firestore
  Stream<QuerySnapshot> getCourses() {
    return FirebaseFirestore.instance.collection('courses').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var course = courses[index].data() as Map<String, dynamic>;

              // التحقق من نوع البيانات إذا كانت خريطة
              if (course['image'] is Map) {
                print('The image field is a map: ${course['image']}');
                // يمكنك الوصول إلى البيانات داخل الخريطة إذا كان هذا هو الحال
              }

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(
                    // تأكد من أن الحقل 'image' هو String وليس Map
                    course["image"] is String
                        ? course["image"]
                        : 'https://via.placeholder.com/50',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(course["title"] ?? 'Course Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course["instructor"] ?? 'Instructor'),
                      const SizedBox(height: 4),
                      Text('Price: ${course["price"] ?? 'Unknown'}\$',
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${course["rating"] ?? 0} ★',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    // التنقل إلى صفحة تفاصيل الكورس
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
