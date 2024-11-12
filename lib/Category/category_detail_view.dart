import 'package:flutter/material.dart';
import 'package:food_app/admin_manager/Category%20Control/add_product.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/product_item_cell.dart';
import 'package:food_app/common_widget/product_item_cell_admin.dart';
import 'package:food_app/food_detail/product_item_detail_view.dart';

class CategoryDetailView extends StatefulWidget {
  final Map item;

  const CategoryDetailView({Key? key, required this.item}) : super(key: key);

  @override
  State<CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView> {
  late List<dynamic> _products;
  late Map _categoryInfo;

  @override
  void initState() {
    super.initState();
    _products = widget.item['Products'] as List<dynamic>? ?? [];
    _categoryInfo = widget.item as Map? ?? {};
  }

  Future<void> _refreshProducts() async {
    final updatedData = await getCategories();
    final updatedCategory = updatedData.firstWhere(
      (category) => category['CategoryID'] == widget.item['CategoryID'],
      orElse: () => null,
    );

    setState(() {
      _products = updatedCategory?['Products'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.item['CategoryName'] ?? 'Category'),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProduct(
                              item: _categoryInfo,
                            )));
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: _products.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        "Don't have any item yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              )
            : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          var product =
                              _products[index] as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductItemDetailView(item: product),
                                ),
                              );
                            },
                            child: ProductItemCellAdmin(item: product),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
