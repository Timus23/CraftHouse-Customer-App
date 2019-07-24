import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:customer/components/pages/sculpture.dart';
import 'package:http/http.dart' as http;

class HorizontalList extends StatelessWidget {
  final List<dynamic> category;

  HorizontalList({@required this.category});

  @override
  Widget build(BuildContext context) {
    Widget buildCategory(BuildContext context, int index) {
      return Category(
        image_caption: category[index]['cat_name'],
        image_location: category[index]['cat_logo'],
      );
    }

    return Container(
      height: 140.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: buildCategory,
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          var s = image_caption;
          http.get(Server.category + s + '/').then((http.Response res) {
            if (res.statusCode == 200 || res.statusCode == 201) {
              List<dynamic> prod = json.decode(res.body);
              print(prod);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new Sculpture(
                        products: prod,
                        title: s,
                      ),
                ),
              );
            }
          });
        },
        child: Container(
          width: 120.0,
          child: ListTile(
            title: FadeInImage.assetNetwork(
              placeholder: 'images/imageLoading.gif',
              image: image_location,
              height: 80,
              width: 100,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(
                image_caption,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
