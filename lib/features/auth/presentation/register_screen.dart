
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../data/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _confirmacion = TextEditingController();
  final _auth = AuthRepository();

  bool _cargando = false;
  bool _ocultar = true;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await _auth.registrar(
        correo: _correo.text,
        contrasena: _contrasena.text,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Revisa tu correo'),
          content: const Text(
            'Hemos enviado un enlace de verificación '
            'a tu correo institucional. Abre el enlace '
            'antes de iniciar sesión.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_auth.mensajeError(error))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(
                  color: Color(0xFFE5EAF3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xFFF2EDFA),
                        child: Icon(
                          Icons.person_add_alt_1,
                          color: AppColors.morado,
                          size: 33,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Únete a SBE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.azulPrincipal,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Crea tu cuenta para utilizar las '
                        'herramientas de bienestar universitario.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.gris,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _correo,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo institucional',
                          hintText: 'usuario@uceva.edu.co',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null ||
                              !_auth.correoInstitucional(valor)) {
                            return 'Utiliza un correo @uceva.edu.co';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _contrasena,
                        obscureText: _ocultar,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _ocultar
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _ocultar = !_ocultar);
                            },
                          ),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.length < 8) {
                            return 'Utiliza al menos 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _confirmacion,
                        obscureText: _ocultar,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar contraseña',
                          prefixIcon: Icon(Icons.verified_user_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor != _contrasena.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 26),
                      FilledButton.icon(
                        onPressed: _cargando ? null : _registrar,
                        icon: _cargando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          _cargando
                              ? 'Creando cuenta...'
                              : 'Registrarme',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Recibirás un correo para verificar '
                        'tu dirección institucional.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gris,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
