import 'package:flutter/material.dart';
import 'package:customer/components/pages/carpet.dart';
import 'package:customer/components/pages/paintings.dart';
import 'package:customer/components/pages/sculpture.dart';
import 'package:customer/components/pages/others.dart';

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
          if (s == 'Sculpture') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new Sculpture()));
          } else if (s == 'Carpets') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => new Carpet()));
          } else if (s == 'Paintings') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new Painting()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => new Others()));
          }
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
