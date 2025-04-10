// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'services/glossary_service.dart';
import 'services/detection_service.dart';

class GlossaryApp extends StatelessWidget {
  const GlossaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlossaryService()),
        ChangeNotifierProvider(create: (_) => DetectionService()),
      ],
      child: MaterialApp(
        title: 'Glossary App',
        theme: AppTheme.lightTheme(),
        routes: AppRoutes.getRoutes(),
        initialRoute: AppRoutes.dashboard,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}