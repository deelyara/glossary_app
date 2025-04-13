// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/glossary_service.dart';
import 'services/detection_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        // Provide the GlossaryService
        ChangeNotifierProvider(create: (_) => GlossaryService()),
        Provider(create: (_) => DetectionService()),
      ],
      child: const GlossaryApp(),
    ),
  );
}