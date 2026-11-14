
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/modulo_model.dart';

class ModuloRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ModuloModel>> obtenerModulos() {
    return _db
        .collection('modulos')
        .where('activo', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final modulos = snapshot.docs.map((doc) {
        return ModuloModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

      modulos.sort(
        (a, b) => a.orden.compareTo(b.orden),
      );

      return modulos;
    });
  }

  Future<ModuloModel?> obtenerModulo(String id) async {
    final documento = await _db
        .collection('modulos')
        .doc(id)
        .get();

    if (!documento.exists) return null;

    return ModuloModel.fromMap(
      documento.id,
      documento.data()!,
    );
  }
}
