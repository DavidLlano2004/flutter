import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/error_view.dart';
import 'detail_screen.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  late AnimationController _staggerController;
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadProducts();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  void _buildAnimations(int count) {
    _fadeAnimations.clear();
    _slideAnimations.clear();
    final int total = count.clamp(0, 20);
    for (int i = 0; i < total; i++) {
      final double start = (i / total) * 0.6;
      final double end = start + 0.4;
      _fadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final products = await _service.getProducts();
      if (!mounted) return;
      _buildAnimations(products.length);
      setState(() {
        _products = products;
        _loading = false;
      });
      _staggerController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _goToDetail(Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, a2) => DetailScreen(product: product),
        transitionsBuilder: (ctx, animation, a2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    ).then((_) => _loadProducts());
  }

  void _goToCreate() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, a2) => const CreateScreen(),
        transitionsBuilder: (ctx, animation, a2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text(
          'FakeStore',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _loading
          ? _buildLoading()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _loadProducts)
              : _buildGrid(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreate,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.2),
            duration: const Duration(milliseconds: 800),
            builder: (_, value, child) => Transform.scale(scale: value, child: child),
            child: const CircularProgressIndicator(color: Colors.indigo, strokeWidth: 3),
          ),
          const SizedBox(height: 20),
          const Text('Cargando productos...', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        if (index < _fadeAnimations.length) {
          return FadeTransition(
            opacity: _fadeAnimations[index],
            child: SlideTransition(
              position: _slideAnimations[index],
              child: ProductCard(
                product: _products[index],
                onTap: () => _goToDetail(_products[index]),
              ),
            ),
          );
        }
        return ProductCard(
          product: _products[index],
          onTap: () => _goToDetail(_products[index]),
        );
      },
    );
  }
}
