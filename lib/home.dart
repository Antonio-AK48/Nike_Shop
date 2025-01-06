import 'package:flutter/material.dart';
import 'user.dart';
import 'adminkey.dart';
import 'item.dart';
import 'addItem.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.black,
        title: Center(child: Text('Welcome!', )),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),

            Image(image: AssetImage('images/nike.png'), width: 270),
            SizedBox(height: 70,),
            ElevatedButton(
                onPressed:() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const User()));
                },
                child: Text('Enter Shop!', style: TextStyle(color: Colors.white, fontSize: 30),),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
            
            ),
            // SizedBox(height: 200,),
            SizedBox(height: 70,),

            // Image(image: AssetImage('images/nike.png'), width: 270),
            SizedBox(height: 70,),


          ],
        ),
      ),
      bottomSheet:  TextButton(

          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminKey()));
            // builder: (context) => AddItem()));
          },
          child: Text('Are you an admin? Press Here!', style: TextStyle(color: Colors.black, fontSize: 20),)),
    );
  }
}
