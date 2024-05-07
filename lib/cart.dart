import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/cart_details.dart';
import 'package:shop/checkout.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/button.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/wishlist.dart';

class CartItem {
  final String name;
  final String description;
  double price;
  final String imageUrl;
  final String size;

  CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.size,
  });

  CartItem.fromJson(Map<dynamic, dynamic> json, this.name, this.description,
      this.price, this.imageUrl, this.size) {
    price = json['price'];
  }
}

// ignore: must_be_immutable
class Cart extends StatefulWidget {
  String username;
  Cart({required this.username});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late String userName;

  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('Users').child('CartItem');

  int totalPrice = 0;
  int itemPrice = 0;
  // DatabaseReference databaseReference = FirebaseDatabase.instance
  //     .ref()
  //     .child("CartItem")
  //     .once()
  //     .then((DataSnapshot snapshot) {
  //       print(snapshot.value);
  //     } as FutureOr Function(DatabaseEvent value)) as DatabaseReference;

/*
dbRef.onValue.listen((event) {
    for(element in event.snapshot.children){
      CartItem item=
    }
  })*/
  @override
  void initState() {
    super.initState();
    initializeData();
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(widget.username)
        .child('CartItem');
    print('$itemPrice qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    print('$totalPrice dddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    //  print('$userName 1111111111111111111111111111111111111111111111111111');
  }

  void initializeData() async {
    setState(() {
      itemPrice = getStringValuesSF();
      totalPrice += itemPrice;
      print("object");
    });
  }

  addStringToSF(
    int abc,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalPrice += abc;
    prefs.setInt('stringValue', totalPrice);
    print("$abc lllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
    print("$totalPrice mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    int? stringValue = prefs.getInt('stringValue');
    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.deepOrange,
        elevation: 0,
        title: const Text('Shopping Cart'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Wishlist()),
              );
            },
            child: const Icon(Icons.favorite),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: Container(
        height: 110,
        color: Colors.deepOrange,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(width: 3, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Checkout(
                            totalPrice: totalPrice,
                          )),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.shopping_cart),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: FirebaseAnimatedList(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map cartitem = snapshot.value as Map;
          cartitem['key'] = snapshot.key;
          return GestureDetector(
            child: listItem(cartitem: cartitem),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CartDetailsPage(product: cartitem)));
            },
          );
        },
        query: dbRef,
      ),
    );
  }

  Widget listItem({required Map cartitem}) {
    itemPrice = cartitem['price'];
    addStringToSF(itemPrice);
    print('$itemPrice');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            child: Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(cartitem['imagePath1']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 10, right: 10, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          cartitem['name'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(cartitem['description']),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          cartitem['discount'],
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 16),
                        ),
                        Row(
                          children: [
                            const Text(
                              '\$',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                            Text(
                              cartitem['price'].toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Button(
                          child: Text('Move to Wishlist'),
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              userName = prefs.getString('user_name') ?? '';
                            });
                            final DatabaseReference database =
                                FirebaseDatabase.instance.refFromURL(
                                    'https://orange-street-default-rtdb.firebaseio.com/');
                            final model = Product(
                                name: cartitem['name'],
                                discount: cartitem['discount'],
                                price: cartitem['price'],
                                description: cartitem['description'],
                                imagePath1: cartitem['imagePath1'],
                                imagePath2: cartitem['imagePath2'],
                                imagePath3: cartitem['imagePath3'],
                                imagePath4: cartitem['imagePath4']);
                            database
                                .child('Users')
                                .child(userName)
                                .child("WishList")
                                .push()
                                .set(model.toJson());
                            DatabaseReference itemRef = FirebaseDatabase
                                .instance
                                .ref()
                                .child('Users')
                                .child(userName)
                                .child('CartItem/${cartitem['key']}');
                            itemRef.remove();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                              content:
                                  Text('${cartitem['name']} Moved to WishList'),
                            ));
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 15,
            child: GestureDetector(
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                setState(() {
                  userName = prefs.getString('user_name') ?? '';
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Removed ${cartitem['name']}')));
                //Remove CartItem from realtime Database
                DatabaseReference itemRef = FirebaseDatabase.instance
                    .ref()
                    .child('Users')
                    .child(userName)
                    .child('CartItem/${cartitem['key']}');
                itemRef.remove();
              },
              child: const Icon(
                Icons.delete,
                weight: 20,
                size: 18,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
