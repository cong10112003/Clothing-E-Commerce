import 'package:intl/intl.dart';

Future<void> postOrderHistory(
  Future<Map<String, dynamic>?> cartData,
  Function postOrder,
  Function showSnackBar,
) async {
  // Lấy dữ liệu giỏ hàng từ `cartData`
  if (cartData != null) {
    final cart = await cartData; // Đợi dữ liệu cart load xong
    if (cart != null) {
      final cartProducts = cart['CartProducts'] as List;

      // Tạo mảng `OrderProducts`
      final orderProducts = cartProducts.map((cartProduct) {
        final product = cartProduct['Product'];
        final quantity = cartProduct['Quantity'];
        final priceAtPurchase = product['Price'];
        final productId = product['ProductID'];
        return {
          'OrderID': 0,
          'ProductID': productId,
          'Quantity': quantity,
          'PriceAtPurchase': priceAtPurchase,
        };
      }).toList();

      // Tạo JSON `OrderHistory`
      final orderHistory = {
        "OrderID": 0,
        "CustomerID": 0, // Thay đổi nếu có CustomerID thật
        "OrderDate": DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
        "OrderProducts": orderProducts,
      };

      try {
        // Gửi dữ liệu đến API
        await postOrder(orderHistory); // Giả định `postOrder` là hàm gửi API
        showSnackBar("Order placed successfully");
      } catch (e) {
        showSnackBar("Failed to place order");
      }
    }
  }
}
