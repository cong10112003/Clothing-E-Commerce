import 'package:flutter/material.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/cart/cart.dart';
import 'package:food_app/common_widget/product_item_cell.dart';
import 'package:food_app/common_widget/line_textfield.dart';
import 'package:food_app/common_widget/popular_food_item_cell.dart';
import 'package:food_app/common_widget/selection_text_view.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/home/collection_food_item_cell.dart';
import 'package:food_app/home/outlet_list_view.dart';
import 'package:food_app/food_detail/product_item_detail_view.dart';
import 'package:food_app/restaurant_detail/restaurant_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSelectCity = false;
  TextEditingController txtSearch = TextEditingController();
  //
  // ItemListViewModel itemListViewModel = ItemListViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // itemListViewModel.fetchFoodList();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.bg,
      body:
          // isSelectCity
          //     ?
          NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    pinned: true,
                    floating: false,
                    centerTitle: false,
                    // leading: IconButton(
                    //   icon: Image.asset(
                    //     "assets/img/back.png",
                    //     width: 24,
                    //     height: 30,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       isSelectCity = false;
                    //     });
                    //   },
                    // ),
                    leading: SizedBox(),
                    leadingWidth: 0,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thành phố Hồ Chí Minh",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: TColor.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "828 Sư Vạn Hạnh, quận 10",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: Image.asset(
                          "assets/img/notification.png",
                          width: 24,
                          height: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectCity = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    elevation: 1,
                    pinned: false,
                    floating: true,
                    primary: false,
                    leading: SizedBox(),
                    leadingWidth: 0,
                    title: RoundTextField(
                      controller: txtSearch,
                      hitText: "Explore your need ...",
                      leftIcon: Icon(Icons.search, color: TColor.gray),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: Trending
                    SelectionTextView(
                      title: "Trending this week",
                      onSeeAllTap: () {},
                    ),
                    SizedBox(
                      height: media.width * 0.6,
                      child: FutureBuilder<List<dynamic>>(
                        future: getProduct(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Lỗi: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("Don't have any item yet"));
                          } else {
                            final items = snapshot.data!
                                .where((item) =>
                                    item is Map &&
                                    item['Rate'] != null &&
                                    item['Rate'] is double &&
                                    item['Rate'] > 4.5)
                                .toList();
                            if (items.isEmpty) {
                              return Center(
                                  child: Text(
                                      'Không có món ăn nào có Rate > 4.5'));
                            }
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var item = items[index] as Map? ?? {};
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductItemDetailView(
                                                    item: item,
                                                  )));
                                    },
                                    child: ProductItemCell(
                                      item: item,
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                    //TODO: Legendary food
                    SelectionTextView(
                      title: "Wearing",
                      onSeeAllTap: () {},
                    ),
                    SizedBox(
                      height: media.width * 0.6,
                      child: FutureBuilder<List<dynamic>>(
                        future: getProduct(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Lỗi: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("Don't have any item yet"));
                          } else {
                            final items = snapshot.data!;
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var item = items[index] as Map? ?? {};
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductItemDetailView(
                                                    item: item,
                                                  )));
                                    },
                                    child: ProductItemCell(
                                      item: item,
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                    // //TODO: Collection
                    SelectionTextView(
                      title: "Accessories",
                      onSeeAllTap: () {},
                    ),
                    // SizedBox(
                    //   height: media.width * 0.6,
                    //   child: FutureBuilder<List<dynamic>>(
                    //     future: getCategories(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return Center(child: CircularProgressIndicator());
                    //       } else if (snapshot.hasError) {
                    //         return Center(
                    //             child: Text('Lỗi: ${snapshot.error}'));
                    //       } else if (!snapshot.hasData ||
                    //           snapshot.data!.isEmpty) {
                    //         return Center(child: Text("Don't have any item yet"));
                    //       } else {
                    //         final items = snapshot.data!;
                    //         return ListView.builder(
                    //             scrollDirection: Axis.horizontal,
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 8),
                    //             itemCount: items.length,
                    //             itemBuilder: (context, index) {
                    //               var item = items[index] as Map? ?? {};
                    //               return GestureDetector(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) =>
                    //                               RestaurantDetailView(
                    //                                 item: item,
                    //                               )));
                    //                 },
                    //                 child: CollectionFoodItemCell(
                    //                   item: item,
                    //                 ),
                    //               );
                    //             });
                    //       }
                    //     },
                    //   ),
                    // ),
                    //TODO: Popular brands
                    SelectionTextView(
                      title: "Trending vendors",
                      onSeeAllTap: () {},
                    ),   
                  ],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Cart()));
        },
        child: Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ),
        backgroundColor: TColor.primary,
      ),
      
    );
  }
  
}
