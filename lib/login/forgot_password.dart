import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff20D994),
                  ),
                ),
              ),
              Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff173143),
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Retrieve Your Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff9D9D9D),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                    obscureText: true,
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
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(TColor.primary),
                      ),
                      child: Text(
                        'Send me',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                      },
                    ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}