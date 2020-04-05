import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  var showFavorites = false;
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> loadProducts() async {
    const url = 'https://flutter-shop-3ee63.firebaseio.com/products.json';
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      print(data);
      data.forEach((prodId, prodObj) {
        _items.add(Product(
          id: prodId,
          title: prodObj['title'],
          description: prodObj['description'],
          price: prodObj['price'],
          isFavorite: prodObj['isFavorite'],
          imgUrl: prodObj['imgUrl'],
        ));
      });
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-shop-3ee63.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imgUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product p) async {
    final i = _items.indexWhere((p) => p.id == id);
    final url = 'https://flutter-shop-3ee63.firebaseio.com/products/$id.json';

    if (i >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imgUrl,
            'price': p.price,
          }));
      _items[i] = p;
    }

    notifyListeners();
  }
}
