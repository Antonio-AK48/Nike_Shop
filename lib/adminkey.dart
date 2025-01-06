import 'dart:convert' as convert;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addItem.dart';

class AdminKey extends StatefulWidget {
  const AdminKey({super.key});

  @override
  State<AdminKey> createState() => _AdminKeyState();
}

class _AdminKeyState extends State<AdminKey> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout)),
        ],
        backgroundColor: Colors.black,
        title: const Center(
            child: Text(
          'Welcome!',
        )),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            SizedBox(
                width: 200,
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 10)),
                      hintText: 'Enter Key'),
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkKey,
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black)),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 30),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkKey() {
    if (_controller.text.toString() == '1234') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AddItem()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect key! Please try again.')));
    }
  }
}
