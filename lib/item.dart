import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'desc.dart';

// const String _baseURL = 'http://10.0.2.2/nikestore'; // for emulator
const String _baseURL =
    'https://nikeshop-plum.vercel.app/items'; // for physical phone

class Item {
  final String _id; // _id as String
  final String _name;
  final int _price;
  final String _category;
  final String _image;
  final int _qtty;

  Item(this._id, this._name, this._price, this._category, this._image,
      this._qtty);

  @override
  String toString() {
    return '$_name\nPrice: \$$_price';
  }

  String getImage() {
    return _image;
  }

  String details() {
    return '$_name\nPrice: \$$_price\nCategory: $_category\nQuantity left: $_qtty';
  }

  String get name => _name;
}

List<Item> _items = [];
void updateItems() async {
  try {
    final url = Uri.parse('$_baseURL');
    final http.Response response = await http
        .get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    _items.clear(); // clear old products
    print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      // if successful call
      final jsonResponse = convert
          .jsonDecode(response.body); // create dart json object from json array

      // Check if jsonResponse is null or empty
      if (jsonResponse != null && jsonResponse is List) {
        print("Fetched Data:");
        print(jsonResponse);

        // Reverse the list before iterating
        List reversedItems = jsonResponse.reversed.toList();

        for (var row in reversedItems) {
          // Check if each row has the expected fields and they are not null
          if (row['_id'] != null &&
              row['name'] != null &&
              row['price'] != null &&
              row['category'] != null &&
              row['image'] != null &&
              row['qtty'] != null) {
            Item i = Item(
              row['_id'], // _id is a String, no need to parse
              row['name'],
              row['price'], // price is already an integer
              row['category'],
              row['image'],
              row['qtty'], // qtty is already an integer
            );
            _items.insert(0, i); // Insert new items at the start of the list
          } else {
            print("Skipping incomplete item data");
          }
        }

        print("===================");
        print(_items);
        print("===================");
      } else {
        print("Fetched data is not a valid list or is null");
      }
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}

class ShowItems extends StatefulWidget {
  const ShowItems({super.key});

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  @override
  Widget build(BuildContext context) {
    return buildListView();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      updateItems(); // call the updateItems to fetch the data
    });
  }

  ListView buildListView() {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) => ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 5, // Adds shadow for a card-like appearance
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Adjust image size based on screen width
                Image(
                  image: AssetImage(_items[index].getImage()),
                  width: screenWidth > 600
                      ? 150
                      : 100, // Larger images on wider screens
                  height: screenWidth > 600
                      ? 150
                      : 100, // Match the width with height
                  fit: BoxFit.cover, // Ensures image scales properly
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _items[index].name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${_items[index]._price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _items[index]._category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Desc(),
              settings: RouteSettings(arguments: _items[index]),
            ),
          );
        },
      ),
    );
  }
}

class Desc extends StatelessWidget {
  const Desc({super.key});

  @override
  Widget build(BuildContext context) {
    final Item item = ModalRoute.of(context)?.settings.arguments as Item;
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(item.getImage()), width: 250),
            const SizedBox(height: 10),
            Text(
              item.details(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
