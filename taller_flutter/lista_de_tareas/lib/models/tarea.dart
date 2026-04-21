

class Tarea {
  final int id;
  final String titulo;
  bool completada;

  Tarea({
    required this.id,
    required this.titulo,
    this.completada = false,
  });

  Tarea copyWith({int? id, String? titulo, bool? completada}) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      completada: completada ?? this.completada,
    );
  }


  @override
  String toString() =>
      'Tarea(id: $id, titulo: $titulo, completada: $completada)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tarea &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titulo == other.titulo &&
          completada == other.completada;

  @override
  int get hashCode => id.hashCode ^ titulo.hashCode ^ completada.hashCode;
}
