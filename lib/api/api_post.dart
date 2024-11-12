
import 'package:http/http.dart' as http;
import 'dart:convert';
const String FOOD_ITEM = "http://192.168.1.90:3030/api/";

//Category
Future<void> postCategory(Map<String, dynamic> category) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/Categories/PostCategory'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(category),
  );

  if (response.statusCode == 201) {
    print('Product posted successfully');
  } else {
    throw Exception('Failed to post product');
  }
}
//Product
Future<void> postProduct(Map<String, dynamic> product) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/Products/PostProduct'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(product),
  );

  if (response.statusCode == 201) {
    print('Product posted successfully');
  } else {
    throw Exception('Failed to post product');
  }
}
//account
Future<void> postAccount(Map<String, dynamic> account) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/Accounts/PostAccount'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(account),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print('Product posted successfully');
  } else {
    throw Exception('Failed to post product');
  }
}
//create Cart
Future<void> postCart(Map<String, dynamic> cart) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/Carts/PostCart'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(cart),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print('Cart posted successfully');
  } else {
    throw Exception('Failed to post cart');
  }
}
//Create history order
Future<void> postHistoryOrder(Map<String, dynamic> hisOr) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/OrderHistories/PostOrderHistory'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(hisOr),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print('HisOr posted successfully');
  } else {
    throw Exception('Failed to post HisOr');
  }
}
//Post item into cart
Future<void> addToCart(Map<String, dynamic> itemToCart) async {
  final response = await http.post(
    Uri.parse('$FOOD_ITEM/CartProducts/PostCartProduct'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(itemToCart),
  );

  if (response.statusCode == 201) {
    print('Added to cart successfully');
  } else {
    throw Exception('Failed to Add to cart ');
  }
}
