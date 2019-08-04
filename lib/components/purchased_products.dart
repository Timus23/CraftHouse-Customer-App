import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';

class PurchaseProductList extends StatelessWidget {
  List<dynamic> products;
  PurchaseProductList({@required this.products});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return SinglePurchasedProduct(
            product: products[index],
          );
        });
  }
}

class SinglePurchasedProduct extends StatelessWidget {
  final Map<String, dynamic> product;

  SinglePurchasedProduct({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //leading section which is a image
        leading: new Image.network(
          Server.localAddress + product['img'],
          width: 60.0,
          height: 60.0,
        ),
        //title section
        title: new Text(product['product_name']),
        //subtitle section
        subtitle: new Column(
          children: <Widget>[
            //row inside column
            new Row(
              children: <Widget>[

                //section for the product color
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 5.0, 8.0),
                  child: new Text("Made of:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    product['product_made_of'],
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            //section for product price
            new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "Rs. " + (product['price'] / 100).toString(),
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        ),
        trailing: Container(
          width: 45,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Qty: " + product['quantity'].toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
