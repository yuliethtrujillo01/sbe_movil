import 'package:flutter/material.dart';

import '../data/resultado_repository.dart';
import '../../tamizajes/presentation/bienestar_emocional/cuestionario_bienestar_emocional_screen.dart';
import '../../tamizajes/presentation/carga_academica/cuestionario_carga_academica_screen.dart';
import '../../tamizajes/presentation/violentometro/termometro_resultado.dart';

class MisResultadosScreen extends StatefulWidget {
  const MisResultadosScreen({super.key});

  @override
  State<MisResultadosScreen> createState() => _MisResultadosScreenState();
}

class _MisResultadosScreenState extends State<MisResultadosScreen> {
  late final Stream<List<RegistroResultado>> _resultados =
      ResultadoRepository().escucharMisResultados();

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha en proceso';

    String dosDigitos(int numero) => numero.toString().padLeft(2, '0');

    return '${dosDigitos(fecha.day)}/'
        '${dosDigitos(fecha.month)}/${fecha.year} '
        '${dosDigitos(fecha.hour)}:'
        '${dosDigitos(fecha.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        title: const Text('Mis resultados'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<List<RegistroResultado>>(
        stream: _resultados,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No fue posible consultar tus resultados. '
                  'Verifica tu conexión y los permisos de Firebase.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final resultados = snapshot.data!;
          if (resultados.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Todavía no tienes resultados guardados.\n'
                  'Completa un tamizaje para ver tu historial.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final registro = resultados[index];
              final color = registro.nivel.color;
              final lineas = [
                if (registro.contexto.isNotEmpty)
                  'Contexto: ${registro.contexto}',
                'Nivel: ${registro.nivel.titulo}',
                'Puntaje: ${registro.puntaje}/${registro.puntajeMaximo}',
                _formatearFecha(registro.fecha),
              ];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: color.withAlpha(35),
                    child: Icon(
                      Icons.thermostat,
                      color: color == Colors.white
                          ? const Color(0xFF64748B)
                          : color,
                    ),
                  ),
                  title: Text(
                    registro.nombreModulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(lineas.join('\n')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => DetalleResultadoScreen(
                          resultado: registro,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalleResultadoScreen extends StatelessWidget {
  const DetalleResultadoScreen({
    super.key,
    required this.resultado,
  });

  final RegistroResultado resultado;

  Widget? _termometro() {
    switch (resultado.modulo) {
      case 'violentometro':
        return TermometroResultado(
          nivel: ResultadoRepository.codigoANivel(resultado.nivel.codigo),
        );
      case 'bienestar_emocional':
        if (!const {'fortalecido', 'estable', 'seguimiento', 'atencion'}
            .contains(resultado.nivel.codigo)) {
          return null;
        }
        return TermometroBienestar(claveNivel: resultado.nivel.codigo);
      case 'carga_academica':
        if (!const {'baja', 'moderada', 'alta', 'critica'}
            .contains(resultado.nivel.codigo)) {
          return null;
        }
        return TermometroCargaAcademica(claveNivel: resultado.nivel.codigo);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final termometro = _termometro();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        title: const Text('Detalle del resultado'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Resultado · ${resultado.nombreModulo}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (termometro != null) ...[
                      const SizedBox(height: 24),
                      termometro,
                    ],
                    const SizedBox(height: 20),
                    Text(
                      resultado.nivel.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Puntaje: ${resultado.puntaje}/${resultado.puntajeMaximo}'),
                    if (resultado.contexto.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Contexto: ${resultado.contexto}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Este resultado corresponde a un tamizaje '
                  'orientativo y no constituye un diagnóstico. '
                  'Si necesitas orientación o acompañamiento, '
                  'puedes acudir a los servicios de bienestar '
                  'y apoyo institucional.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
