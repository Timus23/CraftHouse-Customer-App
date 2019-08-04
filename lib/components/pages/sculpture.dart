import 'package:flutter/material.dart';
import 'package:customer/components/scul_pro.dart';

class Categories extends StatelessWidget {
  final List<dynamic> products;
  final String title;
  Categories({@required this.products, @required this.title});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 1200,
            child: CategoryProduct(
              productList: products,
            ),
          ),
        ],
      ),
    );
  }
}
