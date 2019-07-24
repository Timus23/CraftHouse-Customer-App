import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer/components/cart_products.dart';
import 'package:toast/toast.dart';

class Cart extends StatefulWidget {
  final String token;
  final String userId;
  Cart({@required this.token, @required this.userId});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isItem = false;
  List<dynamic> cartItems;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Shopping cart'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
        future: http.get(Server.cart + widget.userId + '/',
            headers: {'Authorization': 'Token ' + widget.token}),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snap.connectionState == ConnectionState.done) {
            if (snap.data.statusCode == 200) {
              print(snap.data.body);
              cartItems = json.decode(snap.data.body);
              if (cartItems.length == 0) {
                return Container(
                  child: Center(
                    child: Text("No Item"),
                  ),
                );
              } else {
                print(cartItems);
                isItem = true;
                return CartProducts(
                  cartItem: cartItems,
                  token: widget.token,
                );
              }
            }
          }
        },
      ),
    );
  }
}
