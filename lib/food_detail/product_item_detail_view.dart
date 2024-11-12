import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:food_app/api/api_post.dart';
import 'package:food_app/cart/cart.dart';
import 'package:food_app/common_widget/icon_text_button.dart';
import 'package:food_app/common_widget/img_text_button.dart';
import 'package:food_app/common_widget/selection_text_view.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extension.dart';

class ProductItemDetailView extends StatefulWidget {
  final Map item;
  const ProductItemDetailView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ProductItemDetailView> createState() => _FoodItemDetailViewState();
}

class _FoodItemDetailViewState extends State<ProductItemDetailView> {
  final _formKey = GlobalKey<FormState>();
  // Quantity
  int quantityCount = 1;

  //minus quantity
  void minusQuantity() {
    setState(() {
      if (quantityCount > 0) {
        quantityCount--;
      }
    });
  }

  //plus quantity
  void plusQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  //Show alert successfully add to cart
  void showSuccessAlert() {
    CoolAlert.show(
        title: "Thành công!!!",
        confirmBtnColor: TColor.primary,
        backgroundColor: TColor.alertBackColor,
        context: context,
        type: CoolAlertType.success,
        text: "Đã thêm vào giỏ hàng");
  }

  void _addToCart() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final cart = {
        "CartID": prefs.getInt('cartID'),
        "ProductID": widget.item['ProductID'],
        "Quantity": quantityCount,
      };
      try {
        await addToCart(cart);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added sucessfully'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added failed'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    //format tien
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: media.width * 0.667,
                floating: false,
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        width: media.width,
                        height: media.width * 0.667,
                        color: TColor.secondary,
                        child: Image.network(
                          widget.item['ThumbNail'].toString() ?? "",
                          width: media.width,
                          height: media.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context)
                            .padding
                            .top, // Để đặt nút dưới thanh trạng thái
                        left: 8.0, // Khoảng cách từ mép trái
                        child: IconButton(
                          icon: Image.asset(
                            "assets/img/back.png",
                            width: 24,
                            height: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item['ProductName'].toString() ?? "null",
                            textAlign: TextAlign.left,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: TColor.text,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: TColor.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.item['Rate'].toString() ?? "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconTextButton(
                          title: "Share",
                          subTitle: "603",
                          icon: "assets/img/share.png",
                          onPressed: () {},
                        ),
                        IconTextButton(
                          title: "Review",
                          subTitle: "953",
                          icon: "assets/img/review.png",
                          onPressed: () {},
                        ),
                        IconTextButton(
                          title: "Photo",
                          subTitle: "115",
                          icon: "assets/img/photo.png",
                          onPressed: () {},
                        ),
                        IconTextButton(
                          title: "Bookmark",
                          subTitle: "1478",
                          icon: "assets/img/bookmark_detail.png",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        color: Colors.white,
                        height: media.width * 0.7,
                        child: Container(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.item["Description"]
                                                    .toString() ??
                                                "Null",
                                            textAlign: TextAlign.left,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: TColor.gray,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            //price
                                            Text(
                                              "${currencyFormat.format(widget.item['Price' ?? ""])}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            //minus
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: TColor.alertBackColor,
                                                  shape: BoxShape.circle),
                                              child: IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: minusQuantity,
                                              ),
                                            ),
                                            //quantily
                                            SizedBox(
                                              width: 40,
                                              child: Center(
                                                child: Text(
                                                  quantityCount.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            //plus
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: TColor.alertBackColor,
                                                  shape: BoxShape.circle),
                                              child: IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: plusQuantity,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Order now
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // Add to cart
                                        SizedBox(
                                          width: 300,
                                          height: 50,
                                          child: FilledButton(
                                            onPressed: () {
                                              //Xử lý dự kiện add sản phẩm và số lượng vào giỏ hàng
                                              _addToCart();
                                            },
                                            child: Text("Thêm vào giỏ hàng"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color?>(
                                                      TColor.orderColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Divider(
                    height: 10, // Chiều cao của Divider
                    thickness: 4, // Độ dày của Divider
                    color: TColor.primary, // Màu sắc của Divider
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            widget.item["ThumbNail"].toString() ?? "",
                            width: media.width,
                            height: media.width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: media.width,
                          height: media.width * 0.2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.black54, Colors.transparent]),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Order food Online",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SelectionTextView(
                    title: "Photos",
                    actionTitle: "See all",
                    onSeeAllTap: () {},
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ImgTextButton(
                              title: "Food",
                              subTitle: "(80)",
                              image: "assets/img/c1.png",
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: ImgTextButton(
                              title: "Ambience",
                              subTitle: "(25)",
                              image: "assets/img/c2.png",
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: ImgTextButton(
                              title: "Menu",
                              subTitle: "(10)",
                              image: "assets/img/c3.png",
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: ImgTextButton(
                              title: "All Photos",
                              subTitle: "(115)",
                              image: "assets/img/l1.png",
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    height: 4,
                    color: TColor.gray,
                  ),

                  SelectionTextView(
                    title: "Details",
                    actionTitle: "Read All",
                    onSeeAllTap: () {},
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Call",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "(212 789-7898)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cuisines",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "Pizza Italian",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Average Cost",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "\$20 - \$40",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),

                  // //TODO: Trending this week
                  // SelectionTextView(
                  //   title: "Same Restaurants",
                  //   onSeeAllTap: () {},
                  // ),

                  // SizedBox(
                  //   height: media.width * 0.6,
                  //   child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       padding: const EdgeInsets.symmetric(horizontal: 8),
                  //       itemCount: trendingArr.length,
                  //       itemBuilder: (context, index) {
                  //         var fObj = trendingArr[index] as Map? ?? {};

                  //         return GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => RestaurantDetailView(
                  //                           fObj: fObj,
                  //                         )));
                  //           },
                  //           child: FoodItemCell(
                  //             fObj: fObj,
                  //           ),
                  //         );
                  //       }),
                  // ),
                ],
              ),
            ),
          )),
    );
  }
}
