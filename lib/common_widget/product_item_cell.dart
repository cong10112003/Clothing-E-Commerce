import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:food_app/admin_manager/Category%20Control/put_product.dart';
import 'package:food_app/api/api_delete.dart';
import 'package:food_app/api/api_put.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductItemCell extends StatelessWidget {
  
  final Map item;
  const ProductItemCell({Key? key, required this.item}) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng hộp thoại
                try {
                  await deleteItem(productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Xóa sản phẩm thành công")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Xóa sản phẩm thất bại")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    var media = MediaQuery.of(context).size;
    String imageString = item['ThumbNail'] ?? "";
    bool isValidImageUrl = Uri.tryParse(imageString)?.isAbsolute ?? false;

    Uint8List? _base64ToUint8List(String base64String) {
      try {
        return base64Decode(base64String);
      } catch (e) {
        return null;
      }
    }

    Widget _buildImage() {
      if (isValidImageUrl) {
        return Image.network(
          imageString,
          fit: BoxFit.cover,
          width: media.width * 0.4,
          height: media.width * 0.3,
        );
      } else {
        Uint8List? imageBytes = _base64ToUint8List(imageString);
        if (imageBytes != null) {
          return Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            width: media.width * 0.4,
            height: media.width * 0.3,
          );
        } else {
          return Icon(
            Icons.image,
            color: Colors.grey[600],
            size: media.width * 0.3,
          );
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: media.width * 0.4,
      height: media.width * 0.7,
      decoration: BoxDecoration(
        color: themeProvider.themeMode == ThemeMode.light ? Colors.white : Colors.black87,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: themeProvider.themeMode == ThemeMode.light
          ? Colors.grey.shade300 
          : Colors.grey.shade700,
      width: 1.5, // Độ dày viền
    ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              color: TColor.secondary,
              width: media.width * 0.4,
              height: media.width * 0.3,
              child: _buildImage(),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["ProductName"].toString() ?? "Null",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light ? TColor.text : TColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item["Description"].toString() ?? "null",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  "${currencyFormat.format(item['Price' ?? ""])}" ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
