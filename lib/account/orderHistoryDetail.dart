import 'package:flutter/material.dart';
import 'package:food_app/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final NumberFormat currencyFormat = NumberFormat("#,##0", "vi_VN");
    final String formattedPrice = currencyFormat.format(widget.item['Price']);
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

          return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh sản phẩm
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: $formattedPrice',
                    style:  TextStyle(
                      fontSize: 14,
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
        },
      ),
    );
  }
}
