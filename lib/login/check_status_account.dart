import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/login/login_page.dart';
import 'package:food_app/navigation_controller/admin_bottom-navigation.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckStatusAccount extends StatefulWidget {
  const CheckStatusAccount({super.key});

  @override
  State<CheckStatusAccount> createState() => _CheckStatusAccountState();
}

class _CheckStatusAccountState extends State<CheckStatusAccount> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('AccountID'));
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    int AccountID = prefs.getInt('AccountID') ?? -1;

    if (isLoggedIn) {
      if (AccountID != 6) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => bottom_navigation_controller()),
        );
      } else if (AccountID == 6) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminBottomNavigation()),
        );
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.primary,
    );
  }
}
