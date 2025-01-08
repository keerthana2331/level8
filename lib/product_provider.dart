import 'package:flutter/material.dart';
class ProductProvider extends ChangeNotifier {
  List<Map<String, String>> products = [];
  List<Map<String, String>> get productss => products;
  void addProduct(String name, String category) {
    products.add({'name': name, 'category': category});
    notifyListeners();
  }
  void updateProduct(int index, String name, String category) {
    products[index] = {'name': name, 'category': category};
    notifyListeners();
  }
  void deleteProduct(int index) {
    products.removeAt(index);
    notifyListeners();
  }
}