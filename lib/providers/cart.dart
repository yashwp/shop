import 'package:flutter/foundation.dart';
import 'package:shop/widgets/cart_item.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get totalItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });

    return total;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: item.quantity + 1,
        ),
      );
      notifyListeners();
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (_items.containsKey(prodId)) {
      return;
    }

    if (_items[prodId].quantity > 1) {
      _items.update(
          prodId,
          (item) => CartItem(
                id: item.id,
                title: item.title,
                price: item.price,
                quantity: item.quantity - 1,
              ));
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
