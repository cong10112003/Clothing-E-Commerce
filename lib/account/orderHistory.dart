import 'package:flutter/material.dart';
import 'package:food_app/account/orderHistoryDetail.dart';
import 'package:food_app/api/api_get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({Key? key}) : super(key: key);

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  Future<Map<String, dynamic>?>? orHisData;
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  Future<void> loadOrderHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final orHisID = prefs.getInt('orHisID');

    if (orHisID != null) {
      setState(() {
        orHisData = getOrderHistoryByID(orHisID);
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
              future: orHisData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load order history data'));
                } else if (snapshot.hasData) {
                  final orHis = snapshot.data!;
                  final orderProducts = orHis['OrderProducts'];

                  if (orderProducts.isEmpty) {
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
                      itemCount: orderProducts.length,
                      itemBuilder: (context, index) {
                        final product = orderProducts[index]['Product'];
                        //final quantity = orderProducts[index]['Quantity'];
                        //final priceAtPurchase = orderProducts[index]['PriceAtPurchase'];
                        /// formattedPrice =formatter.format(priceAtPurchase);
                        final orderID = orHis['OrderID'];
                        final orderDate = orHis['OrderDate'];

                        return ListTile(
                          title: Text('Đơn hàng mã số: $orderID'),
                          subtitle: Text(
                            'Ngày đặt hàng: $orderDate',
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Orderhistorydetail(item: product, itemLength: orderProducts,)));
                          },
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
