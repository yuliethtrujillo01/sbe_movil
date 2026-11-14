
import '../presentation/violentometro/termometro_resultado.dart';

class ResultadoCalculoViolentometro {
  const ResultadoCalculoViolentometro({
    required this.puntaje,
    required this.nivel,
    required this.resultado,
    required this.reflexiona,
    required this.recomendaciones,
  });

  final int puntaje;
  final NivelViolentometro nivel;
  final String resultado;
  final String reflexiona;
  final List<String> recomendaciones;
}

class ViolentometroCalculo {
  static ResultadoCalculoViolentometro calcular(
    Map<String, int> respuestas,
  ) {
    if (respuestas.length != 21) {
      throw ArgumentError(
        'El Violentómetro requiere exactamente 21 respuestas.',
      );
    }

    final valores = <int>[];

    for (var numero = 1; numero <= 21; numero++) {
      final id = 'v${numero.toString().padLeft(2, '0')}';
      final valor = respuestas[id];

      if (valor == null || valor < 0 || valor > 4) {
        throw ArgumentError(
          'La respuesta $id es inválida.',
        );
      }

      // Flutter utiliza índices de 0 a 4.
      // Laravel utiliza puntuaciones de 1 a 5.
      valores.add(valor + 1);
    }

    final puntaje = valores.reduce((a, b) => a + b);

    // Índices originales del controlador Laravel.
    const indicesGraves = [14, 17, 18, 19, 20];

    var maxGrave = 0;

    for (final indice in indicesGraves) {
      if (valores[indice] > maxGrave) {
        maxGrave = valores[indice];
      }
    }

    late final NivelViolentometro nivel;

    if (maxGrave >= 5) {
      nivel = NivelViolentometro.critico;
    } else if (maxGrave >= 3 || puntaje >= 85) {
      nivel = NivelViolentometro.alto;
    } else if (puntaje >= 64) {
      nivel = NivelViolentometro.alto;
    } else if (puntaje >= 43) {
      nivel = NivelViolentometro.medio;
    } else {
      nivel = NivelViolentometro.sinRiesgo;
    }

    return _informacionPorNivel(puntaje, nivel);
  }

  static ResultadoCalculoViolentometro _informacionPorNivel(
    int puntaje,
    NivelViolentometro nivel,
  ) {
    switch (nivel) {
      case NivelViolentometro.sinRiesgo:
        return ResultadoCalculoViolentometro(
          puntaje: puntaje,
          nivel: nivel,
          resultado:
              'No se identifican indicadores de riesgo '
              'asociados a situaciones de violencia '
              'en el contexto evaluado.',
          reflexiona:
              'Las relaciones saludables se construyen '
              'sobre el respeto, la confianza, la comunicación '
              'y el reconocimiento mutuo. Mantener vínculos '
              'libres de violencia favorece tu bienestar emocional.',
          recomendaciones: [
            'Continúa fortaleciendo relaciones basadas en '
                'el respeto y la empatía.',
            'Mantén hábitos de autocuidado que favorezcan '
                'tu bienestar emocional.',
            'Conserva y fortalece tus redes de apoyo.',
            'Infórmate sobre relaciones saludables '
                'y estrategias de prevención.',
          ],
        );

      case NivelViolentometro.medio:
        return ResultadoCalculoViolentometro(
          puntaje: puntaje,
          nivel: nivel,
          resultado:
              'Se identifican algunas conductas que podrían '
              'estar afectando tu bienestar emocional '
              'y la calidad de tus relaciones.',
          reflexiona:
              'Algunas situaciones de control, descalificación, '
              'manipulación o intimidación suelen normalizarse '
              'con el tiempo; sin embargo, ninguna forma '
              'de violencia debe considerarse parte natural '
              'de una relación.',
          recomendaciones: [
            'Reflexiona sobre cómo estas situaciones '
                'están impactando tu bienestar.',
            'Habla con una persona de confianza sobre '
                'lo que estás viviendo.',
            'Fortalece tus estrategias de autocuidado '
                'y establece límites saludables.',
            'Si consideras que la situación persiste '
                'o aumenta, busca orientación profesional.',
          ],
        );

      case NivelViolentometro.alto:
        return ResultadoCalculoViolentometro(
          puntaje: puntaje,
          nivel: nivel,
          resultado:
              'Se identifican situaciones compatibles '
              'con violencia que podrían representar '
              'un riesgo importante para tu bienestar '
              'emocional, psicológico o físico.',
          reflexiona:
              'Ninguna persona merece experimentar control, '
              'amenazas, humillaciones, agresiones o cualquier '
              'otra forma de violencia. No tienes que enfrentar '
              'estas situaciones en soledad.',
          recomendaciones: [
            'Busca apoyo en una persona de confianza.',
            'Evita aislarte y fortalece tu red de apoyo.',
            'Considera solicitar orientación profesional.',
            'Consulta las rutas institucionales '
                'y municipales de atención disponibles.',
          ],
        );

      case NivelViolentometro.critico:
        return ResultadoCalculoViolentometro(
          puntaje: puntaje,
          nivel: nivel,
          resultado:
              'Se identifican situaciones que podrían '
              'representar un riesgo grave para tu integridad '
              'física, emocional o psicológica y que requieren '
              'atención prioritaria.',
          reflexiona:
              'Las situaciones identificadas no deben '
              'minimizarse ni normalizarse. Tu bienestar '
              'y tu seguridad son importantes, y buscar ayuda '
              'es una decisión de protección y cuidado personal.',
          recomendaciones: [
            'Busca ayuda de manera inmediata.',
            'Contacta a una persona de confianza '
                'que pueda brindarte apoyo.',
            'Activa las rutas institucionales y municipales '
                'de atención disponibles.',
            'Si existe un riesgo inminente, comunícate '
                'con los servicios de emergencia.',
          ],
        );
    }
  }
}
