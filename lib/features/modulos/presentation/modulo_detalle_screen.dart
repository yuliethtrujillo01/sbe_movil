import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../data/modulo_repository.dart';
import '../models/modulo_model.dart';
import '../../tamizajes/presentation/bienestar_emocional/cuestionario_bienestar_emocional_screen.dart';
import '../../tamizajes/presentation/carga_academica/cuestionario_carga_academica_screen.dart';
import '../../tamizajes/presentation/violentometro/violentometro_screen.dart';

class ModuloDetalleScreen extends StatefulWidget {
  const ModuloDetalleScreen({
    super.key,
    required this.moduloId,
  });

  final String moduloId;

  @override
  State<ModuloDetalleScreen> createState() =>
      _ModuloDetalleScreenState();
}

class _ModuloDetalleScreenState extends State<ModuloDetalleScreen> {
  final ModuloRepository _repository = ModuloRepository();

  late Future<ModuloModel?> _moduloFuture;

  @override
  void initState() {
    super.initState();
    _cargarModulo();
  }

  void _cargarModulo() {
    _moduloFuture = _repository.obtenerModulo(
      widget.moduloId,
    );
  }

  void _reintentar() {
    setState(() {
      _cargarModulo();
    });
  }

  Color _colorModulo() {
    switch (widget.moduloId) {
      case 'violentometro':
        return const Color(0xFF168653);

      case 'bienestar_emocional':
        return AppColors.morado;

      case 'carga_academica':
        return const Color(0xFF304A98);

      default:
        return AppColors.azulPrincipal;
    }
  }

  IconData _iconoModulo() {
    switch (widget.moduloId) {
      case 'violentometro':
        return Icons.shield_outlined;

      case 'bienestar_emocional':
        return Icons.favorite_outline;

      case 'carga_academica':
        return Icons.menu_book_outlined;

      default:
        return Icons.assignment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text(
          'Herramientas de bienestar',
        ),
      ),
      body: FutureBuilder<ModuloModel?>(
        future: _moduloFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _mensaje(
              icono: Icons.wifi_off_outlined,
              titulo: 'No pudimos cargar este módulo',
              descripcion:
                  'Verifica tu conexión a Internet, '
                  'tu sesión y los permisos de Firestore.',
              mostrarReintentar: true,
            );
          }


          final modulo = snapshot.data;

          if (modulo == null || !modulo.activo) {
            return _mensaje(
              icono: Icons.info_outline,
              titulo: 'Módulo no disponible',
              descripcion:
                  'Este instrumento todavía no está '
                  'publicado en SBE Móvil.',
              mostrarReintentar: true,
            );
          }

          return _contenido(modulo);
        },
      ),
    );
  }

  // =====================================================
  // MENSAJES INFORMATIVOS
  // =====================================================

  Widget _mensaje({
    required IconData icono,
    required String titulo,
    required String descripcion,
    bool mostrarReintentar = false,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: AppColors.morado,
              size: 55,
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.azulPrincipal,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.gris,
                height: 1.5,
              ),
            ),
            if (mostrarReintentar) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _reintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CONTENIDO PRINCIPAL DEL MÓDULO
  // =====================================================

  Widget _contenido(ModuloModel modulo) {
    final color = _colorModulo();
    final WidgetBuilder? abrirCuestionario = switch (widget.moduloId) {
      'violentometro' => (_) => const ViolentometroScreen(),
      'bienestar_emocional' =>
        (_) => const CuestionarioBienestarEmocionalScreen(),
      'carga_academica' => (_) => const CuestionarioCargaAcademicaScreen(),
      _ => null,
    };
    final textoBoton = switch (widget.moduloId) {
      'violentometro' => 'Explorar Violentómetro',
      'bienestar_emocional' || 'carga_academica' => 'Iniciar tamizaje',
      _ => 'Cuestionario en preparación',
    };

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ENCABEZADO DEL MÓDULO
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.82),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.17,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        _iconoModulo(),
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      modulo.nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      modulo.descripcion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INDICACIONES
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFE5EAF3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Antes de comenzar',
                      style: TextStyle(
                        color: AppColors.azulPrincipal,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _indicacion(
                      Icons.fact_check_outlined,
                      'Lee cada pregunta',
                      'Revisa las indicaciones de cada apartado '
                      'antes de responder.',
                    ),
                    const SizedBox(height: 20),
                    _indicacion(
                      Icons.edit_note_outlined,
                      'Responde de forma personal',
                      'Selecciona las opciones que mejor '
                      'describan tu experiencia.',
                    ),
                    const SizedBox(height: 20),
                    _indicacion(
                      Icons.info_outline,
                      'Resultados orientativos',
                      'Los resultados no constituyen '
                      'un diagnóstico y no reemplazan '
                      'la atención profesional.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: abrirCuestionario == null
                    ? null
                    : () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: abrirCuestionario,
                          ),
                        );
                      },
                icon: Icon(
                  abrirCuestionario == null
                      ? Icons.play_arrow
                      : Icons.arrow_forward,
                ),
                label: Text(textoBoton),
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                switch (widget.moduloId) {
                  'violentometro' =>
                    'Explora el Violentómetro y consulta tus resultados '
                        'al finalizar el cuestionario.',
                  'bienestar_emocional' =>
                    'Responde las 21 preguntas en 7 bloques y consulta '
                        'tu resultado al finalizar.',
                  'carga_academica' =>
                    'Responde las 18 preguntas en 6 bloques y consulta '
                        'tu resultado al finalizar.',
                  _ => 'El cuestionario todavía no está disponible.',
                },
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gris,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TARJETAS DE INDICACIONES
  // =====================================================

  Widget _indicacion(
    IconData icono,
    String titulo,
    String descripcion,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2EDFA),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icono,
            color: AppColors.morado,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: AppColors.azulPrincipal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                descripcion,
                style: const TextStyle(
                  color: AppColors.gris,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
