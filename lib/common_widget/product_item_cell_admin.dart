import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/admin_manager/Category%20Control/put_product.dart';
import 'package:food_app/api/api_delete.dart';
import 'package:food_app/api/api_put.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:intl/intl.dart';

class ProductItemCellAdmin extends StatefulWidget {
  final Map item;
  const ProductItemCellAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductItemCellAdmin> createState() => _ProductItemCellAdminState();
}

class _ProductItemCellAdminState extends State<ProductItemCellAdmin> {
  late Map item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<void> _refresh() async {
    setState(() {
      item = widget.item;
    });
  }

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
                  await _refresh();
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
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
                      color: TColor.text,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final updatedItem = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PutProduct(item: item),
                          ),
                        );
                        if (updatedItem != null) {
                          // Update the item with the new data
                          try {
                            await updateProduct(
                                updatedItem['ProductID'].toString(),
                                updatedItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Product updated successfully')),
                            );
                            await _refresh();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Failed to update Product: $e')),
                            );
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                            context, item['ProductID'].toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
