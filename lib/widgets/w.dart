// class CategoriesWidget extends StatelessWidget {
//   final String nameValue;
//   final String description;
//   final String imageUrl;
//   final VoidCallback onSeeAllClicked;

//   CategoriesWidget({
//     required this.nameValue,
//     required this.description,
//     required this.imageUrl,
//     required this.onSeeAllClicked,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onSeeAllClicked,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           children: [
//             Image.network(imageUrl), // عرض الصورة باستخدام URL
//             const SizedBox(height: 10),
//             Text(
//               nameValue,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               description,
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
