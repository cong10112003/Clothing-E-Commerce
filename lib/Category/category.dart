import 'package:flutter/material.dart';
import 'package:food_app/Category/category_detail_view.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/Category/category_cell.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                floating: false,
                centerTitle: false,
                leadingWidth: 0,
                title: Row(
                  children: [
                    Image.asset(
                      "assets/img/discovery_icon.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Category",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.text,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: FutureBuilder<List<dynamic>>(
            future: getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Don't have any category yet"));
              } else {
                final items = snapshot.data!;
                return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index] as Map? ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryDetailView(item: item),
                            ),
                          );
                        },
                        child: CategoryCell(
                          item: item,
                        ),
                      );
                    });
              }
            },
          )),
    );
  }
}
