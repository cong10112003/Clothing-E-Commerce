import 'package:flutter/material.dart';
import 'package:food_app/api/api_put.dart';

class PutProduct extends StatefulWidget {
  final Map item;

  const PutProduct({Key? key, required this.item}) : super(key: key);

  @override
  State<PutProduct> createState() => _PutProductState();
}

class _PutProductState extends State<PutProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _rateController;
  late TextEditingController _priceController;
  late TextEditingController _thumbnailController;
   @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['ProductName']);
    _descriptionController = TextEditingController(text: widget.item['Description']);
    _rateController = TextEditingController(text: widget.item['Rate'].toString());
    _priceController = TextEditingController(text: widget.item['Price'].toString());
    _thumbnailController = TextEditingController(text: widget.item['ThumbNail']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = {
        'ProductID': widget.item['ProductID'],
        'ProductName': _nameController.text,
        'Price': int.parse(_priceController.text),
        'Description': _descriptionController.text,
        'Rate': int.parse(_rateController.text),
        'ThumbNail': _thumbnailController.text,
      };

      try {
        await updateProduct(widget.item['ProductID'].toString(), updatedItem);
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
        title: Text('Update Product'),
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
                  onPressed: _updateItem,
                  child: Text('Update Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
