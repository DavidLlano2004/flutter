

import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../widgets/tarea_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final List<Tarea> _listaTareas = [];
  final TextEditingController _controller = TextEditingController();
  int _contadorId = 0;

  
  void _agregarTarea(String titulo) {
    _contadorId++;
    final nueva = Tarea(id: _contadorId, titulo: titulo);
    setState(() {
      _listaTareas.add(nueva);
    });
  }

  
  void _eliminarTarea(int index) {
    setState(() {
      _listaTareas.removeAt(index);
    });
  }

  
  void _toggleCompletada(int index, bool? value) {
    setState(() {
      _listaTareas[index].completada = value ?? false;
    });
  }

  
  int get _pendientes => _listaTareas.where((t) => !t.completada).length;

  
  void _onAgregarPressed() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      _agregarTarea(texto);
      _controller.clear();
    } else {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe una tarea primero'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: const Text(
          'Mis Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe una tarea...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
             
                    onSubmitted: (_) => _onAgregarPressed(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onAgregarPressed,
                  child: const Text('Agregar'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            
            Text(
              '$_pendientes tareas pendientes',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: _listaTareas.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay tareas aún.\n¡Agrega una arriba!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listaTareas.length,
                      itemBuilder: (context, index) {
                  
                        return TareaItem(
                          tarea: _listaTareas[index],
                          onCompletadaChanged: (value) =>
                              _toggleCompletada(index, value),
                          onEliminar: () => _eliminarTarea(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
