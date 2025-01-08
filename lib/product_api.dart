import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leveleight/product_model.dart';

class ProductApiService {
  static const String baseUrl =
      'https://crudcrud.com/api/63da88d6e4664cab88c31279e0255e38/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Fetch Response Status: ${response.statusCode}');
      print('Fetch Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final Map<String, dynamic> productJson = product.toJson();
      productJson.remove('_id');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(productJson),
      );

      print('Add Response Status: ${response.statusCode}');
      print('Add Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to add product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    try {
      final Map<String, dynamic> productJson = product.toJson();
      productJson.remove('_id');
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(productJson),
      );

      print('Edit Response Status: ${response.statusCode}');
      print('Edit Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to edit product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error editing product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Delete Response Status: ${response.statusCode}');
      print('Delete Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
