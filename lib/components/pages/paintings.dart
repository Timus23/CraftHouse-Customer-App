import 'package:flutter/material.dart';
import 'package:customer/components/pai_pro.dart';


class Painting extends StatefulWidget {
  @override
  _PaintingState createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Paintings'),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            height: 1200,
            child: Pai_pro(),
          ),
        ],
      ),

    );
  }
}