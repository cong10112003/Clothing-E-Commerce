import 'package:flutter/material.dart';
import 'package:food_app/payment/cart_payment.dart';

class OptionPayment extends StatefulWidget {
  const OptionPayment({super.key});

  @override
  State<OptionPayment> createState() => _OptionPaymentState();
}

class _OptionPaymentState extends State<OptionPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  const CartPaymanet(),
    );
  }
}
