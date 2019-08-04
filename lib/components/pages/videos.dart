import 'package:flutter/material.dart';
import 'package:customer/components/V_tutorial.dart';

class Videos extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Tutorials'),
      ),
      body: Container(
        height: 1200,
        child: VTutorial(),
      ),
    );
  }
}
