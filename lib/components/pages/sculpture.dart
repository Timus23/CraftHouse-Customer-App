import 'package:flutter/material.dart';
import 'package:customer/components/scul_pro.dart';

class Sculpture extends StatefulWidget {
  @override
  _SculptureState createState() => _SculptureState();
}

class _SculptureState extends State<Sculpture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Sculptures'),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            height: 1200,
            child: Scu_pro(),
          ),
        ],
      ),

    );
  }
}