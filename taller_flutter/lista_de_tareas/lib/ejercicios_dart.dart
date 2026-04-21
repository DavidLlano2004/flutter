

void ejemploVariables() {
  final String nombre = 'Flutter';
  final int version = 3;
  final double pi = 3.14159;

  var contador = 0;
  contador = 1; 

  final mensaje = 'Hola Dart';
  var edad = 22; 

  print('$nombre $version $pi $contador $mensaje $edad');
}

void ejemploNullSafety() {
  String nombreNoNulo = 'Dart';


  String? apellido = 'García';
  apellido = null; 


  int? longitud = apellido?.length;

  int longitudSegura = apellido?.length ?? 0;


  print('$longitud $longitudSegura');
}


String saludar(String nombre) {
  return 'Hola, $nombre!';
}


int sumar(int a, int b) => a + b;

String crearUsuario({
  required String nombre,
  int edad = 18,
  bool activo = true,
}) {
  return 'Usuario: $nombre, Edad: $edad, Activo: $activo';
}

void ejemploFunciones() {
  
  final usuario = crearUsuario(nombre: 'Ana', activo: false);
  print(usuario); 


  int Function(int) duplicar = (numero) => numero * 2;
  print(duplicar(5));
}

//  CONDICIONALES

void ejemploCondicionales() {
  int edad = 20;
 
  String categoria = edad >= 18 ? 'Adulto' : 'Menor';


  int dia = 3;
  String nombreDia;
  switch (dia) {
    case 1:
      nombreDia = 'Lunes';
      break;
    case 2:
      nombreDia = 'Martes';
      break;
    case 3:
      nombreDia = 'Miércoles';
      break;
    case 6:
    case 7:
      nombreDia = 'Fin de semana';
      break;
    default:
      nombreDia = 'Día inválido';
  }

  print('$categoria $nombreDia');
}

String clasificarNota(double nota) {
  if (nota >= 4.5) return 'Excelente';
  if (nota >= 3.5) return 'Bueno';
  if (nota >= 3.0) return 'Aceptable';
  return 'Reprobado';
}

void ejemploColecciones() {

  final frutas = ['Manzana', 'Banana', 'Cereza'];


  final tareas = ['Estudiar', 'Programar'];
  tareas.add('Descansar');
  tareas.removeAt(0);


  final capitales = {
    'Colombia': 'Bogotá',
    'Perú': 'Lima',
    'Chile': 'Santiago',
  };
  final capital = capitales['Colombia']; 


  final numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final pares = numeros.where((n) => n % 2 == 0).toList();   
  final dobles = numeros.map((n) => n * 2).toList();            
  final suma = numeros.reduce((acc, n) => acc + n);             

  print('$frutas $tareas $capital $pares $dobles $suma');
}


//  EJERCICIO 1 — Null Safety

String describirEstudiante(String nombre, int edad, String? correo) {
  final correoStr = correo ?? 'No registrado';
  return 'Nombre: $nombre, Edad: $edad, Correo: $correoStr';
}

//  EJERCICIO 2 — When (switch en Dart)

double calcularDescuento(String tipoCliente, double monto) {
  double descuento;
  switch (tipoCliente.toLowerCase()) {
    case 'premium':
      descuento = 0.20;
      break;
    case 'regular':
      descuento = 0.10;
      break;
    case 'nuevo':
      descuento = 0.05;
      break;
    default:
      descuento = 0.0;
  }
  return monto * (1 - descuento);
}


//  EJERCICIO 3 — Colecciones

class Estudiante {
  final String nombre;
  final double nota;
  const Estudiante(this.nombre, this.nota);
}

List<String> estudiantesAprobados() {
  final estudiantes = [
    const Estudiante('María', 4.5),
    const Estudiante('Pedro', 2.8),
    const Estudiante('Laura', 3.9),
    const Estudiante('Juan', 2.5),
    const Estudiante('Sofía', 4.2),
  ];

  final aprobados = estudiantes
      .where((e) => e.nota >= 3.0)                 
      .toList();
  aprobados.sort((a, b) => b.nota.compareTo(a.nota)); 
  return aprobados.map((e) => e.nombre).toList();     

}


//  EJERCICIO 4 

class Producto {
  final String nombre;
  final double precio;
  final int cantidad;
  const Producto(this.nombre, this.precio, this.cantidad);
}

String resumenCarrito(List<Producto> carrito) {
  final totalArticulos = carrito.fold<int>(0, (sum, p) => sum + p.cantidad);
  final totalMonto = carrito.fold<double>(0, (sum, p) => sum + p.precio * p.cantidad);
  return 'Artículos: $totalArticulos, Total: \$${totalMonto.toStringAsFixed(2)}';
}

