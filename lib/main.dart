import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  Map<String, dynamic>? pokemon;
  bool loading = true;
  String? error;

  // Colores por tipo de Pokemon
  final Map<String, Color> typeColors = {
    'fire': Colors.orange,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow.shade700,
    'psychic': Colors.pink,
    'ice': Colors.cyan,
    'dragon': Colors.indigo,
    'dark': Colors.brown,
    'fairy': Colors.pinkAccent,
    'normal': Colors.grey,
    'fighting': Colors.deepOrange,
    'flying': Colors.lightBlue,
    'poison': Colors.purple,
    'ground': Colors.brown.shade300,
    'rock': Colors.brown.shade400,
    'bug': Colors.lightGreen,
    'ghost': Colors.deepPurple,
    'steel': Colors.blueGrey,
  };

  @override
  void initState() {
    super.initState();
    fetchRandomPokemon();
  }

  Future<void> fetchRandomPokemon() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Hay 1025 Pokemon disponibles
      final int randomId = Random().nextInt(1025) + 1;
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          pokemon = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = 'No se pudo cargar el Pokemon';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexion. Revisa tu internet.';
        loading = false;
      });
    }
  }

  Color getTypeColor() {
    if (pokemon == null) return Colors.red;
    final tipo = pokemon!['types'][0]['type']['name'] as String;
    return typeColors[tipo] ?? Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = getTypeColor();

    return Scaffold(
      backgroundColor: loading ? Colors.white : color.withValues(alpha: 0.15),
      appBar: AppBar(
        backgroundColor: loading ? Colors.red : color,
        title: const Text(
          'Pokedex',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text('Cargando Pokemon...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(error!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchRandomPokemon,
                        child: const Text('Intentar de nuevo'),
                      ),
                    ],
                  ),
                )
              : _buildPokemonCard(color),
    );
  }

  Widget _buildPokemonCard(Color color) {
    final name = (pokemon!['name'] as String).toUpperCase();
    final id = pokemon!['id'];
    final imageUrl =
        pokemon!['sprites']['other']['official-artwork']['front_default'] ??
        pokemon!['sprites']['front_default'];
    final types = (pokemon!['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();
    final height = (pokemon!['height'] as int) / 10; // en metros
    final weight = (pokemon!['weight'] as int) / 10; // en kg

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tarjeta principal
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.3)],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Numero del Pokemon
                    Text(
                      '#${id.toString().padLeft(3, '0')}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Imagen
                    if (imageUrl != null)
                      Image.network(
                        imageUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    // Nombre
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tipos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: types
                          .map(
                            (tipo) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tipo.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Stats basicos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem('Altura', '${height}m'),
                        Container(width: 1, height: 40, color: Colors.white54),
                        _statItem('Peso', '${weight}kg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Boton de Pokemon aleatorio
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: fetchRandomPokemon,
                icon: const Icon(Icons.shuffle, color: Colors.white),
                label: const Text(
                  'Otro Pokemon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
