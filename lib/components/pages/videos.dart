import 'package:flutter/material.dart';
import 'package:customer/components/V_tutorial.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Tutorials'),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            height: 1200,
            child: V_tutorial(),
          ),
        ],
      ),
      
    );
  }
}