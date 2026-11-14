import 'package:flutter/material.dart';

import '../../../resultados/data/resultado_repository.dart';

const _opciones = [
  'Nunca', 'Casi nunca', 'Algunas veces', 'Frecuentemente', 'Siempre',
];

typedef _Dimension = ({
  String titulo,
  String descripcion,
  List<String> preguntas,
});

const _dimensiones = <_Dimension>[
  (
    titulo: "1. Estado de Ánimo",
    descripcion: "Explora la presencia de sentimientos de tristeza, variaciones anímicas y satisfacción general en tus últimas semanas.",
    preguntas: [
      "¿Te has sentido triste o desanimado/a sin una razón aparente?",
      "¿Has experimentado cambios bruscos en tu estado de ánimo?",
      "¿Has sentido satisfacción con tu vida en general?",
    ],
  ),
  (
    titulo: "2. Regulación Emocional",
    descripcion: "Evalúa tu capacidad de controlar e identificar tus emociones ante situaciones adversas o de alta frustración.",
    preguntas: [
      "¿Te resulta difícil controlar tus emociones en situaciones de presión?",
      "¿Has reaccionado de forma impulsiva ante situaciones que te generan frustración?",
      "¿Logras identificar lo que sientes y expresarlo adecuadamente?",
    ],
  ),
  (
    titulo: "3. Estrés Percibido",
    descripcion: "Mide el nivel de sobrecarga por responsabilidades y las repercusiones físicas del estrés acumulado.",
    preguntas: [
      "¿Te has sentido abrumado/a por las responsabilidades diarias?",
      "¿Has sentido que no puedes manejar todas las cosas que tienes que hacer?",
      "¿Has experimentado tensión física (dolor de cabeza, espalda) por estrés?",
    ],
  ),
  (
    titulo: "4. Energía y Descanso",
    descripcion: "Analiza la calidad del sueño, la facilidad para dormir y los niveles diarios de energía vital.",
    preguntas: [
      "¿Te sientes cansado/a incluso después de dormir?",
      "¿Tienes dificultades para conciliar el sueño o mantenerte dormido/a?",
      "¿Sientes que tienes energía suficiente para realizar tus actividades diarias?",
    ],
  ),
  (
    titulo: "5. Motivación",
    descripcion: "Revisa tu nivel de interés por pasatiempos, metas a largo plazo y la facilidad de iniciar tareas.",
    preguntas: [
      "¿Has perdido interés en actividades que antes disfrutabas?",
      "¿Te cuesta encontrar motivación para iniciar tus tareas diarias?",
      "¿Sientes que tus metas personales y académicas tienen sentido?",
    ],
  ),
  (
    titulo: "6. Relaciones Interpersonales",
    descripcion: "Explora la percepción de soledad, frecuencia de desacuerdos y confianza con las personas que te rodean.",
    preguntas: [
      "¿Te has sentido solo/a o aislado/a de las personas que te rodean?",
      "¿Has tenido conflictos frecuentes con personas cercanas a ti?",
      "¿Sientes que puedes confiar en las personas de tu entorno?",
    ],
  ),
  (
    titulo: "7. Apoyo Social",
    descripcion: "Identifica tus redes de respaldo externo e institucional en momentos de vulnerabilidad.",
    preguntas: [
      "¿Cuentas con personas a quienes puedes recurrir cuando necesitas ayuda?",
      "¿Sientes que la institución te brinda espacios de apoyo emocional?",
      "¿Te sientes respaldado/a por tu familia, amigos o compañeros?",
    ],
  ),
];

typedef _Nivel = ({
  String etiqueta,
  Color color,
  String resultado,
  String reflexiona,
  List<String> recomendaciones,
});

const _niveles = <String, _Nivel>{
  'fortalecido': (
    etiqueta: "Bienestar fortalecido",
    color: Color(0xFF168653),
    resultado: "Presentas indicadores favorables de bienestar emocional.",
    reflexiona: "Mantener hábitos saludables y relaciones positivas constituye un factor protector para tu salud mental.",
    recomendaciones: [
      "Continúa fortaleciendo tus estrategias de autocuidado.",
      "Conserva y fortalece tus redes de apoyo.",
      "Mantén actividades que favorezcan tu bienestar.",
      "Comparte prácticas saludables con otras personas.",
    ],
  ),
  'estable': (
    etiqueta: "Bienestar estable",
    color: Color(0xFF2563EB),
    resultado: "Presentas indicadores adecuados de bienestar emocional, aunque existen aspectos susceptibles de fortalecimiento.",
    reflexiona: "El bienestar emocional es dinámico y requiere acciones permanentes de autocuidado.",
    recomendaciones: [
      "Mantén hábitos saludables.",
      "Fortalece tus redes de apoyo.",
      "Realiza actividades de bienestar.",
      "Continúa monitoreando tu salud emocional.",
    ],
  ),
  'seguimiento': (
    etiqueta: "Bienestar en seguimiento",
    color: Color(0xFFEAB308),
    resultado: "Se identifican algunos factores que podrían estar afectando tu bienestar y calidad de vida.",
    reflexiona: "El bienestar emocional requiere atención constante y estrategias de cuidado personal.",
    recomendaciones: [
      "Fortalece hábitos saludables.",
      "Busca espacios de recreación y descanso.",
      "Comparte tus emociones con personas de confianza.",
      "Considera solicitar orientación profesional.",
    ],
  ),
  'atencion': (
    etiqueta: "Bienestar que requiere atención",
    color: Color(0xFFEA580C),
    resultado: "Se identifican indicadores que podrían estar afectando significativamente tu bienestar emocional.",
    reflexiona: "Tu bienestar emocional merece atención y cuidado. Buscar apoyo es una estrategia de protección y autocuidado.",
    recomendaciones: [
      "Busca apoyo emocional o profesional.",
      "Fortalece tus redes de apoyo.",
      "Prioriza espacios de descanso y autocuidado.",
      "Consulta los servicios institucionales disponibles.",
    ],
  ),
};

// Misma escala y orden de preguntas que el controlador de Laravel.
({int puntaje, String nivel}) calcularBienestarEmocional(
  List<int> respuestas,
) {
  if (respuestas.length != 21 ||
      respuestas.any((valor) => valor < 1 || valor > 5)) {
    throw ArgumentError('Se requieren 21 respuestas entre 1 y 5.');
  }

  const positivos = {2, 5, 11, 14, 17, 18, 19, 20};
  var puntaje = 0;
  for (var i = 0; i < respuestas.length; i++) {
    final valor = respuestas[i];
    puntaje += positivos.contains(i) ? 6 - valor : valor;
  }

  final nivel = switch (puntaje) {
    <= 42 => 'fortalecido',
    <= 63 => 'estable',
    <= 84 => 'seguimiento',
    _ => 'atencion',
  };
  return (puntaje: puntaje, nivel: nivel);
}

class CuestionarioBienestarEmocionalScreen extends StatefulWidget {
  const CuestionarioBienestarEmocionalScreen({super.key});

  @override
  State<CuestionarioBienestarEmocionalScreen> createState() =>
      _CuestionarioBienestarEmocionalScreenState();
}

class _CuestionarioBienestarEmocionalScreenState
    extends State<CuestionarioBienestarEmocionalScreen> {
  static const Color _verde = Color(0xFF168653);
  static const Color _verdeOscuro = Color(0xFF11683F);
  static const Color _fondo = Color(0xFFF5F7FC);
  static const Color _texto = Color(0xFF25324B);
  static const Color _gris = Color(0xFF64748B);

  final _preguntas = [
    for (final dimension in _dimensiones)
      for (final texto in dimension.preguntas)
        (dimension: dimension.titulo, texto: texto),
  ];

  final Map<int, int> _respuestas = {};

  int _indiceActual = 0;

  bool _guardandoResultado = false;
  bool _permitirSalida = false;
  bool _dialogoAbierto = false;

  ({String dimension, String texto}) get _preguntaActual =>
      _preguntas[_indiceActual];

  bool get _esPrimeraPregunta => _indiceActual == 0;

  bool get _esUltimaPregunta => _indiceActual == _preguntas.length - 1;

  int? get _respuestaActual {
    final valor = _respuestas[_indiceActual];
    return valor == null ? null : valor - 1;
  }

  double get _progreso => (_indiceActual + 1) / _preguntas.length;

  int get _totalRespondidas => _respuestas.length;

  void _seleccionarRespuesta(int? valor) {
    if (valor == null || _guardandoResultado) {
      return;
    }

    setState(() {
      _respuestas[_indiceActual] = valor + 1;
    });
  }

  void _anterior() {
    if (_guardandoResultado || _esPrimeraPregunta) {
      return;
    }

    setState(() {
      _indiceActual--;
    });
  }

  Future<void> _siguiente() async {
    if (_guardandoResultado) {
      return;
    }

    if (_respuestaActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una respuesta para continuar.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_esUltimaPregunta) {
      await _finalizar();
    } else {
      setState(() {
        _indiceActual++;
      });
    }
  }

  Future<void> _finalizar() async {
    if (_guardandoResultado) {
      return;
    }

    if (_respuestas.length != _preguntas.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes responder las 21 preguntas '
            'antes de finalizar.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _guardandoResultado = true;
    });

    try {
      final resultado = calcularBienestarEmocional([
        for (var i = 0; i < _preguntas.length; i++) _respuestas[i]!,
      ]);
      await ResultadoRepository().guardarBienestarEmocional(
        puntaje: resultado.puntaje,
        nivel: resultado.nivel,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => _ResultadoBienestarScreen(
            puntaje: resultado.puntaje,
            claveNivel: resultado.nivel,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar el resultado. Revisa tu conexión y tu '
            'sesión, e inténtalo nuevamente.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardandoResultado = false;
        });
      }
    }
  }

  Future<bool> _confirmarSalida() async {
    final respuesta = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('¿Salir del cuestionario?'),
          content: const Text(
            'Si sales ahora, perderás las respuestas '
            'que todavía no hayas guardado '
            'como resultado final.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Continuar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _verde),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    return respuesta ?? false;
  }

  Future<void> _solicitarSalida() async {
    if (_dialogoAbierto || _guardandoResultado || _permitirSalida) return;
    _dialogoAbierto = true;
    final salir = await _confirmarSalida();
    if (!mounted) return;
    _dialogoAbierto = false;
    if (!salir) return;
    setState(() => _permitirSalida = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: _permitirSalida,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _solicitarSalida();
      },
      child: Scaffold(
        backgroundColor: _fondo,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: _texto,
          elevation: 0,
          title: const Text(
            'Cuestionario Bienestar emocional',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _guardandoResultado ? null : _solicitarSalida,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  _encabezadoProgreso(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _tarjetaPregunta(),
                          const SizedBox(height: 16),
                          _mensajeInformativo(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  _barraBotones(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezadoProgreso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Módulo: Bienestar emocional',
            style: const TextStyle(
              color: _verdeOscuro,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta ${_indiceActual + 1} '
                'de ${_preguntas.length}',
                style: const TextStyle(
                  color: _texto,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '${(_progreso * 100).round()}%',
                style: const TextStyle(
                  color: _verde,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progreso,
              backgroundColor: const Color(0xFFE3E9F1),
              valueColor: const AlwaysStoppedAnimation<Color>(_verde),
              minHeight: 9,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Respuestas completadas: '
            '$_totalRespondidas de ${_preguntas.length}',
            style: const TextStyle(color: _gris, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPregunta() {
    return Card(
      elevation: 1,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _preguntaActual.dimension,
                style: const TextStyle(
                  color: _verdeOscuro,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _preguntaActual.texto,
              style: const TextStyle(
                color: _texto,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Selecciona una respuesta:',
              style: TextStyle(
                color: _gris,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // RadioGroup evita las advertencias
            // deprecadas de Radio.groupValue.
            RadioGroup<int>(
              groupValue: _respuestaActual,
              onChanged: _seleccionarRespuesta,
              child: Column(
                children: List.generate(_opciones.length, (
                  indice,
                ) {
                  final seleccionada = _respuestaActual == indice;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: seleccionada
                          ? const Color(0xFFEAF6F0)
                          : const Color(0xFFF9FAFC),
                      border: Border.all(
                        color: seleccionada ? _verde : const Color(0xFFE2E8F0),
                        width: seleccionada ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<int>(
                      value: indice,
                      activeColor: _verde,
                      title: Text(
                        _opciones[indice],
                        style: TextStyle(
                          color: _texto,
                          fontWeight: seleccionada
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      enabled: !_guardandoResultado,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mensajeInformativo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: _gris),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Responde de acuerdo con tu experiencia. '
              'Puedes regresar a las preguntas anteriores '
              'para revisar tus respuestas. '
              'Tu resultado se mostrará al finalizar.',
              style: TextStyle(color: _gris, fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraBotones() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _esPrimeraPregunta || _guardandoResultado
                  ? null
                  : _anterior,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Anterior'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _verdeOscuro,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: _guardandoResultado ? null : _siguiente,
              icon: _guardandoResultado
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _esUltimaPregunta
                          ? Icons.check_circle_outline
                          : Icons.arrow_forward,
                      size: 18,
                    ),
              label: Text(
                _guardandoResultado
                    ? 'Guardando...'
                    : _esUltimaPregunta
                    ? 'Finalizar'
                    : 'Siguiente',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultadoBienestarScreen extends StatelessWidget {
  const _ResultadoBienestarScreen({
    required this.puntaje,
    required this.claveNivel,
  });

  final int puntaje;
  final String claveNivel;

  _Nivel get resultado => _niveles[claveNivel]!;

  static const _azul = Color(0xFF172D70);
  static const _morado = Color(0xFF5420A8);
  static const _gris = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Resultado de Bienestar emocional'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _avisoOrientativo(),
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

  Widget _avisoOrientativo() {
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
              'RESULTADO ORIENTATIVO\n'
              'Este tamizaje no es un diagnóstico ni reemplaza '
              'una evaluación profesional.',
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
          const Text(
            'Módulo: Bienestar emocional',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _gris,
            ),
          ),
          const SizedBox(height: 22),

          TermometroBienestar(claveNivel: claveNivel),

          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: resultado.color.withValues(
                alpha: 0.18,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: resultado.color,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Clasificación orientativa',
                  style: TextStyle(
                    color: _gris,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  resultado.etiqueta,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _azul,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Puntaje: $puntaje / 105',
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

class TermometroBienestar extends StatelessWidget {
  const TermometroBienestar({
    super.key,
    required this.claveNivel,
  });

  final String claveNivel;

  @override
  Widget build(BuildContext context) {
    const niveles = [
      (clave: 'atencion', titulo: 'Requiere atención'),
      (clave: 'seguimiento', titulo: 'Seguimiento'),
      (clave: 'estable', titulo: 'Estable'),
      (clave: 'fortalecido', titulo: 'Fortalecido'),
    ];
    final colorNivel = _niveles[claveNivel]!.color;

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
                    final seleccionado = item.clave == claveNivel;

                    return Container(
                      height: 53,
                      margin: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        color: _niveles[item.clave]!.color,
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
                    color: colorNivel,
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
              final seleccionado = item.clave == claveNivel;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: seleccionado
                      ? _niveles[item.clave]!.color.withValues(alpha: 0.22)
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
                        color: _niveles[item.clave]!.color,
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
