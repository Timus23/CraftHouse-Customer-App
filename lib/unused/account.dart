import 'package:flutter/material.dart';


class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title:Text("Account Information"),
      ),
            body: new ListView(
        children: <Widget>[

         new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Name",
                    style: TextStyle(color: Colors.grey,fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("Chandle Bing",style: TextStyle(color: Colors.red,fontSize: 20),),
              )
            ],
          ),
          Divider(),
         new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Email Address",
                    style: TextStyle(color: Colors.grey,fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("bing@gmail.com",style: TextStyle(color: Colors.red,fontSize: 20),),
              )
            ],
          ),
          Divider(), 
           new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Logout From this account",
                    style: TextStyle(color: Colors.grey,fontSize: 20)),
              ),
              //to add brand name
              Padding(
                padding: EdgeInsets.all(5.0),
                child: RaisedButton(
                    onPressed: (){

                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    child: Text("LogOut", style: TextStyle(color: Colors.white70)),
                    color: Colors.red,
                  ),
              )
            ],
          ),
        ],

           
      ),
      
    );
  }
}