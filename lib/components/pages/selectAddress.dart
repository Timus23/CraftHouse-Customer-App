import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/address.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectAddress extends StatefulWidget {
  final String userId;
  SelectAddress({@required this.userId});
  @override
  State<StatefulWidget> createState() {
    return SelectAddressState();
  }
}

class SelectAddressState extends State<SelectAddress> {
  List<dynamic> address = [];
  @override
  void initState() {
    // getAddress();
    super.initState();
  }

  // void getAddress() {
  //   http.get(Server.addAddress + widget.userId + '/').then((http.Response r) {
  //     if (r.statusCode == 200) {
  //       setState(() {
  //         address = json.decode(r.body);
  //         print(address);
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Widget buildAddress(BuildContext context, int index) {
      return ListTile(
        // leading: ,
        title: Text(address[index]['address'] +
            ' , ' +
            address[index]['city'] +
            ' , ' +
            address[index]['district']),
        // trailing: Text(address[index]['District']),
        subtitle: Text(address[index]['zone']),
        onTap: () {
          Navigator.of(context).pop(address[index]);
        },
      );
    }

    return WillPopScope(
      onWillPop: () {
        Map<String,dynamic> temp = {}; 
        Navigator.of(context).pop(temp);
      },
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: Text("Select Address"),
        ),
        body: FutureBuilder(
          future: http.get(Server.addAddress + widget.userId + '/'),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              // setState(() {
              address = json.decode(snap.data.body);
              // });
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: address.length,
                      itemBuilder: buildAddress,
                    ),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    child: Text(
                      'Add New Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Address()));
                    },
                  )
                ],
              );
            } else if (snap.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
