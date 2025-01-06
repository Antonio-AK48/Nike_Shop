import 'package:flutter/material.dart';
import 'item.dart';

class Desc extends StatefulWidget {
  const Desc({super.key});

  @override
  State<Desc> createState() => _DescState();
}

class _DescState extends State<Desc> {
  @override
  Widget build(BuildContext context) {
    Item itm = ModalRoute.of(context)!.settings.arguments as Item;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text(itm.name,)),

      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Image(image: AssetImage(itm.getImage()), width: 200),
            Text(itm.details(), style: (TextStyle(fontSize: 30)),),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){}, 
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black), ),
                child: Text('BUY NOW!', style: TextStyle(fontSize: 40),))
          ],
        ),
      ),
    );
  }
}

