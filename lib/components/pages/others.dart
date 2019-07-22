import 'package:flutter/material.dart';
import 'package:customer/components/oth_pro.dart';

class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
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
            child: Oth_pro(),
          ),
        ],
      ),

    );
  }
}