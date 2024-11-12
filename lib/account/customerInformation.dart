import 'package:flutter/material.dart';
import 'package:food_app/api/api_get.dart';
import 'package:food_app/api/api_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customerinformation extends StatefulWidget {
  final dynamic customerId;
  const Customerinformation({Key? key, required this.customerId})
      : super(key: key);

  @override
  State<Customerinformation> createState() => _CustomerinformationState();
}

class _CustomerinformationState extends State<Customerinformation> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  TextEditingController customerNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthYearController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Fetch customer data from API
  Future<void> fetchCustomerData() async {
    final data = await getCustomers(widget.customerId);
    if (data != null) {
      setState(() {
        customerNameController.text = data['CustomerName'] ?? '';
        addressController.text = data['Address'] ?? '';
        phoneController.text = data['Phone'] ?? '';
        birthYearController.text = data['BirthYear']?.toString() ?? '';
        emailController.text = data['Email'] ?? '';
      });
    }
  }

  // Cập nhật thông tin
  Future<void> updateCustomerData() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> updatedData = {
        "CustomerID": prefs.getInt('CustomerID'),
        "CustomerName": customerNameController.text,
        "Address": addressController.text,
        "Phone": phoneController.text,
        "BirthYear": int.tryParse(birthYearController.text),
        "Email": emailController.text
      };
      print(prefs.getInt('CustomerID'));
      await updateCustomerInformation(widget.customerId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer information updated successfully')));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    fetchCustomerData();
    super.initState();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    birthYearController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: birthYearController,
                  decoration: InputDecoration(labelText: 'Birth Year'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateCustomerData,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
