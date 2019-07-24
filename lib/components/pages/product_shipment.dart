import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/selectAddress.dart';
import 'package:customer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:customer/components/pages/address.dart';
import 'package:toast/toast.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:http/http.dart' as http;

class ProductShipping extends StatefulWidget {
  Map<String, String> userInfo;
  Map<String, dynamic> productDetail;
  Map<String, String> config;
  int quantity;

  ProductShipping(
      {@required this.userInfo,
      @required this.config,
      @required this.productDetail,
      @required this.quantity});

  @override
  _ProductShippingState createState() => _ProductShippingState();
}

class _ProductShippingState extends State<ProductShipping> {
  Map<String, dynamic> _selectedAddress = {};
  @override
  Widget build(BuildContext context) {
    Widget buildAddress() {
      if (_selectedAddress.length == 0) {
        return Text("No Address Selected",
            style: TextStyle(color: Colors.grey, fontSize: 20));
      } else {
        var _address = _selectedAddress['address'].toString() +
            ' , ' +
            _selectedAddress['city'] +
            ' , ' +
            _selectedAddress['district'];
        return Text(_address,
            style: TextStyle(color: Colors.grey, fontSize: 20));
      }
    }

    _payViaKhalti() {
      FlutterKhalti(
        urlSchemeIOS: "KhaltiPayment",
        publicKey: "test_public_key_27ac6d6998654df3a77f58f46e6e2ce2",
        productId: widget.productDetail['id'].toString(),
        productName: widget.productDetail['product_name'].toString(),
        productUrl: (Server.products + widget.productDetail['id'].toString())
            .toString(),
        amount: (widget.productDetail['product_price'] * widget.quantity * 100),
      ).initPayment(
        onSuccess: (data) {
          print('-----------Initial Khalti Response---------------');
          print(data);
          print('\n\n------------------token-------------------------');
          print('token' + data['token']);
          final Map<String, String> body = {
            'user_id': widget.userInfo['id'].toString(),
            'product_id': data['product_identity'].toString(),
            'product_name': data['product_name'].toString(),
            'quantity': widget.quantity.toString(),
            'mobile_no': widget.userInfo['phone_no'].toString(),
            'price': data['amount'].toString(),
            'token': data['token'].toString(),
          };
          String localhost = Server.payment;
          print('--------------------------------------');
          List<Map<String, String>> content = new List();
          content.add(body);
          http
              .post(localhost,
                  headers: widget.config, body: json.encode(content))
              .then((http.Response response) {
            final int statusCode = response.statusCode;
            if (statusCode == 200 || statusCode == 201) {
              print('-----------Status Code----------------');
              print(statusCode);
              Toast.show('Payment Successful', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Homepage()));
            } else {
              print(statusCode);
              print(response.body);
              Toast.show('Payment Unsuccessful', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
          });
        },
        onError: (error) {
          print("error");
          print(error);
        },
      );
    }

    void placeOrder() {
      if (_selectedAddress.length == 0) {
        Toast.show('Select Address', context);
      } else {
        print('----------------------------------');
        print(widget.config);
        print(widget.productDetail);
        print(widget.userInfo);
        print(widget.quantity);
        _payViaKhalti();
      }
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text("Shipping Information"),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            child: ListTile(
              title: Text(
                "Bought By :",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              subtitle: Text(
                widget.userInfo['first_name'] +
                    ' ' +
                    widget.userInfo['last_name'],
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Shipping address:",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: GestureDetector(
                  child: Text(
                    _selectedAddress.length == 0 ? 'Select Address' : 'Edit',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push<Map<String, dynamic>>(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectAddress(
                              userId: '2',
                            ),
                      ),
                    )
                        .then((value) {
                      setState(() {
                        if (value.length > 0) {
                          _selectedAddress = value;
                          print(_selectedAddress.length);
                        }
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                child: buildAddress(),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 280,
                child: Image.network(
                    Server.media + widget.productDetail['images'][0]),
              ),
            ],
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text(
                    "Product Name",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  widget.productDetail['product_name'],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Quantity",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  widget.quantity.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Price Paid",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  "Rs " +
                      (widget.productDetail['product_price'] * widget.quantity)
                          .toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          SafeArea(
            child: RaisedButton(
              color: _selectedAddress.length == 0 ? Colors.grey : Colors.red,
              child: Text(
                'Place Order',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: placeOrder,
            ),
          ),
        ],
      ),
    );
  }
}
