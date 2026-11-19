import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexo/pages/add_usuario_page.dart';
import 'package:nexo/theme/app_theme.dart';

void main() {
  testWidgets('new contact form validates required data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: nexoTheme, home: const AddUsuario()),
    );

    await tester.tap(find.text('Guardar contacto'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe el nombre'), findsOneWidget);
    expect(find.text('Escribe el correo'), findsOneWidget);
    expect(find.text('Escribe el número de cuenta'), findsOneWidget);
  });
}
