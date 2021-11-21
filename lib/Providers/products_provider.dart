import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shopapp/Providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Products.c();
  String? authToken;
  String? userID;

  Products(this.authToken, this.userID, this._items);

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findProductByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addItems(Product product) async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/product.json?auth=${(authToken) ?? ""}");
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title!,
            "description": product.description!,
            "price": product.price!,
            "imageURL": product.imageURL!,
          }));
      _items.add(Product(
          id: json.decode(response.body)["name"],
          description: product.description,
          imageURL: product.imageURL,
          title: product.title,
          price: product.price));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateItem(String id, Product product) async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/product/$id.json?auth=${(authToken) ?? ""}");
    final productIndex = _items.indexWhere((element) => element.id == id);

    if (productIndex >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              "title": product.title!,
              "description": product.description!,
              "price": product.price,
              "imageURL": product.imageURL,
            }));
        _items[productIndex] = product;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  Future<void> deleteItem(String id) async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/product/$id.json?auth=${(authToken) ?? ""}");

    final response = await http.delete(url);
    if (response.statusCode < 400) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      throw Exception();
    }
  }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.parse(
        "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/product.json?auth=${(authToken) ?? ""}");
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          "https://shopappflutter-5a9f2-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userID.json?auth=${(authToken) ?? ""}");
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodID, productData) {
        loadedProducts.add(Product(
            id: prodID,
            description: productData["description"],
            imageURL: productData["imageURL"],
            title: productData["title"],
            price: productData["price"],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodID] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
      // TODO
    }
  }
}
