
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../registro/data/participante_repository.dart';
import '../../registro/presentation/caracterizacion_screen.dart';
import '../../modulos/presentation/modulo_detalle_screen.dart';
import '../../resultados/presentation/mis_resultados_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const Color _azul = AppColors.azulPrincipal;
  static const Color _morado = AppColors.morado;
  static const Color _verde = Color(0xFF168653);
  static const Color _gris = Color(0xFF71819C);
  static const Color _fondo = Color(0xFFF7F9FC);

  final GlobalKey _modulosKey = GlobalKey();

  // =====================================================
  // FUNCIONES GENERALES
  // =====================================================

  void _aviso(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _anchoMaximo(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1150),
        child: child,
      ),
    );
  }

  void _abrirLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _abrirPerfil(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CaracterizacionScreen(),
      ),
    );
  }

  Future<void> _abrirMisResultados(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final usuario = auth.currentUser;

    if (usuario == null) {
      _aviso(context, 'Inicia sesión para consultar tus resultados.');
      _abrirLogin(context);
      return;
    }

    try {
      await usuario.reload();
      final usuarioActualizado = auth.currentUser;

      if (!context.mounted) return;

      if (usuarioActualizado == null ||
          usuarioActualizado.uid != usuario.uid) {
        _aviso(context, 'Vuelve a iniciar sesión para continuar.');
        return;
      }

      if (!usuarioActualizado.emailVerified) {
        _aviso(context, 'Verifica tu correo institucional para continuar.');
        return;
      }

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => MisResultadosScreen(),
        ),
      );
    } on FirebaseAuthException {
      if (!context.mounted) return;
      _aviso(context, 'No se pudo verificar tu sesión. Inténtalo de nuevo.');
    }
  }

  void _irAModulos() {
    final contexto = _modulosKey.currentContext;

    if (contexto == null) return;

    Scrollable.ensureVisible(
      contexto,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      _aviso(
        context,
        'Has cerrado sesión correctamente.',
      );
    } catch (error) {
      if (!context.mounted) return;

      _aviso(
        context,
        'No se pudo cerrar la sesión: $error',
      );
    }
  }

  // =====================================================
  // VERIFICAR ACCESO A LOS MÓDULOS
  // =====================================================

  Future<void> _abrirModulo(
    BuildContext context,
    String moduloId,
  ) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      _aviso(
        context,
        'Debes iniciar sesión para acceder a los módulos.',
      );

      _abrirLogin(context);
      return;
    }

    try {
      await usuario.reload();

      final usuarioActualizado =
          FirebaseAuth.instance.currentUser;

      if (usuarioActualizado == null ||
          !usuarioActualizado.emailVerified) {
        if (!context.mounted) return;

        _aviso(
          context,
          'Verifica tu correo institucional antes de continuar.',
        );

        return;
      }

      final perfil = await ParticipanteRepository()
          .obtenerMiPerfil();

      if (!context.mounted) return;

      if (perfil == null) {
        _aviso(
          context,
          'Completa tu caracterización para continuar.',
        );

        _abrirPerfil(context);
        return;
      }

      if (!perfil.consentimientoAceptado) {
        _aviso(
          context,
          'Debes registrar tu consentimiento informado.',
        );

        return;
      }

      // Solo abre la presentación informativa.
      // Los cuestionarios siguen deshabilitados
      // hasta configurar sus preguntas y resultados.

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ModuloDetalleScreen(
            moduloId: moduloId,
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      _aviso(
        context,
        'No fue posible verificar tu perfil: $error',
      );
    }
  }

  // =====================================================
  // PANTALLA PRINCIPAL
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth;
        final escritorio = ancho >= 850;
        final margen = escritorio ? 36.0 : 20.0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _encabezado(
                    context,
                    escritorio,
                    margen,
                  ),
                  _hero(
                    context,
                    escritorio,
                    margen,
                  ),
                  _beneficios(margen),
                  _servicios(margen),
                  _modulos(context, margen),
                  _mensajeFinal(margen),
                  _footer(margen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // ENCABEZADO
  // =====================================================

  Widget _encabezado(
    BuildContext context,
    bool escritorio,
    double margen,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 14,
      ),
      child: _anchoMaximo(
        Row(
          children: [
            Image.asset(
              'assets/images/logo_sbe.png',
              height: escritorio ? 55 : 43,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const Text(
                  'SBE',
                  style: TextStyle(
                    color: _morado,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                );
              },
            ),

            const Spacer(),

            if (escritorio) ...[
              TextButton(
                onPressed: () {},
                child: const Text('Inicio'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  _irAModulos();
                },
                child: const Text('Herramientas'),
              ),
              const SizedBox(width: 18),
            ],

            // Botones de perfil e inicio de sesión.
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final usuario = snapshot.data;

                final autenticado =
                    usuario != null && usuario.emailVerified;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (autenticado) ...[
                      IconButton(
                        tooltip: 'Mi perfil',
                        onPressed: () => _abrirPerfil(context),
                        icon: const Icon(
                          Icons.person_outline,
                          color: _azul,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],

                    FilledButton.icon(
                      onPressed: () {
                        if (autenticado) {
                          _cerrarSesion(context);
                        } else {
                          _abrirLogin(context);
                        }
                      },
                      icon: Icon(
                        autenticado
                            ? Icons.logout
                            : Icons.login,
                        size: 17,
                      ),
                      label: Text(
                        autenticado
                            ? 'Salir'
                            : escritorio
                                ? 'Iniciar sesión'
                                : 'Ingresar',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _morado,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // PORTADA PRINCIPAL
  // =====================================================

  Widget _hero(
    BuildContext context,
    bool escritorio,
    double margen,
  ) {
    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EDFA),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 15,
                color: _morado,
              ),
              SizedBox(width: 7),
              Flexible(
                child: Text(
                  'Sistema de Bienestar Universitario',
                  style: TextStyle(
                    fontSize: 11,
                    color: _morado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: 'Tu ',
                style: TextStyle(color: _azul),
              ),
              TextSpan(
                text: 'bienestar',
                style: TextStyle(color: _verde),
              ),
              TextSpan(
                text: '\nes nuestra\n',
                style: TextStyle(color: _azul),
              ),
              TextSpan(
                text: 'prioridad.',
                style: TextStyle(color: _morado),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: escritorio ? 62 : 39,
            height: 1.08,
            letterSpacing: -1.6,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Un espacio de acompañamiento integral '
          'para tu desarrollo personal, académico '
          'y social durante tu vida universitaria.',
          style: TextStyle(
            color: _gris,
            fontSize: escritorio ? 17 : 15,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 26),

        FilledButton.icon(
          onPressed: _irAModulos,
          icon: const Icon(Icons.arrow_forward),
          label: const Text(
            'Explorar herramientas',
          ),
          style: FilledButton.styleFrom(
            backgroundColor: _morado,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 17,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );

    final imagen = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: escritorio ? 390 : 260,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEDE8F8),
          ),
        ),

        Image.asset(
          'assets/images/estudiantes.png',
          height: escritorio ? 400 : 270,
          fit: BoxFit.contain,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return const Icon(
              Icons.groups_rounded,
              size: 130,
              color: Color(0xFF9D7CD9),
            );
          },
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFF7F5FF),
            Color(0xFFF3F8FB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: escritorio ? 65 : 38,
      ),
      child: _anchoMaximo(
        escritorio
            ? Row(
                children: [
                  Expanded(child: texto),
                  const SizedBox(width: 28),
                  Expanded(child: imagen),
                ],
              )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  texto,
                  const SizedBox(height: 20),
                  imagen,
                ],
              ),
      ),
    );
  }

  // =====================================================
  // BENEFICIOS
  // =====================================================

  Widget _beneficios(double margen) {
    const datos = [
      (
        Icons.favorite,
        'Bienestar integral',
        'Acompañamiento universitario pensado para ti.'
      ),
      (
        Icons.shield,
        'Espacio seguro',
        'Orientación y apoyo para situaciones '
            'que necesites.'
      ),
      (
        Icons.people,
        'Acompañamiento',
        'Recursos para fortalecer tu experiencia '
            'universitaria.'
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 35,
      ),
      child: _anchoMaximo(
        LayoutBuilder(
          builder: (context, constraints) {
            final columnas =
                constraints.maxWidth >= 800 ? 3 : 1;

            final ancho =
                (constraints.maxWidth -
                    (columnas - 1) * 14) /
                    columnas;

            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: datos.map((item) {
                return SizedBox(
                  width: ancho,
                  child: _tarjetaInformativa(
                    item.$1,
                    item.$2,
                    item.$3,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _tarjetaInformativa(
    IconData icono,
    String titulo,
    String descripcion,
  ) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _icono(icono),

          const SizedBox(height: 18),

          Text(
            titulo,
            style: const TextStyle(
              color: _azul,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            descripcion,
            style: const TextStyle(
              color: _gris,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _icono(IconData icono) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDFA),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icono,
        color: _morado,
        size: 24,
      ),
    );
  }

  // =====================================================
  // TÍTULOS DE LAS SECCIONES
  // =====================================================

  Widget _tituloSeccion(
    String etiqueta,
    String titulo,
    String descripcion,
  ) {
    return Column(
      children: [
        Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _morado,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _azul,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          descripcion,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _gris,
            height: 1.6,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // SERVICIOS
  // =====================================================

  Widget _servicios(double margen) {
    const servicios = [
      (
        Icons.psychology,
        'Apoyo psicológico',
        'Espacios de orientación para el '
            'bienestar emocional.'
      ),
      (
        Icons.school,
        'Orientación académica',
        'Apoyo para afrontar los retos de '
            'tu proceso académico.'
      ),
      (
        Icons.groups,
        'Bienestar social',
        'Fortalece la convivencia y las '
            'relaciones universitarias.'
      ),
      (
        Icons.monitor_heart,
        'Salud integral',
        'Orientación relacionada con el '
            'cuidado de la salud.'
      ),
      (
        Icons.palette,
        'Cultura',
        'Espacios para la expresión y '
            'participación cultural.'
      ),
      (
        Icons.directions_run,
        'Deporte',
        'Alternativas para promover '
            'hábitos saludables.'
      ),
    ];

    return Container(
      color: _fondo,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 65,
      ),
      child: _anchoMaximo(
        Column(
          children: [
            _tituloSeccion(
              'NUESTROS SERVICIOS',
              'Bienestar pensado para ti',
              'Encuentra diferentes áreas de '
              'acompañamiento disponibles para '
              'la comunidad universitaria.',
            ),

            const SizedBox(height: 38),

            LayoutBuilder(
              builder: (context, constraints) {
                final columnas =
                    constraints.maxWidth >= 850 ? 3 : 1;

                final ancho =
                    (constraints.maxWidth -
                        (columnas - 1) * 16) /
                        columnas;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: servicios.map((servicio) {
                    return SizedBox(
                      width: ancho,
                      child: _tarjetaInformativa(
                        servicio.$1,
                        servicio.$2,
                        servicio.$3,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // MÓDULOS DE TAMIZAJE
  // =====================================================

  Widget _modulos(
    BuildContext context,
    double margen,
  ) {
    final modulos = [
      (
        'violentometro',
        'Violentómetro',
        'Identifica diferentes manifestaciones '
            'de violencia y conoce cuándo buscar ayuda.',
        const Color(0xFF189768),
        const Color(0xFF08663F),
        Icons.shield,
      ),
      (
        'bienestar_emocional',
        'Bienestar emocional',
        'Responde el tamizaje para conocer aspectos '
            'relacionados con tu bienestar emocional.',
        const Color(0xFF6B30D3),
        const Color(0xFF3D167D),
        Icons.sentiment_satisfied_alt,
      ),
      (
        'carga_academica',
        'Carga académica',
        'Reflexiona sobre las exigencias y '
            'situaciones relacionadas con '
            'tu vida académica.',
        const Color(0xFF2D4295),
        const Color(0xFF5420A8),
        Icons.menu_book,
      ),
    ];

    return Padding(
      key: _modulosKey,
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 65,
      ),
      child: _anchoMaximo(
        Column(
          children: [
            _tituloSeccion(
              'HERRAMIENTAS DE BIENESTAR',
              'Conoce nuestros módulos',
              'Accede a herramientas diseñadas '
              'para orientar tu proceso de '
              'bienestar universitario.',
            ),

            const SizedBox(height: 22),

            OutlinedButton.icon(
              onPressed: () => _abrirMisResultados(context),
              icon: const Icon(Icons.history),
              label: const Text('Mis resultados'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _morado,
                side: const BorderSide(color: _morado),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
              ),
            ),

            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final columnas =
                    constraints.maxWidth >= 850 ? 3 : 1;

                final ancho =
                    (constraints.maxWidth -
                        (columnas - 1) * 18) /
                        columnas;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: modulos.map((modulo) {
                    return SizedBox(
                      width: ancho,
                      child: _tarjetaModulo(
                        context: context,
                        moduloId: modulo.$1,
                        titulo: modulo.$2,
                        descripcion: modulo.$3,
                        inicio: modulo.$4,
                        fin: modulo.$5,
                        icono: modulo.$6,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaModulo({
    required BuildContext context,
    required String moduloId,
    required String titulo,
    required String descripcion,
    required Color inicio,
    required Color fin,
    required IconData icono,
  }) {
    return Container(
      padding: const EdgeInsets.all(26),
      constraints: const BoxConstraints(
        minHeight: 290,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [inicio, fin],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.15,
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icono,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 26),

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            descripcion,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 25),

          const Divider(
            color: Colors.white30,
          ),

          TextButton.icon(
            onPressed: () {
              _abrirModulo(
                context,
                moduloId,
              );
            },
            icon: const Icon(
              Icons.arrow_forward,
            ),
            label: Text(
              'Conocer $titulo',
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MENSAJE FINAL
  // =====================================================

  Widget _mensajeFinal(double margen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 45,
      ),
      child: _anchoMaximo(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 65,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_azul, _morado],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              const Text(
                'Tu bienestar también hace\n'
                'parte de tu formación.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  height: 1.3,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Conoce las herramientas y servicios '
                'disponibles para acompañarte durante '
                'tu vida universitaria.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 22),

              FilledButton.icon(
                onPressed: _irAModulos,
                icon: const Icon(
                  Icons.arrow_forward,
                ),
                label: const Text(
                  'Explorar herramientas',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _azul,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PIE DE PÁGINA
  // =====================================================

  Widget _footer(double margen) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF101D43),
      padding: EdgeInsets.symmetric(
        horizontal: margen,
        vertical: 40,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_sbe.png',
            height: 65,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const Text(
                'SBE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Sistema de Bienestar Universitario',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Un espacio de acompañamiento '
            'para nuestra comunidad universitaria.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 25),

          const Divider(
            color: Colors.white24,
          ),

          const SizedBox(height: 12),

          const Text(
            '© 2026 Sistema de Bienestar Universitario',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
