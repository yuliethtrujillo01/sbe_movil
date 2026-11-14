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
    titulo: "1. Organización y Manejo de Tiempo",
    descripcion: "Evalúa tus hábitos de planificación y priorización de responsabilidades académicas frente a la procrastinación.",
    preguntas: [
      "¿Te resulta difícil organizar tus actividades académicas durante la semana?",
      "¿Sientes que el tiempo no te alcanza para cumplir con todas tus responsabilidades académicas?",
      "¿Postergas con frecuencia la realización de tus tareas o trabajos?",
    ],
  ),
  (
    titulo: "2. Exigencia Académica Percibida",
    descripcion: "Analiza la presión ejercida por la cantidad de trabajos y la carga emocional por plazos o calificaciones.",
    preguntas: [
      "¿Consideras que la cantidad de tareas y trabajos asignados es excesiva?",
      "¿Sientes presión constante por obtener buenas calificaciones?",
      "¿Los plazos de entrega de trabajos te generan ansiedad?",
    ],
  ),
  (
    titulo: "3. Fatiga Física y Mental",
    descripcion: "Mide los síntomas de cansancio corporal, tensión general y déficit de horas reparadoras de sueño.",
    preguntas: [
      "¿Te sientes agotado/a física o mentalmente al finalizar la jornada académica?",
      "¿Has experimentado dolores de cabeza, tensión muscular o problemas digestivos relacionados con la carga académica?",
      "¿Sientes que necesitas más horas de descanso de las que puedes permitirte?",
    ],
  ),
  (
    titulo: "4. Concentración y Rendimiento Académico",
    descripcion: "Revisa tu capacidad cognitiva de asimilación de conceptos y la autopercepción de desempeño en clase.",
    preguntas: [
      "¿Te cuesta mantener la concentración durante las clases o al estudiar?",
      "¿Has notado una disminución en tu rendimiento académico?",
      "¿Sientes que comprendes los contenidos de las asignaturas que cursas?",
    ],
  ),
  (
    titulo: "5. Equilibrio entre Vida Académica y Personal",
    descripcion: "Explora cómo las obligaciones de estudio repercuten en el ámbito familiar, social y los momentos de ocio.",
    preguntas: [
      "¿Sacrificas tiempo con familia o amigos por actividades académicas?",
      "¿Sientes que tu vida personal se ve afectada por las exigencias académicas?",
      "¿Logras dedicar tiempo a actividades de ocio o recreación?",
    ],
  ),
  (
    titulo: "6. Bienestar Emocional asociado a la Actividad Académica",
    descripcion: "Mide la frustración ante resultados, ideación de deserción escolar e índice de satisfacción del aprendizaje.",
    preguntas: [
      "¿Te sientes frustrado/a con frecuencia por tu desempeño académico?",
      "¿Has pensado en abandonar tus estudios debido a la carga académica?",
      "¿Sientes satisfacción con lo que estás aprendiendo actualmente?",
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
  'baja': (
    etiqueta: "Carga académica baja",
    color: Color(0xFF168653),
    resultado: "Actualmente presentas una carga académica que parece estar siendo gestionada de manera adecuada, permitiéndote mantener un equilibrio entre tus responsabilidades y tu bienestar personal.",
    reflexiona: "Mantener un equilibrio saludable entre las actividades académicas, el descanso y la vida personal es un factor protector para tu bienestar emocional y tu desempeño académico.",
    recomendaciones: [
      "Continúa utilizando estrategias de organización que te funcionen.",
      "Mantén espacios de descanso, recreación y autocuidado.",
      "Aprovecha este momento para fortalecer hábitos saludables y técnicas de estudio.",
      "Recuerda que el bienestar también se construye disfrutando de actividades fuera del ámbito académico.",
    ],
  ),
  'moderada': (
    etiqueta: "Carga académica moderada",
    color: Color(0xFFF59E0B),
    resultado: "Se identifican algunos factores asociados a una mayor exigencia académica que podrían afectar tu bienestar si se mantienen en el tiempo.",
    reflexiona: "Sentirse ocasionalmente exigido es parte de la vida universitaria; sin embargo, es importante reconocer cuándo las responsabilidades comienzan a limitar el descanso, el bienestar o la vida personal.",
    recomendaciones: [
      "Revisa la distribución de tu tiempo y establece prioridades realistas.",
      "Programa espacios de descanso y actividades que disfrutes.",
      "Evita acumular tareas y utiliza herramientas de planificación.",
      "Hablar con compañeros, docentes o personas de confianza puede ayudarte a encontrar nuevas estrategias.",
    ],
  ),
  'alta': (
    etiqueta: "Carga académica alta",
    color: Color(0xFFEA580C),
    resultado: "Se identifican indicadores de sobrecarga académica que podrían estar afectando tu bienestar emocional, tu nivel de energía y tu capacidad de concentración.",
    reflexiona: "La productividad no debe lograrse a costa de tu salud física o emocional. Sentirte constantemente agotado, preocupado o sin tiempo para ti puede ser una señal de que necesitas reajustar tus dinámicas académicas y personales.",
    recomendaciones: [
      "Prioriza las actividades más importantes y evita la autoexigencia excesiva.",
      "Establece horarios de estudio con pausas programadas.",
      "Fortalece hábitos de sueño, alimentación y actividad física.",
      "Busca apoyo académico o emocional si sientes que la carga está superando tus recursos personales.",
    ],
  ),
  'critica': (
    etiqueta: "Carga académica crítica",
    color: Color(0xFFDC2626),
    resultado: "Se identifican indicadores que sugieren una sobrecarga académica significativa, la cual podría estar afectando de manera importante tu bienestar y calidad de vida.",
    reflexiona: "Ningún logro académico debería comprometer tu salud física, emocional o tus relaciones personales. Reconocer que necesitas apoyo es un paso importante para recuperar el equilibrio y cuidar de ti mismo(a).",
    recomendaciones: [
      "Busca apoyo institucional, académico o psicológico lo antes posible.",
      "Revisa tus responsabilidades y considera estrategias para redistribuir la carga.",
      "Prioriza el descanso y las actividades básicas de autocuidado.",
      "Habla con personas de confianza y evita afrontar esta situación en soledad.",
    ],
  ),
};

// Misma escala y orden de preguntas que el controlador de Laravel.
({int puntaje, String nivel}) calcularCargaAcademica(
  List<int> respuestas,
) {
  if (respuestas.length != 18 ||
      respuestas.any((valor) => valor < 1 || valor > 5)) {
    throw ArgumentError('Se requieren 18 respuestas entre 1 y 5.');
  }

  const positivos = {11, 14, 17};
  var puntaje = 0;
  for (var i = 0; i < respuestas.length; i++) {
    final valor = respuestas[i];
    puntaje += positivos.contains(i) ? 6 - valor : valor;
  }

  final nivel = switch (puntaje) {
    <= 36 => 'baja',
    <= 54 => 'moderada',
    <= 72 => 'alta',
    _ => 'critica',
  };
  return (puntaje: puntaje, nivel: nivel);
}

class CuestionarioCargaAcademicaScreen extends StatefulWidget {
  const CuestionarioCargaAcademicaScreen({super.key});

  @override
  State<CuestionarioCargaAcademicaScreen> createState() =>
      _CuestionarioCargaAcademicaScreenState();
}

class _CuestionarioCargaAcademicaScreenState
    extends State<CuestionarioCargaAcademicaScreen> {
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
            'Debes responder las 18 preguntas '
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
      final resultado = calcularCargaAcademica([
        for (var i = 0; i < _preguntas.length; i++) _respuestas[i]!,
      ]);
      await ResultadoRepository().guardarCargaAcademica(
        puntaje: resultado.puntaje,
        nivel: resultado.nivel,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => _ResultadoCargaAcademicaScreen(
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
            'Cuestionario Carga académica',
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
            'Módulo: Carga académica',
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

class _ResultadoCargaAcademicaScreen extends StatelessWidget {
  const _ResultadoCargaAcademicaScreen({
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
        title: const Text('Resultado de Carga académica'),
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
            'Módulo: Carga académica',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _gris,
            ),
          ),
          const SizedBox(height: 22),

          TermometroCargaAcademica(claveNivel: claveNivel),

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
                  'Puntaje: $puntaje / 90',
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

class TermometroCargaAcademica extends StatelessWidget {
  const TermometroCargaAcademica({
    super.key,
    required this.claveNivel,
  });

  final String claveNivel;

  @override
  Widget build(BuildContext context) {
    const niveles = [
      (clave: 'critica', titulo: 'Crítica'),
      (clave: 'alta', titulo: 'Alta'),
      (clave: 'moderada', titulo: 'Moderada'),
      (clave: 'baja', titulo: 'Baja'),
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
