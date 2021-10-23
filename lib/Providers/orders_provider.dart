import 'package:flutter/foundation.dart';
import 'package:shopapp/Providers/cart.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final DateTime? date;
  final List<CartItem>? products;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.date,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cart, double amount) {
    OrderItem order = OrderItem(
        id: DateTime.now().toString(),
        amount: amount,
        date: DateTime.now(),
        products: cart);
    _orders.insert(0, order);
    notifyListeners();
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
