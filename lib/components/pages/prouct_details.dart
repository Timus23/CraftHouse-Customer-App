import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/product_shipment.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ProductDetails extends StatefulWidget {
  Map<String, dynamic> productDetail;
  ProductDetails({@required this.productDetail});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var prod;
  bool authenticate;
  Map<String, dynamic> userInfo = {};
  Map<String, String> body = {};
  var rating = 0.0;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> config = {'Content-Type': 'application/json'};
  String reviewed;
  int _quantity = 0;

  @override
  void initState() {
    prod = widget.productDetail;
    super.initState();
    checkAuthentication();
  }

  checkAuthentication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') == null) {
      setState(() {
        authenticate = false;
      });
    } else {
      setState(() {
        authenticate = true;
        config['Authorization'] = 'Token ' + pref.getString('token');
        userInfo['id'] = pref.getInt('id').toString();
        userInfo['first_name'] = pref.getString('first_name');
        userInfo['last_name'] = pref.getString('last_name');
        userInfo['email'] = pref.getString('email');
        userInfo['phone_no'] = pref.getString('phone_no');
      });
    }
  }

  Widget ratingBar() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          child: new Text("Rate this product ",
              style: TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: SmoothStarRating(
            color: Colors.red,
            borderColor: Colors.red,
            rating: rating,
            size: 28,
            starCount: 5,
            spacing: 2.0,
            onRatingChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            onPressed: () {
              if (authenticate) {
                var data = {
                  'user_id': userInfo['id'],
                  'first_name': userInfo['first_name'],
                  'email': userInfo['email'],
                  'rating': rating.toInt().toString(),
                  'product_id': prod['id'].toString()
                };
                http
                    .post(Server.rateProduct,
                        headers: config, body: json.encode(data))
                    .then((http.Response res) {
                  if (res.statusCode == 201) {
                    http
                        .get(Server.products + prod['id'].toString() + '/')
                        .then((http.Response r) {
                      if (r.statusCode == 200 || r.statusCode == 201) {
                        setState(() {
                          checkAuthentication();
                          prod = json.decode(r.body);
                          rating = 0.0;
                        });
                        Toast.show("Rated Successfully", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    }).catchError((err) {
                      Toast.show('Net Unavailable', context);
                    });
                  } else {
                    Toast.show("Unable to rate the Product", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  Toast.show('Net Unavailable', context);
                });
              } else {
                Toast.show("Please Login to give rating", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

                Navigator.of(context)
                    .push<Map<String, dynamic>>(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ),
                )
                    .then((val) {
                  if (val.length > 0) {
                    setState(() {
                      authenticate = true;
                      userInfo = val;
                      config['Authorization'] = 'Token ' + val['token'];
                    });
                  }
                });
              }
            },
            child: Text("Submit", style: TextStyle(color: Colors.white)),
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget reviewBar() {
    return Row(
      children: <Widget>[
        new Flexible(
          child: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.grey,
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: "Review this product",
                  hintStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                      fontSize: 15),
                  border: InputBorder.none),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot enter an empty review";
                }
              },
              style: TextStyle(color: Colors.black),
              onSaved: (String val) {
                reviewed = val;
              },
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (authenticate) {
                    Map<String, String> data = {
                      'user_id': userInfo['id'].toString(),
                      'first_name': userInfo['first_name'].toString(),
                      'email': userInfo['email'].toString(),
                      'comment': reviewed.trim().toString(),
                      'product_id': prod['id'].toString()
                    };
                    http
                        .post(Server.reviewProduct,
                            headers: config, body: json.encode(data))
                        .then((http.Response res) {
                      if (res.statusCode == 201) {
                        http
                            .get(Server.products + prod['id'].toString() + '/')
                            .then((http.Response r) {
                          if (r.statusCode == 200 || r.statusCode == 201) {
                            setState(() {
                              prod = json.decode(r.body);
                              checkAuthentication();
                              _formKey.currentState.reset();
                            });
                            Toast.show("Review Successfully", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                          }
                        }).catchError((err) {
                          Toast.show('Net Unavailable', context);
                        });
                      } else {
                        Toast.show("Unable to review the Product", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    }).catchError((err) {
                      Toast.show('Net Unavailable', context);
                    });
                  } else {
                    Toast.show("Please Login to give review", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

                    Navigator.of(context)
                        .push<Map<String, dynamic>>(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Login(),
                      ),
                    )
                        .then((val) {
                      if (val.length > 0) {
                        setState(() {
                          authenticate = true;
                          userInfo = val;
                          config['Authorization'] = 'Token ' + val['token'];
                        });
                      }
                    });
                  }
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.white)),
              color: Colors.red,
            ))
      ],
    );
  }

  Widget reviewList() {
    return ListView.builder(
        itemCount: prod['reviews'].length,
        itemBuilder: (context, int index) {
          return ListTile(
            title: new Text(
              prod['reviews'][index]['comment'],
              style: TextStyle(fontSize: 18),
            ),
            subtitle: new Text(prod['reviews'][index]['first_name'],
                style: TextStyle(color: Colors.red)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayBody() {
      return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: Text(prod['product_name']),
        ),
        body: ListView(
          children: <Widget>[
            new Container(
              height: 300.0,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: new Carousel(
                    boxFit: BoxFit.fitHeight,
                    images: [
                      NetworkImage(Server.media + prod['images'][0]),
                      NetworkImage(Server.media + prod['images'][1]),
                      NetworkImage(Server.media + prod['images'][2]),
                    ],
                    autoplay: false,
                    animationCurve: Curves.fastLinearToSlowEaseIn,
                    animationDuration: Duration(milliseconds: 1000),
                    dotSize: 4.0,
                    dotColor: Colors.black,
                    dotBgColor: Colors.transparent,
                    indicatorBgPadding: 2.0,
                  ),
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                    child: new SmoothStarRating(
                  color: Colors.red,
                  allowHalfRating: true,
                  borderColor: Colors.red,
                  rating: prod['average_rating'].toDouble() - 0.01,
                  size: 20,
                  starCount: 5,
                  spacing: 2.0,
                )),
                Expanded(
                  child: new Text(
                    "\$${prod['product_price']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
            //First buttons
            Row(
              children: <Widget>[
                //the quantity button
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (_quantity - 1 < 0) {
                                Toast.show(
                                    'Quantity cannot be less than 0', context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                              } else {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              _quantity.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (_quantity + 1 > prod['product_quantity']) {
                                Toast.show('Out of Stock', context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                              } else {
                                setState(() {
                                  _quantity++;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            //second buttons
            Row(
              children: <Widget>[
                //the size button
                Expanded(
                  child: MaterialButton(
                      onPressed: () {
                        if (_quantity == 0) {
                          Toast.show(
                              'Quantity must be greater than 0', context);
                        } else {
                          if (!authenticate) {
                            Toast.show('Please Log In', context);
                            Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            ).then((val) {
                              if (val.length > 0) {
                                setState(() {
                                  authenticate = true;
                                  userInfo = val;
                                  config['Authorization'] =
                                      'Token ' + val['token'];
                                });
                              }
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new ProductShipping(
                                      config: config,
                                      productDetail: prod,
                                      userInfo: userInfo,
                                      quantity: _quantity,
                                    ),
                              ),
                            );
                          }
                        }
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text("Buy now")),
                ),
                new IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (authenticate) {
                        Map<String, String> data = {
                          'user_id': userInfo['id'].toString(),
                          'product_id': prod['id'].toString(),
                          'quantity': _quantity.toString()
                        };
                        http
                            .post(Server.cart,
                                headers: config, body: json.encode(data))
                            .then((http.Response res) {
                          if (res.statusCode == 200 || res.statusCode == 201) {
                            Toast.show('Added To cart', context);
                          } else if (res.statusCode == 400) {
                            Map<String, dynamic> temp = json.decode(res.body);
                            print(temp);
                            if (temp.containsKey('non_field_errors')) {
                              Toast.show('Product Already in Cart', context);
                            } else {
                              Toast.show('Unable to add to cart', context);
                            }
                          } else {
                            Toast.show('Unable to add to cart', context);
                          }
                        }).catchError((err) {
                          Toast.show('Net Unavailable', context);
                        });
                      } else {
                        Toast.show("Please Login to add to Cart", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                        Navigator.of(context)
                            .push<Map<String, dynamic>>(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Login(),
                          ),
                        )
                            .then((val) {
                          if (val.length > 0) {
                            setState(() {
                              authenticate = true;
                              userInfo = val;
                              config['Authorization'] = 'Token ' + val['token'];
                            });
                          }
                        });
                      }
                    }),
              ],
            ),
            Divider(),
            new ListTile(
              title: new Text("Product details"),
              subtitle: new Text(prod['product_description']),
            ),
            Divider(),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Product name",
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(prod['product_name']),
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Product is made of",
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(prod['product_made_of']),
                )
              ],
            ),
            Divider(),
            ratingBar(),
            Divider(),
            reviewBar(),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Product Reviews",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 30,
                      fontStyle: FontStyle.italic)),
            ),
            //REview product section
            prod['reviews'].length == 0
                ? Container(
                    child: ListTile(
                      title: Text('No Reviews'),
                    ),
                  )
                : Container(
                    height: 340.0,
                    child: reviewList(),
                  ),
          ],
        ),
      );
    }

    return displayBody();
  }
}
