import 'package:flutter/foundation.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity! + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  double get totalAmount {
    var amount = 0.0;
    _items.forEach((key, value) {
      amount += value.quantity! * value.price!;
    });
    return amount;
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity! > 1) {
        _items.update(
            id,
            (value) => CartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity! - 1,
                price: value.price));
        notifyListeners();
      } else {
        this.removeItem(id);
      }
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
