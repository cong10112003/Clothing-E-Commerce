import 'package:flutter/material.dart';
import 'package:food_app/account/account.dart';
import 'package:food_app/news/news.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/Category/category.dart';
import 'package:food_app/home/home_view.dart';
import 'package:food_app/new_arrival/new_arrival.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class bottom_navigation_controller extends StatefulWidget {
  const bottom_navigation_controller({super.key});

  @override
  State<bottom_navigation_controller> createState() =>_bottom_navigation_controllerState();
}

class _bottom_navigation_controllerState extends State<bottom_navigation_controller> {
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
          HomeView(),
          Category(),
          TopFoodie(),
          // News(),
          Account()
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
              text: 'Home',
            ),
            GButton(
              icon: Icons.map_outlined,
              text: 'Category',
            ),
            GButton(
              icon: Icons.rate_review,
              text: 'New Arrival',
            ),
            // GButton(
            //   icon: Icons.bookmark,
            //   text: 'News',
            // ),
            GButton(
              icon: Icons.person,
              text: 'Account',
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
