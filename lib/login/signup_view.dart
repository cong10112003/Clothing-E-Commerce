import 'package:flutter/material.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/api/api_post.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common/toast.dart';
import 'package:food_app/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtFullname = TextEditingController();
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final account = {
        'AccountID': 1,
        'Username': txtEmail.text,
        'Password': txtPassword.text,
        'CustomerID': 1,
        "Customer": {
          "CustomerName": "",
          "Address": "",
          "Phone": "",
          "BirthYear": null,
          "Email": ""
        }
      };
      try {
        await postAccount(account);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create sucessfully'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create failed'),
        ));
      }
    }
  }

  Future<void> creatCart() async {
    int maxCustomerID = await fetchMaxCustomerID();
    if (_formKey.currentState!.validate()) {
      final cart = {
        'CartID': maxCustomerID,
        'CustomerID': maxCustomerID,
        'CreatedDate': "",
      };
      try {
        await postCart(cart);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create sucessfully'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create failed'),
        ));
      }
    }
  }

  Future<void> creatHistoryOrder() async {
    int maxCustomerID = await fetchMaxCustomerID();
    if (_formKey.currentState!.validate()) {
      final hisOr = {
        'OrderID': maxCustomerID,
        'CustomerID': maxCustomerID,
        'OrderDate': "",
      };
      try {
        await postHistoryOrder(hisOr);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create sucessfully'),
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create failed'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
              child: SizedBox(
            width: media.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: TColor.primary,
                    ),
                  ),
                ),
                Text(
                  "Welcome to\nCloth 'n Chill",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                Text(
                  "Sign up to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.07,
                ),
                LineTextField(
                  controller: txtEmail,
                  hitText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.07,
                ),
                LineTextField(
                  controller: txtPassword,
                  obscureText: true,
                  hitText: "Password",
                ),
                SizedBox(
                  height: media.width * 0.07,
                ),
                LineTextField(
                  controller: txtConfirmPassword,
                  obscureText: true,
                  hitText: "Re Password",
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                RoundButton(
                  title: "Sign up",
                  onPressed: () async {
                    if (txtEmail.text.isEmpty ||
                        txtPassword.text.isEmpty ||
                        txtConfirmPassword.text.isEmpty) {
                      showToast('Please enter all the box');
                      return;
                    }
                    if (txtPassword.text != txtConfirmPassword.text) {
                      showToast('Password not match');
                      return;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(txtEmail.text)) {
                      showToast('Incorrect Email format');
                      return;
                    } else {
                      await _submitForm();
                      await creatCart();
                      await creatHistoryOrder();
                    }
                  },
                  type: RoundButtonType.primary,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
