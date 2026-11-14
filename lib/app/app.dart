
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/home/presentation/home_screen.dart';

class SbeApp extends StatelessWidget {
  const SbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SBE Móvil - UCEVA',
      theme: AppTheme.light,
      home: HomeScreen(),
    );
  }
}
