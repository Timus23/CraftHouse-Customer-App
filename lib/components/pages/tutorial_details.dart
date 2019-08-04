import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/login.dart';
import 'package:customer/components/pages/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialDetails extends StatefulWidget {
  Map<String, dynamic> courseItem;
  Map<String, String> config;

  TutorialDetails({@required this.courseItem, @required this.config});
  @override
  _TutorialDetailsState createState() => _TutorialDetailsState();
}

class _TutorialDetailsState extends State<TutorialDetails> {
  var rating = 0.0;
  bool authenticate;
  Map<String, dynamic> userInfo = {};
  bool isEnrolled;
  final _formKey = GlobalKey<FormState>();
  String reviewed;

  @override
  void initState() {
    super.initState();
    isEnrolled = widget.courseItem['is_enrolled'];
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
        userInfo['id'] = pref.getInt('id').toString();
        userInfo['first_name'] = pref.getString('first_name');
        userInfo['last_name'] = pref.getString('last_name');
        userInfo['email'] = pref.getString('email');
        userInfo['phone_no'] = pref.getString('phone_no');
      });
    }
  }

  void checkInEnrolled() {
    http
        .get(Server.courses + widget.courseItem['id'].toString() + '/',
            headers: widget.config)
        .then((http.Response res) {
      var t = json.decode(res.body);
      print('------------------------');
      print(t);
      if (t['is_enrolled']) {
        setState(() {
          isEnrolled = true;
        });
      }
    }).catchError((err) {
      Toast.show("Net Unavailable", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    void coursepayment() {
      if (authenticate) {
        FlutterKhalti(
          urlSchemeIOS: "KhaltiPayment",
          publicKey: "test_public_key_27ac6d6998654df3a77f58f46e6e2ce2",
          productId: widget.courseItem['id'].toString(),
          productName: widget.courseItem['course_name'].toString(),
          productUrl: Server.courses + widget.courseItem['id'].toString() + '/',
          amount: widget.courseItem['course_price'] * 100,
        ).initPayment(
          onSuccess: (data) {
            final Map<String, String> body = {
              'user_id': widget.courseItem['user_id'].toString(),
              'course_id': widget.courseItem['id'].toString(),
              'course_name': widget.courseItem['course_name'],
              'price': data['amount'].toString(),
              'token': data['token'].toString(),
            };
            http
                .post(Server.coursePayment,
                    headers: widget.config, body: json.encode(body))
                .then((http.Response response) {
              final int statusCode = response.statusCode;
              if (statusCode == 200 || statusCode == 201) {
                http
                    .get(
                        Server.courses +
                            widget.courseItem['id'].toString() +
                            '/',
                        headers: widget.config)
                    .then((http.Response r) {
                  if (r.statusCode == 200 || r.statusCode == 201) {
                    Toast.show('Payment Successful', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    setState(() {
                      widget.courseItem = json.decode(r.body);
                      isEnrolled = true;
                    });
                  }
                }).catchError((err) {
                  Toast.show('Net Unavailable', context);
                });
              } else {
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
      } else {
        Toast.show("Please Login inorder to buy", context,
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
              widget.config['Authorization'] = 'Token ' + val['token'];
            });
            checkInEnrolled();
          }
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
                    'course_id': widget.courseItem['id'].toString()
                  };
                  http
                      .post(Server.rateCourse,
                          headers: widget.config, body: json.encode(data))
                      .then((http.Response res) {
                    if (res.statusCode == 201) {
                      http
                          .get(
                              Server.courses +
                                  widget.courseItem['id'].toString() +
                                  '/',
                              headers: widget.config)
                          .then((http.Response r) {
                        if (r.statusCode == 200 || r.statusCode == 201) {
                          setState(() {
                            widget.courseItem = json.decode(r.body);
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
                      print(widget.config);
                      print(userInfo);
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
                        widget.config['Authorization'] =
                            'Token ' + val['token'];
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
                  // return null;
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
                        'course_id': widget.courseItem['id'].toString()
                      };
                      http
                          .post(Server.reviewCourse,
                              headers: widget.config, body: json.encode(data))
                          .then((http.Response res) {
                        if (res.statusCode == 201) {
                          http
                              .get(
                                  Server.courses +
                                      widget.courseItem['id'].toString() +
                                      '/',
                                  headers: widget.config)
                              .then((http.Response r) {
                            if (r.statusCode == 200 || r.statusCode == 201) {
                              setState(() {
                                widget.courseItem = json.decode(r.body);
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
                            widget.config['Authorization'] =
                                'Token ' + val['token'];
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
          itemCount: widget.courseItem['course_reviews'].length,
          itemBuilder: (context, int index) {
            return ListTile(
              title: new Text(
                widget.courseItem['course_reviews'][index]['comment'],
                style: TextStyle(fontSize: 18),
              ),
              subtitle: new Text(
                  widget.courseItem['course_reviews'][index]['first_name'],
                  style: TextStyle(color: Colors.red)),
            );
          });
    }

    void watchNow() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Course(
                courseItem: widget.courseItem,
                config: widget.config,
              ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text(widget.courseItem['course_name']),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: Center(
              child: Image.network(
                  Server.localAddress + widget.courseItem['course_logo']),
            ),
          ),

          Row(
            children: <Widget>[
              Expanded(
                  child: SmoothStarRating(
                color: Colors.red,
                borderColor: Colors.red,
                rating: widget.courseItem['average_rating'].toDouble() - 0.01,
                size: 30,
                starCount: 5,
                spacing: 2.0,
              )),
              Expanded(
                child: Text(
                  "Rs. ${widget.courseItem['course_price']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20),
                ),
              ),
            ],
          ),
          Divider(),
          ListTile(
            title: Text("Tutorial Details"),
            subtitle: Text(widget.courseItem['course_description']),
          ),
          Divider(),
          ListTile(
            title: Text("Tools Required"),
            subtitle: Text(widget.courseItem['course_tools_required']),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: isEnrolled
                    ? MaterialButton(
                        onPressed: watchNow,
                        color: Colors.red,
                        textColor: Colors.white,
                        elevation: 0.2,
                        child: Text("Watch Video"),
                      )
                    : MaterialButton(
                        onPressed: coursepayment,
                        color: Colors.red,
                        textColor: Colors.white,
                        elevation: 0.2,
                        child: Text("Buy now"),
                      ),
              ),
            ],
          ),
          Divider(),
          ratingBar(),
          Divider(),
          reviewBar(),
          Divider(),
          //REview Course section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Course Reviews",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 30,
                    fontStyle: FontStyle.italic)),
          ),
          //REview product section
          widget.courseItem['course_reviews'].length == 0
              ? Container(
                  child: ListTile(
                    title: Text('No Reviews'),
                  ),
                )
              : Container(
                  height: 340.0,
                  child: reviewList(),
                )
        ],
      ),
    );
  }
}
