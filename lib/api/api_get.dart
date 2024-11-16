import 'dart:convert';
import 'package:http/http.dart' as http;

const String FOOD_ITEM = "http://192.168.1.90:3030/api/";
Future<List<dynamic>> fetchData(String endpoint) async {
  final response = await http.get(Uri.parse('$FOOD_ITEM/$endpoint'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

//Item
Future<List<dynamic>> getProduct() async {
  return await fetchData('Products/Get');
}

//Restaurant
Future<List<dynamic>> getCategories() async {
  return await fetchData('Categories/Get');
}

//Account
Future<List<dynamic>> getAccounts() async {
  return await fetchData('Accounts/Get');
}

//get MAX id tài khoản
Future<int> fetchMaxAccountID() async {
  final response = await http.get(Uri.parse('$FOOD_ITEM/Accounts/Get'));

  if (response.statusCode == 200) {
    final List<dynamic> accounts = json.decode(response.body);
    int maxAccountID = accounts
        .map((account) => account['AccountID'])
        .reduce((a, b) => a > b ? a : b);

    return maxAccountID;
  } else {
    throw Exception('Failed to load accounts');
  }
}

//get MAX id khách hàng
Future<int> fetchMaxCustomerID() async {
  final response = await http.get(Uri.parse('$FOOD_ITEM/Accounts/Get'));

  if (response.statusCode == 200) {
    final List<dynamic> customers = json.decode(response.body);
    int maxCustomerID = customers
        .map((customers) => customers['CustomerID'])
        .reduce((a, b) => a > b ? a : b);

    return maxCustomerID;
  } else {
    throw Exception('Failed to load accounts');
  }
}

//get email được tạo mới nhất
Future<String> fetchNewestEmail() async {
  final response = await http.get(Uri.parse('$FOOD_ITEM/Accounts/Get'));

  if (response.statusCode == 200) {
    final List<dynamic> accounts = json.decode(response.body);

    if (accounts.isEmpty) {
      throw Exception('No accounts found');
    }

    // Tìm idTK lớn nhất
    final highestAccount =
        accounts.reduce((a, b) => a['AccountID'] > b['AccountID'] ? a : b);

    // Trả về username của idTK lớn nhất
    return highestAccount['Username'];
  } else {
    throw Exception('Failed to load accounts');
  }
}

//Get thông tin customer theo ID
// Hàm để lấy thông tin của khách hàng
Future<Map<String, dynamic>?> getCustomers(int customerId) async {
  final url = Uri.parse('$FOOD_ITEM/Customers/Get/$customerId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Failed to fetch customer data: ${response.statusCode}');
    return null;
  }
}

Future<Map<String, dynamic>?> getCustomerInfo(int customerID) async {
  final url = Uri.parse('$FOOD_ITEM/Customers/Get/$customerID');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final Map<String, dynamic> customerData = json.decode(response.body);
    return {
      "CustomerName": customerData['CustomerName'],
      "Email": customerData['Email']
    };
  } else {
    throw Exception('Failed to load accounts');
  }
}

//get maxID product
Future<int> fetchMaxProductID() async {
  final response = await http.get(Uri.parse('$FOOD_ITEM/Products/Get'));

  if (response.statusCode == 200) {
    final List<dynamic> accounts = json.decode(response.body);
    int maxAccountID = accounts
        .map((account) => account['ProductID'])
        .reduce((a, b) => a > b ? a : b);

    return maxAccountID;
  } else {
    throw Exception('Failed to load accounts');
  }
}

//get cart by id
Future<Map<String, dynamic>?> getCartByID(int cartID) async {
  final url = Uri.parse('$FOOD_ITEM/Carts/GetCart/$cartID');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load cart');
  }
}
//get OrderHistory by id
Future<Map<String, dynamic>?> getOrderHistoryByID(int orHisID) async {
  final url = Uri.parse('$FOOD_ITEM/OrderHistories/GetOrderHistory/$orHisID');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load cart');
  }
}

//get current order id
Future<dynamic> getEmptyOrderProductIDs(int customerID) async {
  final url = Uri.parse('$FOOD_ITEM/Customers/Get/$customerID');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    final orderHistories = data['OrderHistories'] as List<dynamic>;

    // Lọc các OrderID có OrderProducts rỗng
    final emptyOrderProductIDs = orderHistories
        .where((order) => (order['OrderProducts'] as List).isEmpty)
        .map((order) => order['OrderID'] as int)
        .toList();

    // Trả về OrderID đầu tiên hoặc null nếu không có OrderID nào
    return emptyOrderProductIDs.isNotEmpty ? emptyOrderProductIDs.first : null;
  } else {
    throw Exception('Failed to fetch OrderID');
  }
}


