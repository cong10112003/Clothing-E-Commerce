
import 'package:flutter/material.dart';
import 'package:food_app/theme_provider.dart';
import 'package:provider/provider.dart';

import '../common/color_extension.dart';

class CategoryCell extends StatelessWidget {
  final Map item;
  const CategoryCell({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color:themeProvider.themeMode == ThemeMode.light ? Colors.white : TColor.primary,
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
                color: themeProvider.themeMode == ThemeMode.light ? TColor.text : Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}