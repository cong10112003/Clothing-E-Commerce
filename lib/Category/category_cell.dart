
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class CategoryCell extends StatelessWidget {
  final Map item;
  const CategoryCell({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item["CategoryName"].toString() ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: TColor.text, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}