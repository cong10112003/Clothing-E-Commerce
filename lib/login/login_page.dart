import 'package:flutter/material.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/login/forgot_password.dart';
import 'package:food_app/login/signup_view.dart';
import 'package:food_app/navigation_controller/admin_bottom-navigation.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (txtEmail.text.isEmpty || txtPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(txtEmail.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email không đúng định dạng')),
      );
      return;
    }
    final accounts = await getAccounts();
    final email = txtEmail.text;
    final password = txtPassword.text;

    final account = accounts.firstWhere(
      (account) =>
          account['Username'] == email && account['Password'] == password,
      orElse: () => null,
    );

    if (account != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setInt('AccountID', account['AccountID']); //Lưu id
      prefs.setInt('CustomerID', account['CustomerID']); //CustomerID
      prefs.setInt('cartID', account['Customer']['Carts'][0]['CartID']); //Lưu cartID
      prefs.setInt('orHisID', account['Customer']['OrderHistories'][0]['OrderID']); //Lưu orderID
      print(prefs.getInt('cartID'));
      await prefs.setString(
          'CustomerName', account['Customer']['CustomerName']); //Lưu id
      await prefs.setString(
          'CustomerEmail', account['Customer']['Email']); //Lưu id
      if (account['AccountID'] != 6) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => bottom_navigation_controller()),
          (Route<dynamic> route) => false,
        );
      } else if (account['AccountID'] == 6) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminBottomNavigation()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      // Handle login failure (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User or password incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: SafeArea(
              child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Welcome to Cloth 'n chill",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sign in to continute",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtEmail,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.primary),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtPassword,
                  obscureText: true,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.primary),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Text(
                        "Forgot password ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(TColor.primary),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      handleLogin();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You're new ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpView()));
                      },
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 129, 251, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: Image(
                              image: AssetImage("assets/img/meta.png"),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Login with Facebook",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
