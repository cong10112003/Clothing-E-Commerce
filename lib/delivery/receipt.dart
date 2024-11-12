import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  var _receipt = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  //Load user information
  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _receipt = prefs.getString('cartReceipt') ?? "Erro";
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25,bottom: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Cảm ơn bạn !", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(_receipt),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}