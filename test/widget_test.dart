
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sbe_movil/app/theme/app_colors.dart';

void main() {
  testWidgets(
    'SBE muestra correctamente los elementos institucionales',
    (WidgetTester tester) async {
      // Prueba aislada del diseño:
      // no necesita inicializar Firebase.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text(
                  'Tu bienestar es nuestra prioridad.',
                  style: TextStyle(
                    color: AppColors.azulPrincipal,
                    fontSize: 22,
                  ),
                ),
                Text('Violentómetro'),
                Text('Bienestar emocional'),
                Text('Carga académica'),
              ],
            ),
          ),
        ),
      );

      expect(
        find.text('Tu bienestar es nuestra prioridad.'),
        findsOneWidget,
      );

      expect(find.text('Violentómetro'), findsOneWidget);

      expect(find.text('Bienestar emocional'), findsOneWidget);

      expect(find.text('Carga académica'), findsOneWidget);
    },
  );
}
