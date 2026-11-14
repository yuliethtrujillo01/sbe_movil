
class ModuloModel {
  final String id;
  final String nombre;
  final String descripcion;
  final bool activo;
  final int orden;

  const ModuloModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.activo,
    required this.orden,
  });

  factory ModuloModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return ModuloModel(
      id: id,
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      activo: data['activo'] as bool? ?? false,
      orden: (data['orden'] as num?)?.toInt() ?? 0,
    );
  }
}
