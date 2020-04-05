import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imgUrl,
      this.isFavorite = false});

  void toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = 'https://flutter-shop-3ee63.firebaseio.com/products/$id.json';

    notifyListeners();
    try {
      final res =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (res.statusCode > 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
