import 'package:flutter/material.dart';
import 'package:customer/components/purchased_products.dart';

class mypurchaes extends StatefulWidget {
  @override
  _mypurchaesState createState() => _mypurchaesState();
}

class _mypurchaesState extends State<mypurchaes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Purchased Products'),

      ),

      body: new purchased_products(),

            bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: new MaterialButton(onPressed: (){},
                child: new Text("Clear List",style: TextStyle(color: Colors.white),),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      );
  }
}