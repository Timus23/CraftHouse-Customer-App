import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Map<String, String> config = {'Content-Type': 'application/json'};
  SharedPreferences pref;
  Map<String, String> body = {};
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  checkAuthentication() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      config['Authorization'] = 'Token ' + pref.getString('token');
      body['user_id'] = pref.getInt('id').toString();
    });
  }

  final _formKey = GlobalKey<FormState>();
  Container _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 500,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        maxLength: 32,
                        validator: validateName,
                        style: TextStyle(color: Colors.red),
                        onSaved: (v) {
                          body['zone'] = v;
                        },
                        decoration: InputDecoration(
                            hintText: "Zone",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.label,
                              color: Colors.red,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.red.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        maxLength: 32,
                        validator: validateName,
                        style: TextStyle(color: Colors.red),
                        onSaved: (v) {
                          body['district'] = v;
                        },
                        decoration: InputDecoration(
                            hintText: "District",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.location_searching,
                              color: Colors.red,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.red.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 32,
                      validator: validateName,
                      style: TextStyle(color: Colors.red),
                      onSaved: (v) {
                        body['city'] = v;
                      },
                      decoration: InputDecoration(
                        hintText: "City",
                        hintStyle: TextStyle(color: Colors.red.shade200),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: Colors.red.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        maxLength: 50,
                        validator: validateName,
                        style: TextStyle(color: Colors.red),
                        onSaved: (v) {
                          body['address'] = v;
                        },
                        decoration: InputDecoration(
                            hintText: "Local Address",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.local_shipping,
                              color: Colors.red,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.red.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 500,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: submitButton,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: Text("Add", style: TextStyle(color: Colors.white70)),
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  void submitButton() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      http
          .post(Server.addAddress, headers: config, body: json.encode(body))
          .then((http.Response r) {
        if (r.statusCode == 201) {
          Toast.show("Address added successfully", context);
          Navigator.of(context).pop();
        } else {
          Toast.show("Unable to add address", context);
        }
      }).catchError((err) {
        Toast.show('Net Unavailable', context);
      });
    }
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z 0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Address is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.red.shade100,
          child: ListView(
            children: <Widget>[
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
