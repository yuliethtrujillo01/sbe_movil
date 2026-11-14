
import 'package:flutter/material.dart';

import '../../data/violentometro_calculo.dart';
import 'termometro_resultado.dart';

class ResultadoEvaluacionScreen extends StatelessWidget {
  const ResultadoEvaluacionScreen({
    super.key,
    required this.resultado,
    required this.contexto,
  });

  final ResultadoCalculoViolentometro resultado;
  final String contexto;

  static const _azul = Color(0xFF172D70);
  static const _morado = Color(0xFF5420A8);
  static const _gris = Color(0xFF64748B);

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
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _avisoPrototipo(),
                const SizedBox(height: 20),
                _tarjetaResultado(),
                const SizedBox(height: 20),
                _tarjetaTexto(
                  icono: Icons.info_outline,
                  titulo: 'Interpretación orientativa',
                  contenido: resultado.resultado,
                ),
                const SizedBox(height: 20),
                _tarjetaTexto(
                  icono: Icons.favorite_outline,
                  titulo: 'Para reflexionar',
                  contenido: resultado.reflexiona,
                ),
                const SizedBox(height: 20),
                _tarjetaRecomendaciones(),
                const SizedBox(height: 25),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Finalizar y volver'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _morado,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avisoPrototipo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFF0D69B),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFF9B6515),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'RESULTADO EXPERIMENTAL\n'
              'La clasificación utiliza una propuesta '
              'de algoritmo pendiente de validación '
              'por el equipo psicosocial. No es un '
              'diagnóstico ni una evaluación profesional. '
              'Prueba únicamente con datos ficticios.',
              style: TextStyle(
                color: Color(0xFF805A12),
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaResultado() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFE5EAF2),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.thermostat,
            color: _morado,
            size: 38,
          ),
          const SizedBox(height: 10),
          const Text(
            'Termómetro de resultados',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _azul,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Contexto: $contexto',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _gris,
            ),
          ),
          const SizedBox(height: 22),

          // Termómetro que ya construimos.
          TermometroResultado(
            nivel: resultado.nivel,
          ),

          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: resultado.nivel.color.withValues(
                alpha: 0.18,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: resultado.nivel == NivelViolentometro.sinRiesgo
                    ? const Color(0xFFCBD5E1)
                    : resultado.nivel.color,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Clasificación experimental',
                  style: const TextStyle(
                    color: _gris,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  resultado.nivel.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Puntaje: ${resultado.puntaje} / 105',
                  style: const TextStyle(
                    color: _azul,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaTexto({
    required IconData icono,
    required String titulo,
    required String contenido,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
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
          Row(
            children: [
              Icon(icono, color: _morado),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            contenido,
            style: const TextStyle(
              color: _gris,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaRecomendaciones() {
    return Container(
      padding: const EdgeInsets.all(22),
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
          const Row(
            children: [
              Icon(
                Icons.volunteer_activism_outlined,
                color: _morado,
              ),
              SizedBox(width: 10),
              Text(
                'Recomendaciones',
                style: TextStyle(
                  color: _azul,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          ...resultado.recomendaciones.map(
            (recomendacion) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF168653),
                    size: 20,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      recomendacion,
                      style: const TextStyle(
                        color: _gris,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
