import 'package:flutter/material.dart';

class Orderhistorydetail extends StatefulWidget {
  final Map item;
  final List<dynamic> itemLength;
  const Orderhistorydetail({
    Key? key,
    required this.item,
    required this.itemLength,
  }) : super(key: key);

  @override
  State<Orderhistorydetail> createState() => _OrderhistorydetailState();
}

class _OrderhistorydetailState extends State<Orderhistorydetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: ListView.builder(
        itemCount: widget.itemLength.length,
        itemBuilder: (context, index) {
          final productName = widget.item['ProductName'];
          final price = widget.item['Price'];
          final thumbnail = widget.item['ThumbNail'];

          return ListTile(
            leading: thumbnail != null
                ? Image.network(thumbnail)
                : const Icon(Icons.image),
            title: Text(productName),
            subtitle: Text('Price: $price ₫'),
          );
        },
      ),
    );
  }
}
