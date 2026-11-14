import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../tamizajes/data/violentometro_calculo.dart';
import '../../tamizajes/presentation/violentometro/termometro_resultado.dart';

class NivelResultado {
  const NivelResultado(this.codigo, this.titulo, this.color);

  final String codigo;
  final String titulo;
  final Color color;

  static const _bienestar = {
    'fortalecido': NivelResultado(
      'fortalecido', 'Bienestar fortalecido', Color(0xFF168653),
    ),
    'estable': NivelResultado(
      'estable', 'Bienestar estable', Color(0xFF2563EB),
    ),
    'seguimiento': NivelResultado(
      'seguimiento', 'Bienestar en seguimiento', Color(0xFFEAB308),
    ),
    'atencion': NivelResultado(
      'atencion', 'Bienestar que requiere atención', Color(0xFFEA580C),
    ),
  };

  static const _cargaAcademica = {
    'baja': NivelResultado(
      'baja', 'Carga académica baja', Color(0xFF168653),
    ),
    'moderada': NivelResultado(
      'moderada', 'Carga académica moderada', Color(0xFFF59E0B),
    ),
    'alta': NivelResultado(
      'alta', 'Carga académica alta', Color(0xFFEA580C),
    ),
    'critica': NivelResultado(
      'critica', 'Carga académica crítica', Color(0xFFDC2626),
    ),
  };

  static NivelResultado desdeCodigo(String modulo, String codigo) {
    if (modulo == 'bienestar_emocional') {
      final nivel = _bienestar[codigo];
      if (nivel != null) return nivel;
    } else if (modulo == 'carga_academica') {
      final nivel = _cargaAcademica[codigo];
      if (nivel != null) return nivel;
    } else if (modulo == 'violentometro') {
      final nivel = ResultadoRepository.codigoANivel(codigo);
      return NivelResultado(codigo, nivel.titulo, nivel.color);
    }
    return NivelResultado(codigo, 'Nivel no reconocido', const Color(0xFF64748B));
  }
}

class RegistroResultado {
  final String id;
  final String modulo;
  final String contexto;
  final int puntaje;
  final NivelResultado nivel;
  final DateTime? fecha;

  const RegistroResultado({
    required this.id,
    required this.modulo,
    required this.contexto,
    required this.puntaje,
    required this.nivel,
    required this.fecha,
  });

  String get nombreModulo => switch (modulo) {
    'violentometro' => 'Violentómetro',
    'bienestar_emocional' => 'Bienestar emocional',
    'carga_academica' => 'Carga académica',
    _ => modulo,
  };

  int get puntajeMaximo => modulo == 'carga_academica' ? 90 : 105;

  factory RegistroResultado.desdeDocumento(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final datos = doc.data();
    final modulo = datos['modulo'] as String;
    return RegistroResultado(
      id: doc.id,
      modulo: modulo,
      contexto: (datos['contexto'] as String?) ?? '',
      puntaje: datos['puntaje'] as int,
      nivel: NivelResultado.desdeCodigo(modulo, datos['nivel'] as String),
      fecha: (datos['fecha'] as Timestamp?)?.toDate(),
    );
  }
}

class ResultadoRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User _obtenerUsuario() {
    final usuario = _auth.currentUser;
    if (usuario == null) {
      throw StateError('Debes iniciar sesión.');
    }
    if (!usuario.emailVerified) {
      throw StateError('Debes verificar tu correo institucional.');
    }
    return usuario;
  }

  DocumentReference<Map<String, dynamic>> _perfil(String uid) {
    return _firestore.collection('participantes').doc(uid);
  }

  static String nivelACodigo(NivelViolentometro nivel) => switch (nivel) {
    NivelViolentometro.sinRiesgo => 'sin_riesgo',
    NivelViolentometro.medio => 'medio',
    NivelViolentometro.alto => 'alto',
    NivelViolentometro.critico => 'critico',
  };

  static NivelViolentometro codigoANivel(String codigo) => switch (codigo) {
    'sin_riesgo' => NivelViolentometro.sinRiesgo,
    'medio' => NivelViolentometro.medio,
    'alto' => NivelViolentometro.alto,
    'critico' => NivelViolentometro.critico,
    _ => throw FormatException('Nivel desconocido: $codigo'),
  };

  String _normalizarContexto(String contexto) => switch (
    contexto.trim().toLowerCase()
  ) {
    'pareja' => 'pareja',
    'familia' => 'familia',
    'amistad' => 'amistad',
    'compañeros de estudio' || 'companeros' => 'companeros',
    'trabajo' || 'laboral' => 'laboral',
    _ => throw StateError('Contexto no válido: $contexto'),
  };

  Future<String> guardarViolentometro({
    required String contexto,
    required ResultadoCalculoViolentometro resultado,
  }) {
    return _guardar(
      modulo: 'violentometro',
      contexto: _normalizarContexto(contexto),
      puntaje: resultado.puntaje,
      nivel: nivelACodigo(resultado.nivel),
    );
  }

  Future<String> guardarBienestarEmocional({
    required int puntaje,
    required String nivel,
  }) {
    if (puntaje < 21 || puntaje > 105) {
      throw ArgumentError.value(puntaje, 'puntaje', 'Debe estar entre 21 y 105.');
    }
    final esperado = switch (puntaje) {
      <= 42 => 'fortalecido',
      <= 63 => 'estable',
      <= 84 => 'seguimiento',
      _ => 'atencion',
    };
    if (nivel != esperado) {
      throw ArgumentError.value(nivel, 'nivel', 'No coincide con el puntaje.');
    }
    return _guardar(
      modulo: 'bienestar_emocional',
      puntaje: puntaje,
      nivel: nivel,
    );
  }

  Future<String> guardarCargaAcademica({
    required int puntaje,
    required String nivel,
  }) {
    if (puntaje < 18 || puntaje > 90) {
      throw ArgumentError.value(puntaje, 'puntaje', 'Debe estar entre 18 y 90.');
    }
    final esperado = switch (puntaje) {
      <= 36 => 'baja',
      <= 54 => 'moderada',
      <= 72 => 'alta',
      _ => 'critica',
    };
    if (nivel != esperado) {
      throw ArgumentError.value(nivel, 'nivel', 'No coincide con el puntaje.');
    }
    return _guardar(
      modulo: 'carga_academica',
      puntaje: puntaje,
      nivel: nivel,
    );
  }

  Future<String> _guardar({
    required String modulo,
    String? contexto,
    required int puntaje,
    required String nivel,
  }) async {
    final usuario = _obtenerUsuario();
    await usuario.reload();
    final usuarioActual = _obtenerUsuario();
    if (usuario.uid != usuarioActual.uid) {
      throw StateError('La sesión cambió durante el guardado.');
    }
    await usuarioActual.getIdToken(true);

    final referenciaPerfil = _perfil(usuarioActual.uid);
    final perfil = await referenciaPerfil.get();
    if (!perfil.exists) {
      throw StateError('No se encontró tu perfil de caracterización.');
    }
    if (perfil.data()?['consentimientoAceptado'] != true) {
      throw StateError('No se encontró la aceptación del consentimiento.');
    }
    if (_auth.currentUser?.uid != usuarioActual.uid) {
      throw StateError('La sesión cambió durante el guardado.');
    }

    final referencia = await referenciaPerfil.collection('resultados').add({
      'modulo': modulo,
      'contexto': ?contexto,
      'puntaje': puntaje,
      'nivel': nivel,
      'fecha': FieldValue.serverTimestamp(),
      'versionAlgoritmo': '1.0',
    });
    return referencia.id;
  }

  Stream<List<RegistroResultado>> escucharMisResultados() {
    return _perfil(_obtenerUsuario().uid)
        .collection('resultados')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((consulta) =>
            consulta.docs.map(RegistroResultado.desdeDocumento).toList());
  }
}
