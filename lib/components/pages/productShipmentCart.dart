import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/selectAddress.dart';
import 'package:customer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductShippingCart extends StatefulWidget {
  final List<dynamic> cartItem;
  final double total;

  ProductShippingCart({@required this.cartItem, @required this.total});

  @override
  _ProductShippingCartState createState() => _ProductShippingCartState();
}

class _ProductShippingCartState extends State<ProductShippingCart> {
  Map<String, String> userInfo = {
    'id': '',
    'first_name': '',
    'last_name': '',
    'email': '',
    'phone_no': ''
  };
  Map<String, dynamic> _selectedAddress = {};
  Map<String, String> config = {'Content-Type': 'application/json'};

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) {
      setState(() {
        config['Authorization'] = 'Token ' + pref.getString('token');
        userInfo['id'] = pref.getInt('id').toString();
        userInfo['first_name'] = pref.getString('first_name');
        userInfo['last_name'] = pref.getString('last_name');
        userInfo['email'] = pref.getString('email');
        userInfo['phone_no'] = pref.getString('phone_no');
      });
    }
  }

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
        productId: widget.cartItem[0]['id'].toString(),
        productName: widget.cartItem[0]['product_name'].toString(),
        productUrl: Server.products,
        amount: widget.total * 100,
      ).initPayment(
        onSuccess: (data) {
          List<Map<String, String>> content = new List();
          for (var i in widget.cartItem) {
            final Map<String, String> body = {
              'user_id': userInfo['id'].toString(),
              'product_id': i['product_id'].toString(),
              'product_name': i['product_name'].toString(),
              'quantity': i['quantity'].toString(),
              'mobile_no': userInfo['phone_no'].toString(),
              'price': data['amount'].toString(),
              'token': data['token'].toString(),
            };
            content.add(body);
          }

          http
              .post(Server.productPayment, headers: config, body: json.encode(content))
              .then((http.Response response) {
            final int statusCode = response.statusCode;
            if (statusCode == 200 || statusCode == 201) {
              http
                  .delete(Server.deleteAllFromCart + userInfo['id'].toString() + '/',
                      headers: config)
                  .then((http.Response res) {
                if (res.statusCode == 204) {
                  Toast.show('Payment Successful', context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Homepage()));
                }
              }).catchError((err) {
                Toast.show('Net Unavailable', context);
              });
            } else {
              print(response.body);
              Toast.show('Payment Unsuccessful', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
          }).catchError((err) {
                Toast.show('Net Unavailable', context);
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
        _payViaKhalti();
      }
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text("Shipping Information"),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            child: ListTile(
              title: Text(
                "Bought By :",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              subtitle: Text(
                userInfo['first_name'] + ' ' + userInfo['last_name'],
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
                              userId: userInfo['id'].toString(),
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
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItem.length,
              itemBuilder: buildSingleCartProduct,
            ),
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
                  "Rs " + widget.total.toString(),
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
                'Confirm',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSingleCartProduct(BuildContext context, int index) {
    return Card(
      child: ListTile(
        //leading section which is a image
        leading: new Image.network(
          Server.localAddress + widget.cartItem[index]['img1'],
          width: 80.0,
          height: 80.0,
        ),
        //title section
        title: Text(widget.cartItem[index]['product_name']),
        //subtitle section
        subtitle: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "Rs. ${widget.cartItem[index]['product_price']}",
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Quantity'),
              Text(widget.cartItem[index]['quantity'].toString()
                  // _quantity[product['product_id'].toString()].toString(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
