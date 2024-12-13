import 'package:flutter/material.dart';


class ProductProvider extends ChangeNotifier {
  List<Map<String, String>> _products = [];

  List<Map<String, String>> get products => _products;

  void addProduct(String name, String category) {
    _products.add({'name': name, 'category': category});
    notifyListeners();
  }

  void updateProduct(int index, String name, String category) {
    _products[index] = {'name': name, 'category': category};
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }
}
