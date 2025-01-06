import 'package:flutter/material.dart';
import 'item.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {
          Navigator.of(context).pop();

        }, icon: const Icon(Icons.logout)),
        IconButton(onPressed:() {
          setState(() {
            updateItems();
          });
        }
            , icon: Icon(Icons.refresh))
      ],
        backgroundColor: Colors.black,
        title: Center(child: Text('Choose an item', )),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const ShowItems(),
    );
  }
}
