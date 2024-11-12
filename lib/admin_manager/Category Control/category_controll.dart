import 'package:flutter/material.dart';
import 'package:food_app/Category/category_cell.dart';
import 'package:food_app/Category/category_detail_view.dart';
import 'package:food_app/admin_manager/Category%20Control/add_category.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';

class CategoryControll extends StatefulWidget {
  const CategoryControll({super.key});

  @override
  State<CategoryControll> createState() => _CategoryControllState();
}

class _CategoryControllState extends State<CategoryControll> {
  late Future<List<dynamic>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = getCategories();
  }

  Future<void> _refreshCategories() async {
    setState(() {
      _categoryFuture = getCategories();
    });
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product Controll",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.text,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCategory()));
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: SizedBox(
            child: RefreshIndicator(
              onRefresh: _refreshCategories,
              child: FutureBuilder<List<dynamic>>(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return ListView( // Bọc ListView để có thể refresh khi danh sách trống
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text("Don't have any category yet"),
                ),
              ),
            ],
          );
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
                          return GestureDetector(
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
                              ));
                        });
                  }
                },
              ),
            ),
          )),
    );
  }
}
