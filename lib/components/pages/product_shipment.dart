import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


class Product_shipping extends StatefulWidget {
  final psimage;
  final psid;
  final psname;
  final psprice;

  const Product_shipping({
    this.psid,
    this.psimage,
    this.psname,
    this.psprice
  });
  @override
  _Product_shippingState createState() => _Product_shippingState();
}

class _Product_shippingState extends State<Product_shipping> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title:Text("Shipping Information"),
      ),

      body: new ListView(
        children: <Widget>[
          new Container(
            child: ListTile(
              title: Text("Bought By :",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.red),),
              subtitle: Text("Chandler Bing",style: TextStyle(fontSize: 30),),
            ),
  
          ),

          Row(
            children: <Widget>[
              new Container(
                height: 300,
                child: Image.asset(widget.psimage),
              ),

            ],
            ),

            Divider(),
         new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Product Name",
                    style: TextStyle(color: Colors.grey,fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.psname,style: TextStyle(color: Colors.red,fontSize: 20),),
              )
            ],
          ),
          Divider(),
         new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Price Paid",
                    style: TextStyle(color: Colors.grey,fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("Rs"+widget.psprice.toString(),style: TextStyle(color: Colors.red,fontSize: 20),),
              )
            ],
          ),
          Divider(),
           new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Enter the address Details",
                    style: TextStyle(color: Colors.grey,fontSize: 30)),
              ),
            ],
          ),
          Divider(), 
           new Row(
            children: <Widget>[
                
                new Flexible(
                child: new TextField(
                  decoration: InputDecoration(
                  hintText:"Enter an address"
                  ),
                  style: TextStyle(color: Colors.red,fontSize: 20),
                    ),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child:
                        Text("Ship", style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                  ))
              
            ],
          ),
        ],

           
      ),

      
      
    );
  }
}