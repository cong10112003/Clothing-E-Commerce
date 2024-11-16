import 'package:flutter/material.dart';
import 'package:food_app/api/api_delete.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/api/api_post.dart';
import 'package:food_app/api/api_put.dart';
import 'package:food_app/cart/purchase_status.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/direct_button.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';
import 'package:food_app/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _formKey = GlobalKey<FormState>();
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

  // Detele single item
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
                // Lưu lại ScaffoldMessenger trước khi pop
                final messenger = ScaffoldMessenger.of(context);

                Navigator.of(context).pop(); // Đóng hộp thoại
                try {
                  await deleteCartItem(cartId.toString(), productID.toString());
                  messenger.showSnackBar(
                    SnackBar(content: Text("Xóa sản phẩm thành công")),
                  );
                } catch (e) {
                  messenger.showSnackBar(
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

  //delete all item
  Future<void> deleteAllCartItems() async {
    final cart = await cartData;

    if (cart != null) {
      final cartProducts = cart['CartProducts'];
      for (var cartItem in cartProducts) {
        final cartId = cart['CartID'];
        final productId = cartItem['Product']['ProductID'];

        try {
          await deleteCartItem(cartId.toString(), productId.toString());
        } catch (e) {}
      }

      // Refresh the cart data after deletion
      await _refreshCartData();
    }
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa toàn bộ sản phẩm"),
          content: Text(
              "Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text("Xóa tất cả"),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng hộp thoại
                await deleteAllCartItems();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> createNewHistoryOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      final hisOr = {
        'OrderID': prefs.getInt('CustomerID'),
        'CustomerID': prefs.getInt('CustomerID'),
        'OrderDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      };
      try {
        await postHistoryOrder(hisOr);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your order is sucessfully'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your order is failed'),
        ));
      }
    }
  }

  Future<void> addToHistoryOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final customerID = prefs.getInt('CustomerID');
    final cart = await cartData;
    print(cart);
    if (customerID != null) {
      final orderID = await getEmptyOrderProductIDs(customerID);
      print(orderID);
      if (_formKey.currentState!.validate()) {
        for (var cartItem in cart!['CartProducts']) {
          final orderProduct = {
            'OrderID': orderID,
            'ProductID': cartItem['ProductID'],
            'Quantity': cartItem['Quantity'],
            'PriceAtPurchase': cartItem['Product']['Price'],
          };
          try {
            await addOrderProductHistory(orderProduct);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your order is successfully added'),
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your order failed to add'),
            ));
          }
        }
      }
    } else {
      throw Exception('CustomerID is not set');
    }
  }

  @override
  void initState() {
    loadCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          actions: [
            IconButton(
              icon: const Icon(color: Colors.red, Icons.delete),
              onPressed: () {
                _showDeleteAllConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
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

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      themeProvider.themeMode == ThemeMode.light
                                          ? Colors.white
                                          : Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Ảnh sản phẩm
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product['ThumbNail'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Thông tin sản phẩm
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['ProductName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: themeProvider.themeMode ==
                                                      ThemeMode.light
                                                  ? Colors.grey
                                                  : Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Price: $formattedPrice',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Quantity: $quantity',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Nút xóa
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                          context,
                                          cartId.toString(),
                                          productId.toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
                              final cartProducts =
                                  snapshot.data!['CartProducts'];
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
                    DirectButton(
                        text: "Check out",
                        onTap: () async {
                          await createNewHistoryOrder();
                          await addToHistoryOrder();
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
