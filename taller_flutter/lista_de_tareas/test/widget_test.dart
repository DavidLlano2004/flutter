// ============================================================
//  Tests básicos — equivalente a los tests de JUnit en Android
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_de_tareas/main.dart';

void main() {
  testWidgets('La app renderiza correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ListaDeTareasApp());

    expect(find.text('Mis Tareas'), findsOneWidget);
    expect(find.text('0 tareas pendientes'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });

  testWidgets('Agregar una tarea vacía muestra SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(const ListaDeTareasApp());

    await tester.tap(find.text('Agregar'));
    await tester.pump();

    expect(find.text('Escribe una tarea primero'), findsOneWidget);
  });

  testWidgets('Agregar una tarea aparece en la lista', (WidgetTester tester) async {
    await tester.pumpWidget(const ListaDeTareasApp());

    await tester.enterText(find.byType(TextField), 'Aprender Flutter');
    await tester.tap(find.text('Agregar'));
    await tester.pump();

    expect(find.text('Aprender Flutter'), findsOneWidget);
    expect(find.text('1 tareas pendientes'), findsOneWidget);
  });
}
