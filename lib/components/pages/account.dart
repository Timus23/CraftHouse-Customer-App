import 'package:customer/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:customer/ServerAddress.dart';

class Account extends StatefulWidget {
  final Map<String, dynamic> userData;
  Account({@required this.userData});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  SharedPreferences prefs;
  Map<String, String> head = {'Content-Type': 'application/json'};
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      head['Authorization'] = 'Token ' + prefs.getString('token');
    });
  }

  void logoutButton() {
    http.get(Server.logout, headers: head).then((http.Response response) {
      if (response.statusCode == 200) {
        prefs.remove('token');
        prefs.remove('id');
        prefs.remove('first_name');
        prefs.remove('last_name');
        prefs.remove('is_seller');
        prefs.remove('email');
        prefs.remove('phone_no');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => Homepage(),
          ),
        );
      } else if (response.statusCode == 401) {
        Toast.show("Unauthorized Logout", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      Toast.show('Net Unavailable', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userData);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text("Account Information"),
      ),
      body: new ListView(
        children: <Widget>[
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("First Name",
                    style: TextStyle(color: Colors.grey, fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  widget.userData['first_name'],
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Last Name",
                    style: TextStyle(color: Colors.grey, fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  widget.userData['last_name'],
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Email Address",
                    style: TextStyle(color: Colors.grey, fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(
                  widget.userData['email'],
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              )
            ],
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Logout From this account",
                    style: TextStyle(color: Colors.grey, fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: RaisedButton(
                  onPressed: logoutButton,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  child:
                      Text("LogOut", style: TextStyle(color: Colors.white70)),
                  color: Colors.red,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
