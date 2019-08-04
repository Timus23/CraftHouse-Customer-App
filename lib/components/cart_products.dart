import 'dart:convert';
import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/productShipmentCart.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class CartProducts extends StatefulWidget {
  final List<dynamic> cartItem;
  final String token;

  CartProducts({@required this.cartItem, @required this.token});
  @override
  State<StatefulWidget> createState() {
    return CartProductState();
  }
}

class CartProductState extends State<CartProducts> {
  Map<String, String> config = {'Content-Type': 'application/json'};
  Map<String, int> _quantity = {};
  @override
  void initState() {
    super.initState();
    config['Authorization'] = 'Token ' + widget.token;
    getQuantity();
  }

  getQuantity() {
    for (var item in widget.cartItem) {
      _quantity[item['product_id'].toString()] = item['quantity'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: widget.cartItem.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(widget.cartItem[index]['product_id'].toString()),
                    child:
                        buildSingleCartProduct(widget.cartItem[index], index),
                    background: Container(
                      color: Colors.red,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              'Delete',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection d) {
                      print(widget.token);
                      config['Authorization'] = 'Token ' + widget.token;
                      http
                          .delete(
                              Server.deleteCart +
                                  widget.cartItem[index]['id'].toString() +
                                  '/',
                              headers: config)
                          .then((http.Response response) {
                        if (response.statusCode == 204) {
                          Toast.show('Product Removed from Cart', context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        } else {
                          var error = json.decode(response.body);
                          Toast.show(error['detail'], context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                        setState(() {
                          widget.cartItem.removeAt(index);
                        });
                      }).catchError((err) {
                        Toast.show('Net Unavailable', context);
                      });
                    },
                    confirmDismiss: (DismissDirection direction) async {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                )
                              ],
                            );
                          });
                      return res;
                    },
                  );
                }),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text(
                    "Total:",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    calculatePrice().toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductShippingCart(
                              cartItem: widget.cartItem,
                              total: calculatePrice(),
                            ),
                      ),
                    );
                  },
                  child: Text(
                    "Check Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  double calculatePrice() {
    double total = 0;
    for (var item in widget.cartItem) {
      total += item['product_price'] * _quantity[item['product_id'].toString()];
    }
    return total;
  }

  Widget buildSingleCartProduct(Map<String, dynamic> product, int index) {
    return Card(
      child: ListTile(
        //leading section which is a image
        leading: new Image.network(
          Server.localAddress + product['img1'],
          width: 80.0,
          height: 80.0,
        ),
        //title section
        title: Text(product['product_name']),
        //subtitle section
        subtitle: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "Rs. ${product['product_price']}",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        ),
        trailing: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  child: Icon(
                    Icons.add,
                    size: 17,
                  ),
                  onTap: () {
                    if (_quantity[product['product_id'].toString()].toInt() +
                            1 >
                        product['product_quantity']) {
                      Toast.show('Out of Stock', context);
                    } else {
                      Map<String, String> body = {
                        'quantity':
                            (_quantity[product['product_id'].toString()] + 1)
                                .toString()
                      };
                      http
                          .patch(
                              Server.updateCart +
                                  product['id'].toString() +
                                  '/',
                              headers: config,
                              body: json.encode(body))
                          .then((http.Response res) {
                        if (res.statusCode == 200) {
                          setState(() {
                            _quantity[product['product_id'].toString()]++;
                            widget.cartItem[index]['quantity']++;
                            print(widget.cartItem);
                          });
                        }
                      }).catchError((err) {
                        Toast.show('Net Unavailable', context);
                      });
                    }
                  }),
              Text(
                _quantity[product['product_id'].toString()].toString(),
              ),
              GestureDetector(
                child: Icon(
                  Icons.remove,
                  size: 17,
                ),
                onTap: () {
                  if (_quantity[product['product_id'].toString()] == 1) {
                    Toast.show('Quantity cannot be less than 1', context);
                  } else {
                    Map<String, String> body = {
                      'quantity':
                          (_quantity[product['product_id'].toString()] - 1)
                              .toString()
                    };
                    http
                        .patch(
                            Server.updateCart + product['id'].toString() + '/',
                            headers: config,
                            body: json.encode(body))
                        .then((http.Response res) {
                      if (res.statusCode == 200) {
                        setState(() {
                          _quantity[product['product_id'].toString()]--;
                          widget.cartItem[index]['quantity']--;
                          print(widget.cartItem);
                        });
                      }
                    }).catchError((err) {
                      Toast.show('Net Unavailable', context);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
