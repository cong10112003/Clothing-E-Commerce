
import 'package:http/http.dart' as http;

const String FOOD_ITEM = "http://192.168.1.90:3030/api/";

Future<void> deleteItem(String productId) async {
  final url = Uri.parse('$FOOD_ITEM/Products/DeleteProduct/$productId');

  final response = await http.delete(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print('Product deleted successfully');
  } else {
    print(
        'Failed to delete product. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to delete item');
  }
}
//Delete cart item by CartID, ProductID
Future<void> deleteCartItem(String cartId, String productId) async {
  // Tạo URL với các tham số query là cartId và productId
  final url = Uri.parse('$FOOD_ITEM/CartProducts/DeleteCartProduct')
      .replace(queryParameters: {
    'cartId': cartId,
    'productId': productId,
  });

  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Product deleted successfully');
  } else {
    print(
        'Failed to delete product. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to delete item');
  }
}