import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userID;
  Timer? _authTimer;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String get userID {
    return _userID ?? "";
  }

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
      _token = responseData["idToken"];
      _userID = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userID": _userID,
        "expiryDate": _expiryDate!.toIso8601String()
      });
      prefs.setString("userData", userData);
      notifyListeners();
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
      _token = responseData["idToken"];
      _userID = responseData["localId"];
      var expiryRemaining = int.parse(responseData["expiresIn"]);
      _expiryDate = DateTime.now().add(Duration(seconds: expiryRemaining));
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userID": _userID,
        "expiryDate": _expiryDate!.toIso8601String()
      });
      prefs.setString("userData", userData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData["token"];
    _userID = extractedData["userID"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }
}
