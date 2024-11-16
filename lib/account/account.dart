import 'package:flutter/material.dart';
import 'package:food_app/account/customerInformation.dart';
import 'package:food_app/account/orderHistory.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/icon_text_button.dart';
import 'package:food_app/common_widget/menu_row.dart';
import 'package:food_app/login/login_page.dart';
import 'package:food_app/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _customerName = "";
  String _Email = "";
  dynamic _customerID = "";
  dynamic customerId = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
    fetchCustomerData();
  }

  //Load user information
  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerID = prefs.getInt('CustomerID') ?? "";
      customerId = _customerID;
    });
  }

  Future<void> fetchCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      int? customerID = prefs.getInt('CustomerID');
      if (customerID != null) {
        Map<String, dynamic>? customerInfo = await getCustomerInfo(customerID);
        if (customerInfo != null) {
          setState(() {
            _customerName = customerInfo['CustomerName'] ??
                'Unknown'; // Gán giá trị CustomerName
            _Email = customerInfo['Email'] ?? 'No email'; // Gán giá trị Email
          });
        }
      } else {
        print('CustomerID is null');
      }
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }

  //Logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _refreshCartData() async {
    await fetchCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.light ? TColor.bg : Colors.black12,
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Sửa",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: media.width,
              decoration:  BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(media.width * 0.125),
                      child: Container(
                        color: TColor.secondary,
                        child: Image.asset(
                          "assets/img/u1.png",
                          width: media.width * 0.25,
                          height: media.width * 0.25,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Text(
                      _customerName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: media.width * 0.025,
                    ),
                    Text(
                      _Email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration:  BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTextButton(
                    icon: "assets/img/network.png",
                    title: "System",
                    subTitle: "603",
                    onPressed: () {},
                  ),
                  IconTextButton(
                    icon: "assets/img/review.png",
                    title: "My reviews",
                    subTitle: "953",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration:  BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
              child: Column(
                children: [
                  MenuRow(
                    icon: "assets/img/payment.png",
                    title: "Order history",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Orderhistory()));
                    },
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  MenuRow(
                    icon: "assets/img/find_friends.png",
                    title: "Information",
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Customerinformation(customerId: customerId),
                        ),
                      );
                      if (result != null) {
                        String customerName = result['customerName'];
                        String email = result['email'];

                        // Cập nhật lại customerName và email
                        setState(() {
                          customerName = _customerName;
                          email = _Email;
                        });
                        await _refreshCartData();
                      }
                    },
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  MenuRow(
                    icon: "assets/img/settings.png",
                    title: "Settings",
                    onPressed: () {},
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  ),
                  MenuRow(
                    icon: "assets/img/sign_out.png",
                    title: "Log out",
                    onPressed: () {
                      _logout();
                    },
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
