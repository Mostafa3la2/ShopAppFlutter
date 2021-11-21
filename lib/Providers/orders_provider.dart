import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String? authToken;
  Orders(this.authToken, this._orders);
  Orders.c();
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cart, double amount) async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=${(authToken != null ? authToken! : "")}");
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": amount,
            "dateTime": timeStamp.toIso8601String(),
            "products": cart
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "quantity": e.quantity,
                      "price": e.price
                    })
                .toList()
          }));
      OrderItem order = OrderItem(
          id: json.decode(response.body)["name"],
          amount: amount,
          date: timeStamp,
          products: cart);
      _orders.insert(0, order);
      notifyListeners();
    } on Exception catch (e) {
      // TODO
      throw e;
    }
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=${(authToken != null ? authToken! : "")}");
    try {
      final response = await http.get(url);
      final List<OrderItem> returnedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        returnedOrders.add(OrderItem(
            id: key,
            amount: value["amount"],
            date: DateTime.parse(value["dateTime"]),
            products: (value["products"] as List<dynamic>)
                .map((item) => CartItem(
                    id: item["id"],
                    price: item["price"],
                    quantity: item["quantity"],
                    title: item["title"]))
                .toList()));
      });
      _orders = returnedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
