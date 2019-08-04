import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/purchased_products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPurchase extends StatelessWidget {
  Map<String, String> config;
  MyPurchase({@required this.config});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Purchased Products'),
      ),
      body: FutureBuilder(
        future: http.get(Server.myPurchase, headers: config),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snap.connectionState == ConnectionState.done) {
            if (snap.data.statusCode == 200) {
              List<dynamic> item = json.decode(snap.data.body);
              if (item.length == 0) {
                return Container(
                  child: Center(
                    child: Text("No Product"),
                  ),
                );
              } else {
                return PurchaseProductList(
                  products: item,
                );
              }
            }
          }
        },
      ),
    );
  }
}
