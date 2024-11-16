import 'dart:convert';

import 'package:http/http.dart' as http;

const String FOOD_ITEM = "http://192.168.1.90:3030/api/";
// Product
Future<void> updateProduct(String productId, Map<String, dynamic> updatedProduct) async {
  final url = Uri.parse('$FOOD_ITEM/Products/PutProduct/$productId');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedProduct),
  );

  if (response.statusCode == 204) {
    print('Product updated successfully');
  } else {
    print(
        'Failed to update Product. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to update item');
  }
}

// Category
Future<void> updateCategory(String CategoryId, Map<String, dynamic> updatedCategory) async {
  final url = Uri.parse('$FOOD_ITEM/Categories/PutCategory/$CategoryId');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedCategory),
  );

  if (response.statusCode == 204) {
    print('Item updated successfully');
  } else {
    print(
        'Failed to update item. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to update item');
  }
}

// Customer Information
Future<void> updateCustomerInformation(
    dynamic CustomerId, Map<String, dynamic> updatedData) async {
  final url = Uri.parse('$FOOD_ITEM/Customers/PutCustomer/$CustomerId');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedData),
  );

  if (response.statusCode == 204) {
    print('Information updated successfully');
  } else {
    print(
        'Failed to update item. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to update item');
  }
}
