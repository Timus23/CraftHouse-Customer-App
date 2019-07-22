import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/prouct_details.dart';
import 'package:http/http.dart' as http;

class Products extends StatelessWidget {
  final List<dynamic> products;
  Products({@required this.products});
  @override
  Widget build(BuildContext context) {
    Widget productDisplay() {
      return GridView.builder(
          itemCount: products.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Single_prod(product: products[index]);
          });
    }

    Widget noProduct() {
      return Container(
        child: Center(
          child: Text('No Product Found'),
        ),
      );
    }

    return products.length == 0 ? noProduct() : productDisplay();
  }
}

class Single_prod extends StatelessWidget {
  Map<String, dynamic> product;

  Single_prod({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero 1"),
        child: Material(
          child: InkWell(
            onTap: () {
              http
                  .get(Server.products + product['id'].toString() + '/')
                  .then((http.Response response) {
                Map<String, dynamic> productDetail = json.decode(response.body);
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    //passing the values of product to product_details page
                    builder: (context) => new ProductDetails(
                          // productId: product['id'].toString(),
                          productDetail: productDetail,
                        ),
                  ),
                );
              });
            },
            child: GridTile(
              footer: Container(
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          product['product_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                      new Text(
                        "\$${product['product_price']}",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/imageLoading.gif',
                image: Server.media + product['images'][0],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
