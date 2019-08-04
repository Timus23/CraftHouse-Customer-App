import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/tutorial_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class VTutorial extends StatefulWidget {
  @override
  _VTutorialState createState() => _VTutorialState();
}

class _VTutorialState extends State<VTutorial> {
  Map<String, String> userInfo = {};
  Map<String, String> config = {'Content-Type': 'application/json'};
  SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) {
      userInfo['token'] = pref.getString('token');
      config['Authorization'] = 'Token ' + pref.getString('token');
      userInfo['id'] = pref.getInt('id').toString();
      userInfo['first_name'] = pref.getString('first_name');
      userInfo['last_name'] = pref.getString('last_name');
      userInfo['email'] = pref.getString('email');
      userInfo['phone_no'] = pref.getString('phone_no');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(Server.courses),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snap.connectionState == ConnectionState.done) {
          if (snap.data.statusCode == 200) {
            List<dynamic> course = json.decode(snap.data.body);
            if (course.length == 0) {
              return Container(
                child: Center(
                  child: Text('No Course Available'),
                ),
              );
            } else {
              return GridView.builder(
                  itemCount: course.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleTutorial(
                      courseItem: course[index],
                      config: config,
                      userInfo: userInfo,
                    );
                  });
            }
          }
        }
      },
    );
  }
}

class SingleTutorial extends StatelessWidget {
  final Map<String, dynamic> courseItem;
  final Map<String, String> config;
  final Map<String, String> userInfo;

  SingleTutorial(
      {@required this.courseItem,
      @required this.config,
      @required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero 1"),
        child: Material(
          child: InkWell(
            onTap: () {
              http
                  .get(Server.courses + courseItem['id'].toString() + '/',
                      headers: config)
                  .then((http.Response res) {
                if (res.statusCode == 200) {
                  var item = json.decode(res.body);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new TutorialDetails(
                            courseItem: item,
                            config: config,
                          ),
                    ),
                  );
                }
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
                            courseItem['course_name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        new Text(
                          "Rs ${courseItem['course_price']}",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                child: Image.network(
                  Server.localAddress + courseItem['course_logo'],
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
