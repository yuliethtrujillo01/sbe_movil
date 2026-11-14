import 'package:flutter/material.dart';

import '../../models/pregunta_violentometro.dart';
import '../../data/violentometro_calculo.dart';
import '../../../resultados/data/resultado_repository.dart';

import 'resultado_evaluacion_screen.dart';

class CuestionarioViolentometroScreen extends StatefulWidget {
  const CuestionarioViolentometroScreen({super.key, required this.contexto});

  final String contexto;

  @override
  State<CuestionarioViolentometroScreen> createState() =>
      _CuestionarioViolentometroScreenState();
}

class _CuestionarioViolentometroScreenState
    extends State<CuestionarioViolentometroScreen> {
  static const Color _verde = Color(0xFF168653);
  static const Color _verdeOscuro = Color(0xFF11683F);
  static const Color _fondo = Color(0xFFF5F7FC);
  static const Color _texto = Color(0xFF25324B);
  static const Color _gris = Color(0xFF64748B);

  final List<PreguntaViolentometro> _preguntas = DatosViolentometro.preguntas;

  final Map<String, int> _respuestas = {};

  int _indiceActual = 0;

  bool _guardandoResultado = false;
  bool _permitirSalida = false;

  PreguntaViolentometro get _preguntaActual => _preguntas[_indiceActual];

  bool get _esPrimeraPregunta => _indiceActual == 0;

  bool get _esUltimaPregunta => _indiceActual == _preguntas.length - 1;

  int? get _respuestaActual => _respuestas[_preguntaActual.id];

  double get _progreso => (_indiceActual + 1) / _preguntas.length;

  int get _totalRespondidas => _respuestas.length;

  String get _nombreContexto {
    switch (widget.contexto.toLowerCase().trim()) {
      case 'pareja':
        return 'Relación de pareja';

      case 'familia':
        return 'Relaciones familiares';

      case 'amistad':
        return 'Relaciones de amistad';

      case 'compañeros de estudio':
      case 'companeros':
        return 'Compañeros de estudio';

      case 'trabajo':
      case 'laboral':
        return 'Entorno laboral';

      default:
        return widget.contexto;
    }
  }

  void _seleccionarRespuesta(int? valor) {
    if (valor == null || _guardandoResultado) {
      return;
    }

    setState(() {
      _respuestas[_preguntaActual.id] = valor;
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
      // Calculamos el resultado con el algoritmo
      // del Violentómetro que ya funciona en Flutter.
      final resultado = ViolentometroCalculo.calcular(_respuestas);

      // Guardamos el resultado en Firebase Firestore.
      await ResultadoRepository().guardarViolentometro(
        contexto: widget.contexto,
        resultado: resultado,
      );

      if (!mounted) {
        return;
      }

      // Abrimos el termómetro únicamente después
      // de confirmar que Firebase guardó el resultado.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultadoEvaluacionScreen(
            resultado: resultado,
            contexto: widget.contexto,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No fue posible guardar el resultado. '
            'Verifica tu conexión e inténtalo nuevamente.\n'
            'Detalle: $error',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _permitirSalida,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _guardandoResultado) {
          return;
        }

        final salir = await _confirmarSalida();

        if (!context.mounted || !salir) {
          return;
        }

        setState(() {
          _permitirSalida = true;
        });

        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: _fondo,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: _texto,
          elevation: 0,
          title: const Text(
            'Cuestionario Violentómetro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _guardandoResultado
                ? null
                : () async {
                    final salir = await _confirmarSalida();

                    if (!context.mounted || !salir) {
                      return;
                    }

                    setState(() {
                      _permitirSalida = true;
                    });

                    Navigator.of(context).pop();
                  },
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
            'Contexto: $_nombreContexto',
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
              _preguntaActual.textoParaContexto(widget.contexto),
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
                children: List.generate(DatosViolentometro.opciones.length, (
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
                        DatosViolentometro.opciones[indice],
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
              'Tu resultado se mostrará al finalizar '
              'y se guardará en tu historial.',
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
