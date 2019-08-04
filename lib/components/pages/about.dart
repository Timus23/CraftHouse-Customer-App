import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('About This Application'),
      ),
      body: Container(
        height: 600.0,
        child: new ListTile(
          title: Text(
            "CraftHouse is a digtital platform for the commercial acitivities related to arts and crafts. This ia the mobile application for purchase of arts and crafts as well as for purchase of tutorials",
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Padding(
            child: Image.asset('images/crafts.jpg'),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: new ListTile(
          title: Padding(child: Text(
            "Developed By :",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),padding: EdgeInsets.fromLTRB(5, 0, 5, 5),),
          subtitle: Padding(
            child: Text(
              "Sumit Kakshapati, Bibek Acharya, Navaraj Pokharel,Kapil Pokharel",
              style: TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),padding: EdgeInsets.fromLTRB(5, 0, 5, 15),
          ),
        ),
      ),
    );
  }
}
