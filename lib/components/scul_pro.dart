import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/prouct_details.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class CategoryProduct extends StatelessWidget {
  List<dynamic> productList;
  CategoryProduct({@required this.productList});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: productList.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SingleProd(
            product: productList[index],
          );
        });
  }
}

class SingleProd extends StatelessWidget {
  final Map<String, dynamic> product;
  SingleProd({@required this.product});
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
                    builder: (context) => new ProductDetails(
                          productDetail: productDetail,
                        ),
                  ),
                );
              }).catchError((err) {
                Toast.show('Net Unavailable', context);
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
                child: Image.network(
                  Server.media + product['images'][0] + '/',
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
