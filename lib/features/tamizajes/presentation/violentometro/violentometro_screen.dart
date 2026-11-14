
import 'package:flutter/material.dart';



import 'cuestionario_violentometro_screen.dart';

class ViolentometroScreen extends StatefulWidget {
  const ViolentometroScreen({super.key});

  @override
  State<ViolentometroScreen> createState() =>
      _ViolentometroScreenState();
}

class _ViolentometroScreenState
    extends State<ViolentometroScreen> {
  String? _contexto;

  static const _verde = Color(0xFF168653);
  static const _azul = Color(0xFF172D70);
  static const _gris = Color(0xFF64748B);

  final List<String> _contextos = [
    'Pareja',
    'Familia',
    'Amistad',
    'Compañeros de estudio',
    'Trabajo',
  ];

  
final List<String> _dimensiones = [
  'Descalificación y violencia verbal',
  'Manipulación, control y abuso de poder',
  'Aislamiento y violencia digital',
  'Intimidación y amenazas',
  'Violencia física',
  'Violencia sexual',
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Violentómetro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _encabezado(),
                const SizedBox(height: 24),
                _seleccionContexto(),
                const SizedBox(height: 24),
                _seccionDimensiones(),
                const SizedBox(height: 24),
                _botones(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF189768),
            Color(0xFF08663F),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 52,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            'Violentómetro',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 13),
          Text(
            'Una herramienta de orientación para '
            'reconocer situaciones de violencia '
            'en diferentes relaciones y entornos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta({
    required String titulo,
    required Widget contenido,
  }) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EAF2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: _azul,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 17),
          contenido,
        ],
      ),
    );
  }

  Widget _seleccionContexto() {
    return _tarjeta(
      titulo: '1. Selecciona el contexto',
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Indica el tipo de relación o entorno '
            'sobre el que deseas reflexionar.',
            style: TextStyle(
              color: _gris,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _contexto,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Contexto',
              prefixIcon: Icon(Icons.groups_outlined),
              border: OutlineInputBorder(),
            ),
            items: _contextos.map((contexto) {
              return DropdownMenuItem(
                value: contexto,
                child: Text(contexto),
              );
            }).toList(),
            onChanged: (valor) {
              setState(() {
                _contexto = valor;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _seccionDimensiones() {
    return _tarjeta(
      titulo: '2. Dimensiones del instrumento',
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'El cuestionario estará organizado '
            'en los siguientes apartados:',
            style: TextStyle(
              color: _gris,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          ..._dimensiones.asMap().entries.map((entry) {
            final numero = entry.key + 1;
            final nombre = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 31,
                    height: 31,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F5ED),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '$numero',
                      style: const TextStyle(
                        color: _verde,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          color: _azul,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _azul,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'El cuestionario contiene 21 preguntas '
                    'organizadas en seis dimensiones. ' 
                    'Selecciona un contexto y pulsa '
                    '"Comenzar cuestionario" para responderlas.',
                    style: TextStyle(
                      color: _gris,
                      height: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
Widget _botones() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton.icon(
        onPressed: () {
          if (_contexto == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Primero selecciona el contexto '
                  'para comenzar el cuestionario.',
                ),
              ),
            );
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CuestionarioViolentometroScreen(
                contexto: _contexto!,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.assignment_outlined,
        ),
        label: const Text(
          'Comenzar cuestionario',
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF168653),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),

      const SizedBox(height: 16),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Responde las 21 preguntas del Violentómetro. '
          'Al finalizar, podrás consultar tu resultado '
          'orientativo y visualizar el termómetro '
          'correspondiente.\n\n'
          'Esta herramienta utiliza un algoritmo experimental '
          'pendiente de validación profesional. '
          'Por ahora, realiza únicamente pruebas '
          'con datos ficticios.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1.6,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    ],
  );
}
    }