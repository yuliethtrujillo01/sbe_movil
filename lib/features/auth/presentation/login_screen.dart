
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../data/auth_repository.dart';
import 'register_screen.dart';
import '../../registro/presentation/caracterizacion_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _auth = AuthRepository();

  bool _cargando = false;
  bool _ocultar = true;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _mensaje(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await _auth.iniciarSesion(
        correo: _correo.text,
        contrasena: _contrasena.text,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CaracterizacionScreen(),
        ),
      );
    } catch (error) {
      _mensaje(_auth.mensajeError(error));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _recuperar() async {
    if (_correo.text.trim().isEmpty) {
      _mensaje('Escribe tu correo institucional primero.');
      return;
    }

    try {
      await _auth.recuperarContrasena(_correo.text);
      _mensaje(
        'Si existe una cuenta con ese correo, '
        'recibirás instrucciones para recuperar el acceso.',
      );
    } catch (error) {
      _mensaje(_auth.mensajeError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xFFF2EDFA),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.morado,
                          size: 33,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        '¡Bienvenido de nuevo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.azulPrincipal,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ingresa con tu cuenta institucional '
                        'para acceder a los tamizajes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.gris,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _correo,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Correo institucional',
                          hintText: 'usuario@uceva.edu.co',
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null ||
                              !_auth.correoInstitucional(valor)) {
                            return 'Ingresa tu correo @uceva.edu.co';
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
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _ocultar
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() => _ocultar = !_ocultar);
                            },
                          ),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Escribe tu contraseña';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _cargando ? null : _recuperar,
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: _cargando ? null : _ingresar,
                        icon: _cargando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          _cargando
                              ? 'Ingresando...'
                              : 'Iniciar sesión',
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: Text('¿No tienes una cuenta?'),
                          ),
                          TextButton(
                            onPressed: _cargando
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                            child: const Text('Regístrate'),
                          ),
                        ],
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
