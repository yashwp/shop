import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  var showFavorites = false;
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imgUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imgUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imgUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> addProduct(Product p) {
    const url = 'https://flutter-shop-3ee63.firebaseio.com/products.json';
    return http
        .post(url,
            body: json.encode({
              'title': p.title,
              'description': p.description,
              'price': p.price,
              'imgUrl': p.imgUrl.isEmpty ? p.imgUrl : '',
              'isFavorite': p.isFavorite,
            }))
        .then((res) {
      final product = Product(
        id: json.decode(res.body)['name'],
        title: p.title,
        description: p.description,
        price: p.price,
        imgUrl: p.imgUrl.isEmpty ? p.imgUrl : '',
      );

      _items.add(product);

      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }

  void updateProduct(String id, Product p) {
    final i = _items.indexWhere((p) => p.id == id);

    if (i >= 0) {
      _items[i] = p;
    }

    notifyListeners();
  }
}
