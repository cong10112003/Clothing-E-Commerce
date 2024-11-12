import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/delivery/delivery.dart';

class CartPaymanet extends StatefulWidget {
  const CartPaymanet({super.key});

  @override
  State<CartPaymanet> createState() => _CartPaymanetState();
}

class _CartPaymanetState extends State<CartPaymanet> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void userTappedPay() {
    //valid
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Confirm Payment"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("Card Number: $cardNumber"),
                    Text("Expiry Date: $expiryDate"),
                    Text("Card Holder Name: $cardHolderName"),
                    Text("CVV: $cvvCode"),
                  ],
                ),
              ),
              actions: [
                //Yes button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    )),
                //Cancel button
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Delivery()));
                    },
                    child: const Text('Yes',
                        style:
                            TextStyle(color: Color.fromRGBO(253, 155, 99, 1))))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 25),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Image.asset(
              "assets/img/back.png",
              width: 24,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              //config
              bankName: 'ACB',
              enableFloatingCard: true,
              floatingConfig: FloatingConfig(
                isGlareEnabled: true,
                isShadowEnabled: true,
                shadowConfig: FloatingShadowConfig(),
              ),
              //body
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView:
                  isCvvFocused, //true when you want to show cvv(back) view
              onCreditCardWidgetChange: (CreditCardBrand
                  brand) {}, // Callback for anytime credit card brand is changed
            ),
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formkey,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(TColor.primary),
                      ),
                      child: Text('Pay Now'),
                      onPressed: userTappedPay)),
            )
          ],
        ),
      ),
    );
  }
}
