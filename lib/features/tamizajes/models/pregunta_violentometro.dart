
class PreguntaViolentometro {
  const PreguntaViolentometro({
    required this.id,
    required this.dimension,
    required this.texto,
  });

  final String id;
  final String dimension;
  final String texto;

  
String textoParaContexto(String contexto) {
  final sujeto = switch (contexto.trim().toLowerCase()) {
    'pareja' => 'tu pareja',
    'familia' => 'algún miembro de tu familia',
    'amistad' => 'algún amigo o amiga',
    'compañeros de estudio' =>
      'algún compañero de estudio',
    'trabajo' =>
      'alguna persona de tu entorno laboral',
    _ => 'esa persona',
  };

  return texto.replaceAll('{sujeto}', sujeto);
}

}

class DatosViolentometro {
  static const opciones = [
    'Nunca',
    'Casi nunca',
    'Algunas veces',
    'Frecuentemente',
    'Siempre',
  ];

  static const preguntas = <PreguntaViolentometro>[
    // DIMENSIÓN 1: DESCALIFICACIÓN Y VIOLENCIA VERBAL
    PreguntaViolentometro(
      id: 'v01',
      dimension: '1. Descalificación y violencia verbal',
      texto: '¿Con qué frecuencia {sujeto} hace comentarios '
          'que te hacen sentir inferior, incapaz o poco valioso(a)?',
    ),
    PreguntaViolentometro(
      id: 'v02',
      dimension: '1. Descalificación y violencia verbal',
      texto: '¿Con qué frecuencia {sujeto} ridiculiza '
          'tus opiniones, sentimientos o decisiones?',
    ),
    PreguntaViolentometro(
      id: 'v03',
      dimension: '1. Descalificación y violencia verbal',
      texto: '¿Con qué frecuencia {sujeto} utiliza insultos, '
          'burlas o palabras ofensivas hacia ti?',
    ),
    PreguntaViolentometro(
      id: 'v04',
      dimension: '1. Descalificación y violencia verbal',
      texto: '¿Con qué frecuencia {sujeto} minimiza lo que '
          'sientes o te hace creer que estás exagerando?',
    ),

    // DIMENSIÓN 2: MANIPULACIÓN Y CONTROL
    PreguntaViolentometro(
      id: 'v05',
      dimension: '2. Manipulación, control y abuso de poder',
      texto: '¿Con qué frecuencia {sujeto} intenta '
          'controlar las decisiones que tomas?',
    ),
    PreguntaViolentometro(
      id: 'v06',
      dimension: '2. Manipulación, control y abuso de poder',
      texto: '¿Con qué frecuencia {sujeto} intenta decidir '
          'con quién puedes hablar o compartir tu tiempo?',
    ),
    PreguntaViolentometro(
      id: 'v07',
      dimension: '2. Manipulación, control y abuso de poder',
      texto: '¿Con qué frecuencia {sujeto} revisa tu celular, '
          'redes sociales o pertenencias sin tu consentimiento?',
    ),
    PreguntaViolentometro(
      id: 'v08',
      dimension: '2. Manipulación, control y abuso de poder',
      texto: '¿Con qué frecuencia {sujeto} utiliza el chantaje '
          'emocional para conseguir que hagas algo que no deseas?',
    ),
    PreguntaViolentometro(
      id: 'v09',
      dimension: '2. Manipulación, control y abuso de poder',
      texto: '¿Con qué frecuencia {sujeto} utiliza su posición '
          'de autoridad, poder o jerarquía para presionarte, '
          'intimidarte o influir en tus decisiones?',
    ),

    // DIMENSIÓN 3: AISLAMIENTO Y VIOLENCIA DIGITAL
    PreguntaViolentometro(
      id: 'v10',
      dimension: '3. Aislamiento y violencia digital',
      texto: '¿Con qué frecuencia {sujeto} intenta '
          'alejarte de personas importantes para ti?',
    ),
    PreguntaViolentometro(
      id: 'v11',
      dimension: '3. Aislamiento y violencia digital',
      texto: '¿Con qué frecuencia {sujeto} publica, comparte '
          'o amenaza con divulgar información personal '
          'sin tu autorización?',
    ),
    PreguntaViolentometro(
      id: 'v12',
      dimension: '3. Aislamiento y violencia digital',
      texto: '¿Con qué frecuencia {sujeto} controla tu '
          'actividad en redes sociales o invade tu privacidad '
          'mediante llamadas, mensajes o seguimiento constante?',
    ),

    // DIMENSIÓN 4: INTIMIDACIÓN Y AMENAZAS
    PreguntaViolentometro(
      id: 'v13',
      dimension: '4. Intimidación y amenazas',
      texto: '¿Con qué frecuencia {sujeto} levanta la voz, '
          'grita o adopta actitudes intimidantes hacia ti?',
    ),
    PreguntaViolentometro(
      id: 'v14',
      dimension: '4. Intimidación y amenazas',
      texto: '¿Con qué frecuencia {sujeto} te hace sentir '
          'miedo por su forma de actuar o reaccionar?',
    ),
    PreguntaViolentometro(
      id: 'v15',
      dimension: '4. Intimidación y amenazas',
      texto: '¿Con qué frecuencia {sujeto} amenaza con '
          'hacerte daño a ti o a personas cercanas?',
    ),
    PreguntaViolentometro(
      id: 'v16',
      dimension: '4. Intimidación y amenazas',
      texto: '¿Con qué frecuencia {sujeto} destruye objetos '
          'o golpea cosas con el propósito de intimidarte?',
    ),
    PreguntaViolentometro(
      id: 'v17',
      dimension: '4. Intimidación y amenazas',
      texto: '¿Con qué frecuencia has sentido que no puedes '
          'expresar desacuerdo o negarte a una solicitud '
          'por temor a represalias académicas, laborales, '
          'familiares o personales?',
    ),

    // DIMENSIÓN 5: VIOLENCIA FÍSICA
    PreguntaViolentometro(
      id: 'v18',
      dimension: '5. Violencia física',
      texto: '¿Con qué frecuencia {sujeto} te ha empujado, '
          'sujetado con fuerza o agredido físicamente?',
    ),
    PreguntaViolentometro(
      id: 'v19',
      dimension: '5. Violencia física',
      texto: '¿Con qué frecuencia {sujeto} ha intentado '
          'impedir que salgas de un lugar '
          'o restringir tu movilidad?',
    ),

    // DIMENSIÓN 6: VIOLENCIA SEXUAL
    PreguntaViolentometro(
      id: 'v20',
      dimension: '6. Violencia sexual',
      texto: '¿Con qué frecuencia {sujeto} te ha presionado '
          'para realizar actos de carácter sexual que no deseas?',
    ),
    PreguntaViolentometro(
      id: 'v21',
      dimension: '6. Violencia sexual',
      texto: '¿Con qué frecuencia {sujeto} ha tenido contacto '
          'físico o sexual contigo sin tu consentimiento?',
    ),
  ];
}
