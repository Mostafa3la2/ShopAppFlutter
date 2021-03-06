import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? description;
  final String? title;
  final double? price;
  final String? imageURL;
  bool isFavorite;

  Product(
      {required this.id,
      required this.description,
      required this.imageURL,
      required this.title,
      required this.price,
      this.isFavorite = false});

  Product.n(
      {this.id = "",
      this.description = "",
      this.imageURL = "",
      this.title = "",
      this.price = 0,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, String userID) async {
    isFavorite = !isFavorite;

    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userID/$id.json?auth=${(token) ?? ""}");

    try {
      final response = await http.put(url, body: json.encode(this.isFavorite));
      if (response.statusCode < 400) {
        notifyListeners();
      } else {
        isFavorite = !isFavorite;
        notifyListeners();
        throw Exception();
      }
    } catch (e) {
      // TODO
      throw e;
    }
  }
}
