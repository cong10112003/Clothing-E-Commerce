import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/delivery/receipt.dart';
import 'package:food_app/home/home_view.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng đang được xử lý..."),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Receipt(),
            FilledButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(TColor.primary),),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => bottom_navigation_controller()));
                },
                child: Text("Tiếp tục mua sắm", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            ),
          ],
        ));
  }
}
