import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';

class LabelWidget extends StatefulWidget {
  final String name;
  final void Function()? onSeeAllClicked;
  const LabelWidget({required this.name, this.onSeeAllClicked, super.key});

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          InkWell(
            onTap: widget.onSeeAllClicked,
            child: MouseRegion(
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
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isHovered ? ColorUtility.deepYellow : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
