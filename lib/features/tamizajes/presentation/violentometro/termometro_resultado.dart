
import 'package:flutter/material.dart';

enum NivelViolentometro {
  sinRiesgo,
  medio,
  alto,
  critico,
}

extension NivelViolentometroInfo on NivelViolentometro {
  String get titulo {
    switch (this) {
      case NivelViolentometro.sinRiesgo:
        return 'Sin riesgo';
      case NivelViolentometro.medio:
        return 'Medio';
      case NivelViolentometro.alto:
        return 'Alto';
      case NivelViolentometro.critico:
        return 'Crítico';
    }
  }

  Color get color {
    switch (this) {
      case NivelViolentometro.sinRiesgo:
        return Colors.white;
      case NivelViolentometro.medio:
        return const Color(0xFFF5D54B);
      case NivelViolentometro.alto:
        return const Color(0xFFF39C50);
      case NivelViolentometro.critico:
        return const Color(0xFFDE5757);
    }
  }
}

class TermometroResultado extends StatelessWidget {
  const TermometroResultado({
    super.key,
    required this.nivel,
  });

  final NivelViolentometro nivel;

  @override
  Widget build(BuildContext context) {
    final niveles = [
      NivelViolentometro.critico,
      NivelViolentometro.alto,
      NivelViolentometro.medio,
      NivelViolentometro.sinRiesgo,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Container(
                width: 74,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E0EB),
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Column(
                  children: niveles.map((item) {
                    final seleccionado = item == nivel;

                    return Container(
                      height: 53,
                      margin: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: seleccionado
                              ? const Color(0xFF172D70)
                              : Colors.transparent,
                          width: seleccionado ? 3 : 0,
                        ),
                      ),
                      child: Center(
                        child: seleccionado
                            ? const Icon(
                                Icons.arrow_right_alt,
                                color: Color(0xFF172D70),
                                size: 30,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -5),
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nivel.color,
                    border: Border.all(
                      color: const Color(0xFFD9E0EB),
                      width: 7,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 9,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.thermostat,
                    color: Color(0xFF172D70),
                    size: 33,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: niveles.map((item) {
              final seleccionado = item == nivel;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: seleccionado
                      ? item.color.withValues(alpha: 0.22)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: seleccionado
                        ? const Color(0xFF172D70)
                        : const Color(0xFFE5EAF2),
                    width: seleccionado ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        item.titulo,
                        style: TextStyle(
                          fontWeight: seleccionado
                              ? FontWeight.w900
                              : FontWeight.w500,
                          color: const Color(0xFF172D70),
                        ),
                      ),
                    ),
                    if (seleccionado)
                      const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF172D70),
                        size: 18,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ResultadoViolentometroScreen extends StatefulWidget {
  const ResultadoViolentometroScreen({
    super.key,
  });

  @override
  State<ResultadoViolentometroScreen> createState() =>
      _ResultadoViolentometroScreenState();
}

class _ResultadoViolentometroScreenState
    extends State<ResultadoViolentometroScreen> {
  NivelViolentometro _nivel = NivelViolentometro.medio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Resultado del Violentómetro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VISTA PREVIA · DATOS FICTICIOS',
                        style: TextStyle(
                          color: Color(0xFF805A12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Esta pantalla sirve para comprobar '
                        'los colores y el funcionamiento del '
                        'termómetro. No representa una '
                        'evaluación real.',
                        style: TextStyle(
                          color: Color(0xFF805A12),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFE5EAF2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 39,
                        color: Color(0xFF168653),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Termómetro de riesgo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF172D70),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Selecciona un nivel para probar '
                        'la representación visual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TermometroResultado(nivel: _nivel),
                      const SizedBox(height: 22),
                      Text(
                        'Nivel de demostración: ${_nivel.titulo}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF172D70),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<NivelViolentometro>(
                        initialValue: _nivel,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Probar otro nivel',
                          border: OutlineInputBorder(),
                        ),
                        items: NivelViolentometro.values.map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.titulo),
                          ),
                        ).toList(),
                        onChanged: (valor) {
                          if (valor == null) return;
                          setState(() => _nivel = valor);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Las puntuaciones, recomendaciones y '
                  'resultados reales se habilitarán cuando '
                  'configuremos y verifiquemos las reglas '
                  'del instrumento original.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
