import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _base = 'https://fakestoreapi.com';

  // Productos guardados localmente durante la sesión
  static final List<Product> _localProducts = [];
  static int _nextLocalId = 10000;

  List<Product> get localProducts => List.unmodifiable(_localProducts);

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$_base/products'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final apiProducts = data.map((json) => Product.fromJson(json)).toList();
        // Mostrar productos locales primero
        return [..._localProducts, ...apiProducts];
      }
      throw Exception('Error al obtener productos: ${response.statusCode}');
    } catch (e) {
      throw Exception('No se pudo conectar al servidor: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    // Buscar primero en locales
    final local = _localProducts.where((p) => p.id == id).firstOrNull;
    if (local != null) return local;

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
    Product created;

    try {
      final response = await http.post(
        Uri.parse('$_base/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(p.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // La API puede devolver campos incompletos (sin rating, image, etc.)
        // Fusionamos con los datos originales para completar los campos faltantes
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        final mergedJson = {...p.toJson(), ...responseJson};
        created = Product.fromJson(mergedJson);
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (_) {
      // La API falló — guardar localmente con ID temporal
      created = Product(
        id: _nextLocalId++,
        title: p.title,
        price: p.price,
        description: p.description,
        category: p.category,
        image: p.image,
        rating: p.rating,
      );
    }

    // Guardar siempre en lista local para mostrarlo en home
    _localProducts.insert(0, created);
    return created;
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
