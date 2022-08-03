import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mini_ecommerce/data/store.dart';
import 'package:mini_ecommerce/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiration;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiration?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBBbAMHW1iff-ISYdTdi4XkBJmY8rXqmuA";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body["error"] != null) {
      throw AuthException(body["error"]["message"]);
    } else {
      _token = body["idToken"];
      _email = body["email"];
      _uid = body["localId"];
      _expiration = DateTime.now().add(Duration(
        seconds: int.parse(body["expiresIn"]),
      ));

      Store.saveMap("userData", {
        "token": _token,
        "email": _email,
        "uderId": _uid,
        "expiration": _expiration!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap("userData");

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData["expiration"]);

    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData["token"];
    _email = userData["email"];
    _uid = userData["userId"];
    _expiration = expireDate;

    _autoLogout();
    notifyListeners();
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void logout() {
    _token = null;
    _email = null;
    _uid = null;
    _expiration = null;
    _clearAutoLogoutTimer();
    Store.remove("userData").then((_) => notifyListeners());
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();
    final timeToLogout = _expiration?.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(
        Duration(
          seconds: timeToLogout ?? 0,
        ),
        logout);
  }
}
