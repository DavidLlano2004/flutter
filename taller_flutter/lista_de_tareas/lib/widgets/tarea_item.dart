
import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TareaItem extends StatelessWidget {
  final Tarea tarea;
  final ValueChanged<bool?> onCompletadaChanged; 
  final VoidCallback onEliminar;                 

  const TareaItem({
    super.key,
    required this.tarea,
    required this.onCompletadaChanged,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
          
            Checkbox(
              value: tarea.completada,
              onChanged: onCompletadaChanged,
            ),

           
            Expanded(
              child: Text(
                tarea.titulo,
                style: TextStyle(
                  fontSize: 16,
             
                  decoration: tarea.completada
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: tarea.completada ? Colors.grey : Colors.black87,
                ),
              ),
            ),

        
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              tooltip: 'Eliminar tarea',
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
