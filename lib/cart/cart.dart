import 'package:flutter/material.dart';
import 'package:food_app/api/api_delete.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/direct_button.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Future<Map<String, dynamic>?>? cartData;
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  String totalFormatted(List<dynamic> cartProducts) {
    double total = 0;

    // Tính tổng giá trị của giỏ hàng
    for (var cartProduct in cartProducts) {
      final price = cartProduct['Product']['Price'] as num;
      final quantity = cartProduct['Quantity'] as int;
      total += price * quantity;
    }

    // Định dạng tổng giá trị
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    var formattedPrice = currencyFormat.format(total);
    return formattedPrice;
  }

  Future<void> loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartID = prefs.getInt('cartID');

    if (cartID != null) {
      setState(() {
        cartData = getCartByID(cartID);
      });
    }
  }
  //refresh
  Future<void> _refreshCartData() async {
    await loadCartData();
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String cartId, String productID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng hộp thoại
                try {
                  await deleteCartItem(cartId.toString(), productID.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Xóa sản phẩm thành công")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Xóa sản phẩm thất bại")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    loadCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          actions: [
            IconButton(
              icon: const Icon(color: Colors.red, Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshCartData,
              child: FutureBuilder<Map<String, dynamic>?>(
                future: cartData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load cart data'));
                  } else if (snapshot.hasData) {
                    final cart = snapshot.data!;
                    final cartProducts = cart['CartProducts'];

                    if (cartProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have any item",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            bottom_navigation_controller()));
                              },
                              child: Text('Shop Now',
                                  style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = cartProducts[index]['Product'];
                          final quantity = cartProducts[index]['Quantity'];
                          final price = product['Price'];
                          final formattedPrice = formatter.format(price);
                          final cartId = cart['CartID'];
                          final productId = product['ProductID'];

                          return ListTile(
                            leading: Image.network(
                              product['ThumbNail'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product['ProductName']),
                            subtitle: Text(
                              'Price: $formattedPrice | Quantity: $quantity',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, cartId.toString(), productId.toString());
                              },
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(child: Text("Cart is empty"));
                  }
                },
              ),
            )),
            Container(
              color: TColor.primary,
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      FutureBuilder<Map<String, dynamic>?>(
                        future: cartData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final cartProducts = snapshot.data!['CartProducts'];
                            return Text(
                              totalFormatted(cartProducts),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            );
                          } else {
                            return Text(
                              '₫0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DirectButton(text: "Check out", onTap: () {})
                ],
              ),
            )
          ],
        ));
  }
}
