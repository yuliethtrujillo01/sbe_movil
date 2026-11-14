
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/theme/app_colors.dart';
import '../data/participante_repository.dart';
import '../models/participante_model.dart';

class CaracterizacionScreen extends StatefulWidget {
  const CaracterizacionScreen({super.key});

  @override
  State<CaracterizacionScreen> createState() =>
      _CaracterizacionScreenState();
}

class _CaracterizacionScreenState
    extends State<CaracterizacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _programaController = TextEditingController();
  final _repository = ParticipanteRepository();

  int? _semestre;
  bool _acepta = false;
  bool _cargando = true;
  bool _guardando = false;
  String? _error;
  ParticipanteModel? _perfilExistente;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _programaController.dispose();
    super.dispose();
  }

  Future<void> _cargarPerfil() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final perfil = await _repository.obtenerMiPerfil();

      if (!mounted) return;

      setState(() {
        _perfilExistente = perfil;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acepta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes aceptar voluntariamente el consentimiento.',
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      await _repository.guardarPerfil(
        programa: _programaController.text,
        semestre: _semestre!,
        consentimientoAceptado: _acepta,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Registro exitoso'),
          content: const Text(
            'Tu información académica y la aceptación '
            'del consentimiento se registraron correctamente.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el perfil: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Mi perfil'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _vistaError()
              : _perfilExistente != null
                  ? _vistaPerfilRegistrado(_perfilExistente!)
                  : _formulario(),
    );
  }

  Widget _contenedor(Widget contenido) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: contenido,
        ),
      ),
    );
  }

  Widget _vistaError() {
    return _contenedor(
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.deepOrange,
                size: 52,
              ),
              const SizedBox(height: 15),
              const Text(
                'No pudimos consultar tu perfil.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _cargarPerfil,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vistaPerfilRegistrado(ParticipanteModel perfil) {
    return _contenedor(
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Icon(
                Icons.verified,
                color: AppColors.verde,
                size: 65,
              ),
              const SizedBox(height: 18),
              const Text(
                '¡Tu perfil ya está registrado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.azulPrincipal,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Programa'),
                subtitle: Text(perfil.programa),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Semestre'),
                subtitle: Text('${perfil.semestre}'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formulario() {
    final correo =
        FirebaseAuth.instance.currentUser?.email ?? '';

    return _contenedor(
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFFF2EDFA),
              child: Icon(
                Icons.person_outline,
                color: AppColors.morado,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Completa tu perfil',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.azulPrincipal,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Registra tu información académica '
              'para continuar en SBE Móvil.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gris,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: const Color(0xFFE5EAF3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Información académica',
                    style: TextStyle(
                      color: AppColors.azulPrincipal,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: correo,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _programaController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      labelText: 'Programa académico',
                      hintText: 'Ej. Ingeniería de Sistemas',
                      prefixIcon: Icon(Icons.school_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe tu programa académico';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _semestre,
                    decoration: const InputDecoration(
                      labelText: 'Semestre académico',
                      prefixIcon:
                          Icon(Icons.calendar_month_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(15, (index) {
                      final numero = index + 1;
                      return DropdownMenuItem(
                        value: numero,
                        child: Text('Semestre $numero'),
                      );
                    }),
                    onChanged: (valor) {
                      setState(() => _semestre = valor);
                    },
                    validator: (valor) {
                      if (valor == null) {
                        return 'Selecciona tu semestre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  const Divider(),
                  const SizedBox(height: 18),
                  _seccionConsentimiento(),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed:
                        _guardando ? null : _guardarPerfil,
                    icon: _guardando
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _guardando
                          ? 'Guardando...'
                          : 'Guardar y continuar',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CONSENTIMIENTO INFORMADO CON DISEÑO INSTITUCIONAL
  // =====================================================

  Widget _seccionConsentimiento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Icon(
              Icons.description_outlined,
              color: AppColors.morado,
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Consentimiento informado',
                style: TextStyle(
                  color: AppColors.azulPrincipal,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Lee la siguiente información antes de continuar.',
          style: TextStyle(
            color: AppColors.gris,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),

        // Documento con desplazamiento independiente.
        Container(
          height: 310,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFD),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFE2E7F0),
            ),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'CONSENTIMIENTO INFORMADO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.morado,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Sistema de Bienestar Universitario – SBE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.azulPrincipal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _apartadoConsentimiento(
                    '1. Objetivo de la participación',
                    'Los instrumentos de tamizaje tienen como '
                    'finalidad favorecer el autoconocimiento '
                    'e identificar situaciones relacionadas '
                    'con el bienestar emocional, las relaciones '
                    'interpersonales y la carga académica.',
                  ),

                  _apartadoConsentimiento(
                    '2. Tratamiento de la información',
                    'La información proporcionada será utilizada '
                    'para el desarrollo y evaluación académica '
                    'de este prototipo. Su acceso deberá estar '
                    'limitado a las personas autorizadas '
                    'mediante mecanismos de seguridad.',
                  ),

                  _apartadoConsentimiento(
                    '3. Participación voluntaria',
                    'Tu participación es libre y voluntaria. '
                    'Puedes decidir no responder los '
                    'cuestionarios o interrumpir su '
                    'diligenciamiento antes de enviarlos, '
                    'sin consecuencias académicas.',
                  ),

                  _apartadoConsentimiento(
                    '4. Alcance de los resultados',
                    'Los resultados son orientativos. No '
                    'constituyen diagnósticos médicos ni '
                    'psicológicos y no reemplazan la valoración '
                    'de profesionales especializados.',
                  ),

                  _apartadoConsentimiento(
                    '5. Declaración de consentimiento',
                    'Declaro que he leído y comprendido la '
                    'información presentada y acepto participar '
                    'voluntariamente en las pruebas académicas '
                    'del Sistema de Bienestar Universitario – SBE.',
                  ),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Nota: Esta aplicación es un prototipo '
                      'académico.',
                      style: TextStyle(
                        color: Color(0xFF805D19),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(
              Icons.swipe_vertical_outlined,
              color: AppColors.gris,
              size: 16,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Desliza dentro del recuadro para leer '
                'todo el documento.',
                style: TextStyle(
                  color: AppColors.gris,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.morado,
          controlAffinity: ListTileControlAffinity.leading,
          value: _acepta,
          onChanged: (valor) {
            setState(() => _acepta = valor ?? false);
          },
          title: const Text(
            'He leído y comprendido el consentimiento '
            'informado y acepto participar voluntariamente.',
            style: TextStyle(
              color: AppColors.azulPrincipal,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _apartadoConsentimiento(
    String titulo,
    String descripcion,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: AppColors.azulPrincipal,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descripcion,
            style: const TextStyle(
              color: AppColors.gris,
              fontSize: 12.5,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
