import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userID;

  Future<void> signup(String email, String password) async {
    const urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD_TojIyqA_xHfpEOUHSOsLPLTD7xhhLQE";
    Uri url = Uri.parse(urlString);
    var body = {"email": email, "password": password};
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD_TojIyqA_xHfpEOUHSOsLPLTD7xhhLQE";
    Uri url = Uri.parse(urlString);
    var body = {"email": email, "password": password};
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
    } catch (error) {
      throw error;
    }
  }
}
