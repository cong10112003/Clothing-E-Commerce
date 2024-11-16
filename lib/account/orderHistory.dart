import 'package:flutter/material.dart';
import 'package:food_app/account/orderHistoryDetail.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({Key? key}) : super(key: key);

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  Future<Map<String, dynamic>?>? customerData;
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  Future<void> loadOrderHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final customerID = prefs.getInt('CustomerID');

    if (customerID != null) {
      setState(() {
        customerData = getCustomers(customerID);
      });
    }
  }

  Future<void> _refreshOrderHistoryData() async {
    await loadOrderHistoryData();
  }

  @override
  void initState() {
    loadOrderHistoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order history"),
      ),
      body: Column(
        children: [
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refreshOrderHistoryData,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: customerData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load order history data'));
                } else if (snapshot.hasData) {
                  final ctmData = snapshot.data!; //orHis
                  final OrderHistory = ctmData['OrderHistories'];

                  if (OrderHistory.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have order history",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: OrderHistory.length,
                      itemBuilder: (context, index) {
                        final orderProducts =
                            OrderHistory[index]['OrderProducts'] as List;
                        final product = orderProducts.isNotEmpty
                            ? orderProducts[0]['Product']
                            : null;
                        final orderID = OrderHistory[index]['OrderID'];
                        final orderDate = OrderHistory[index]['OrderDate'];
                        final itemLength = OrderHistory[index]['OrderProducts'];
                        final formattedDate = orderDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(orderDate))
                            : "Unknown date";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Orderhistorydetail(
                                      item: product,
                                      itemLength: itemLength,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Purchase ID: $orderID',
                                      style:  TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black87 : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Date purchase: $formattedDate',
                                      style:  TextStyle(
                                        fontSize: 14,
                                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black87 : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Total quantity: ${orderProducts.length}',
                                      style:  TextStyle(
                                        fontSize: 14,
                                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black87 : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: Text("Order is null"));
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
