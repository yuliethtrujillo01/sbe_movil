
class ParticipanteModel {
  final String uid;
  final String correo;
  final String programa;
  final int semestre;
  final bool consentimientoAceptado;
  final String versionConsentimiento;

  const ParticipanteModel({
    required this.uid,
    required this.correo,
    required this.programa,
    required this.semestre,
    required this.consentimientoAceptado,
    required this.versionConsentimiento,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'correo': correo,
      'programa': programa,
      'semestre': semestre,
      'consentimientoAceptado': consentimientoAceptado,
      'versionConsentimiento': versionConsentimiento,
    };
  }

  factory ParticipanteModel.fromMap(
    Map<String, dynamic> data,
  ) {
    return ParticipanteModel(
      uid: data['uid'] as String,
      correo: data['correo'] as String,
      programa: data['programa'] as String,
      semestre: data['semestre'] as int,
      consentimientoAceptado:
          data['consentimientoAceptado'] as bool,
      versionConsentimiento:
          data['versionConsentimiento'] as String,
    );
  }
}
