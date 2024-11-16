import 'package:flutter/material.dart';
import 'package:food_app/api/api_post.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/round_button.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtNameCatgory = TextEditingController();
  int format = 1;
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final account = {
        'CategoryID': format,
        'CategoryName': txtNameCatgory.text,
      };
      try {
        await postCategory(account);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create sucessfully'),
        ));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Create failed'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adding Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: txtNameCatgory,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.primary),
                    ),
                  labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              RoundButton(
                onPressed: _submitForm,
                title: 'Add Category',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
