import 'package:flutter/material.dart';
import 'package:customer/components/car_pro.dart';


class Carpet extends StatefulWidget {
  @override
  _CarpetState createState() => _CarpetState();
}

class _CarpetState extends State<Carpet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Carpet'),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            height: 1200,
            child: Car_pro(),
          ),
        ],
      ),

    );
  }
}