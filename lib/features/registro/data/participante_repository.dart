
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/participante_model.dart';

class ParticipanteRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ParticipanteModel?> obtenerMiPerfil() async {
    final user = _auth.currentUser;

    if (user == null || !user.emailVerified) {
      throw StateError(
        'Debes iniciar sesión con un correo verificado.',
      );
    }

    final documento = await _db
        .collection('participantes')
        .doc(user.uid)
        .get();

    if (!documento.exists) return null;

    return ParticipanteModel.fromMap(documento.data()!);
  }

  Future<void> guardarPerfil({
    required String programa,
    required int semestre,
    required bool consentimientoAceptado,
  }) async {
    final user = _auth.currentUser;

    if (user == null || !user.emailVerified) {
      throw StateError(
        'Debes verificar tu correo institucional.',
      );
    }

    if (!consentimientoAceptado) {
      throw StateError(
        'Debes aceptar voluntariamente el consentimiento.',
      );
    }

    final participante = ParticipanteModel(
      uid: user.uid,
      correo: user.email!,
      programa: programa.trim(),
      semestre: semestre,
      consentimientoAceptado: true,
      versionConsentimiento: 'v2',
    );

    await _db.collection('participantes').doc(user.uid).set({
      ...participante.toMap(),
      'fechaConsentimiento': FieldValue.serverTimestamp(),
    });
  }
}

