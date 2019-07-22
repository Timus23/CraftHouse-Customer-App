import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/product_shipment.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  final String productId;

  ProductDetails({@required this.productId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic> productDetail;
  @override
  Widget build(BuildContext context) {
    Widget displayBody() {
      return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: Text(productDetail['product_name']),
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
                      NetworkImage(Server.media + productDetail['images'][0]),
                      NetworkImage(Server.media + productDetail['images'][1]),
                      NetworkImage(Server.media + productDetail['images'][2]),
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
                  rating: productDetail['average_rating'].toDouble() - 0.01,
                  size: 20,
                  starCount: 5,
                  spacing: 2.0,
                )),
                Expanded(
                  child: new Text(
                    "\$${productDetail['product_price']}",
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
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return new AlertDialog(
                              title: new Text("Quantity"),
                              content: new Text("Choose the quantity"),
                              actions: <Widget>[
                                new MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: new Text("Close"),
                                )
                              ],
                            );
                          });
                    },
                    color: Colors.white,
                    textColor: Colors.grey,
                    elevation: 0.2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text("Quantity"),
                        ),
                        Expanded(
                          child: new Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new Product_shipping(
                                  psname: productDetail['product_name'],
                                  psid: productDetail['id'],
                                  psimage: productDetail['images'][0],
                                  psprice: productDetail['product_price'],
                                ),
                          ),
                        );
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
                    onPressed: () {}),
              ],
            ),
            Divider(),
            new ListTile(
              title: new Text("Product details"),
              subtitle: new Text(productDetail['product_description']),
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
                  child: new Text(productDetail['product_name']),
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
                  child: new Text(productDetail['product_made_of']),
                )
              ],
            ),
            Divider(),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Rate this product ",
                      style: TextStyle(color: Colors.grey)),
                ),
                RatingBar(),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: RaisedButton(
                      onPressed: () {},
                      child:
                          Text("Submit", style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                    ))
              ],
            ),
            Divider(),
            ReviewBar(),
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
            Container(
              height: 340.0,
              child: review(),
            )
          ],
        ),
      );
    }

    return FutureBuilder(
      future: http.get(Server.products + widget.productId + '/'),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: new AppBar(
              elevation: 0.1,
              backgroundColor: Colors.red,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snap.connectionState == ConnectionState.done) {
          productDetail = json.decode(snap.data.body);
          print('---------------------------------');
          print(productDetail);
          return displayBody();
        }
      },
    );
  }
}

class ReviewBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewBarState();
  }
}

class ReviewBarState extends State<ReviewBar> {
  String reviewed;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Flexible(
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
              // return null;
            },
            style: TextStyle(color: Colors.red),
            onSaved: (String val) {
              reviewed = val;
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: () {},
              child: Text("Submit", style: TextStyle(color: Colors.white)),
              color: Colors.red,
            ))
      ],
    );
  }
}

class RatingBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RatingBarState();
  }
}

class RatingBarState extends State<RatingBar> {
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ));
  }
}

class review extends StatelessWidget {
  var reviews_list = [
    {
      "user": "andy",
      "view": "Nice product",
    },
    {
      "user": "james",
      "view": "good Product",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: reviews_list.length,
        itemBuilder: (context, int index) {
          return ListTile(
            title: new Text(reviews_list[index]['user'],
                style: TextStyle(color: Colors.red)),
            subtitle: new Text(reviews_list[index]['view']),
          );
        });
  }
}
