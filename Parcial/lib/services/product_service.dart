import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _base = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$_base/products'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Error al obtener productos: ${response.statusCode}');
    } catch (e) {
      throw Exception('No se pudo conectar al servidor: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_base/products/$id'));
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
      throw Exception('Producto no encontrado: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al obtener producto: $e');
    }
  }

  Future<Product> createProduct(Product p) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(p.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(jsonDecode(response.body));
      }
      throw Exception('Error al crear producto: ${response.statusCode}');
    } catch (e) {
      throw Exception('No se pudo crear el producto: $e');
    }
  }

  Future<Product> updateProduct(Product p) async {
    try {
      final response = await http.put(
        Uri.parse('$_base/products/${p.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(p.toJson()),
      );
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
      throw Exception('Error al actualizar producto: ${response.statusCode}');
    } catch (e) {
      throw Exception('No se pudo actualizar el producto: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_base/products/$id'));
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('No se pudo eliminar el producto: $e');
    }
  }
}
