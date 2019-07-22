import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final String pid;
  final double price;
  final String image;
  final bool isFavorite;
  final String category;
  final String artist;

  Product(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.category,
      @required this.artist,
      @required this.pid,
      this.isFavorite = false});
}
