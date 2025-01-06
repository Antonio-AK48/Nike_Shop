import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:nike_store/user.dart';

const String _baseURL = 'https://nikeshop-plum.vercel.app'; // For emulator
// const String _baseURL = 'http://192.168.1.10:3000'; // For physical phone

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

String category = '';

class _AddItemState extends State<AddItem> {
  List<String> categories = [
    "Select Category", // Placeholder option
    "shoes",
    "pants",
    "jackets"
  ];

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerImage = TextEditingController();
  final TextEditingController _controllerQtty = TextEditingController();

  bool _loading = false;

  void update(String text, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });

    if (success) {
      // Navigate to the User page if success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const User(),
        ),
      );
    }
  }

  bool validateFields() {
    if (_controllerName.text.isEmpty ||
        _controllerPrice.text.isEmpty ||
        category == 'Select Category' ||
        _controllerImage.text.isEmpty ||
        _controllerQtty.text.isEmpty) {
      update("Please fill out all the fields.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Center(child: Text('Add Item!')),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name',
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter price',
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownMenu(
              width: 200,
              initialSelection: categories[0],
              dropdownMenuEntries:
                  categories.map<DropdownMenuEntry<String>>((String category) {
                return DropdownMenuEntry(
                  value: category,
                  label: category.toString(),
                );
              }).toList(),
              onSelected: (cat) {
                setState(() {
                  category = cat as String;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerImage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Image path',
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerQtty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Quantity',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (validateFields()) {
                  setState(() {
                    _loading = true;
                  });
                  saveItem(
                    update,
                    _controllerName.text.toString(),
                    int.parse(_controllerPrice.text.toString()),
                    category,
                    _controllerImage.text.toString(),
                    int.parse(_controllerQtty.text.toString()),
                  );
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _loading,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

void saveItem(
  Function(String text, {bool success}) update,
  String name,
  int pr,
  String cat,
  String img,
  int qtty,
) async {
  try {
    final response = await http
        .post(
          Uri.parse('$_baseURL/addItems'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode(
            <String, dynamic>{
              // Sending data in the requested format
              'name': name,
              'price': pr,
              'category': cat,
              'image': img,
              'qtty': qtty,
            },
          ),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 201) {
      update("Item added successfully",
          success: true); // Show success and navigate
    } else {
      // Log response body to help identify the error
      update(
          "Failed to add item. Status: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    update("Connection error");
  }
}

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Page'),
      ),
      body: const Center(
        child: Text('Here is the Item page!'),
      ),
    );
  }
}
