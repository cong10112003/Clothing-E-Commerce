import 'package:flutter/material.dart';
import 'package:food_app/admin_manager/Account%20Control/account_control.dart';
import 'package:food_app/Order%20List/order_list.dart';
import 'package:food_app/account/account.dart';
import 'package:food_app/admin_manager/Category%20Control/category_controll.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({super.key});

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Các trang tương ứng với các tab
          CategoryControll(),
          OrderList(),
          AccountControl(),
          Account(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: TColor.primary,
          padding: EdgeInsets.all(16),
          gap: 8,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Product',
            ),
            GButton(
              icon: Icons.map_outlined,
              text: 'OrderList',
            ),
            GButton(
              icon: Icons.rate_review,
              text: 'Account',
            ),
            GButton(
              icon: Icons.person,
              text: 'Settings',
            ),
          ],
          selectedIndex:
              _currentIndex, // Thêm dòng này để đồng bộ giá trị _currentIndex với tab được chọn
          onTabChange: (index) {
            _onTabSelected(
                index); // Gọi phương thức _onTabSelected khi tab được chọn
          },
        ),
      ),
    );
  }
}
