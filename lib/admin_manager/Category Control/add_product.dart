import 'package:flutter/material.dart';
import 'package:food_app/api/api_put.dart';

class AddProduct extends StatefulWidget {
  final Map item;

  const AddProduct({Key? key, required this.item}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _thumbnailController = TextEditingController();
  int format = 999;

  Future<void> _postItem() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = {
  "CategoryID": widget.item['CategoryID'],
  "CategoryName": widget.item['CategoryName'],
  "Products": [
    {
      "ProductID": format,
      "ProductName": _nameController.text,
      "Price": _priceController.text,
      "Description": _descriptionController.text,
      "Rate": _rateController.text,
      "ThumbNail": _thumbnailController.text,
    }
  ]
};


      try {
        await updateCategory(widget.item['CategoryID'].toString(), updatedItem);
        Navigator.pop(context, updatedItem);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter details';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(labelText: 'Rate'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _postItem,
                  child: Text('Add Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
