import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_ecommerce/models/product.dart';

class ProductList with ChangeNotifier {
  final _url =
      "https://mini-ecommerce-b6674-default-rtdb.firebaseio.com/products.json";
  final List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProduct() async {
    _items.clear();

    final response = await http.get(Uri.parse(_url));

    if (response.body == "null") return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        title: productData["name"],
        description: productData["description"],
        price: productData["price"],
        imageUrl: productData["imageUrl"],
        isFavorite: productData["isFavorite"],
      ));
    });

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        "name": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      }),
    );

    final id = jsonDecode(response.body)["name"];
    _items.add(Product(
      id: id,
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final product = Product(
      id: hasId ? data["id"] as String : Random().nextDouble().toString(),
      title: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrl: data["imageUrl"] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}
