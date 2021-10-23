import 'package:flutter/foundation.dart';

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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
