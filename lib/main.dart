// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'config/theme.dart'; // Import theme loading logic
import 'services/glossary_service.dart'; // Import GlossaryService
import 'services/detection_service.dart';
import 'widgets/terms/term_table.dart';
import 'models/term.dart';

void main() async { // Make main asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  // Load color schemes from JSON
  final colorSchemes = await loadColorSchemesFromJson('assets/theme/app_colors.json');
  final lightColorScheme = colorSchemes['light']!;
  final darkColorScheme = colorSchemes['dark']!;

  // Set preferred orientations (optional, keep if needed)
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  // System UI Overlay Style (Consider setting based on theme later)
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );

  runApp(
    MultiProvider(
      providers: [
        // Provide the GlossaryService
        ChangeNotifierProvider(create: (_) => GlossaryService()),
        ChangeNotifierProvider(create: (_) => DetectionService()),
        // Provide other services if needed
      ],
      child: GlossaryApp(
        lightColorScheme: lightColorScheme,
        darkColorScheme: darkColorScheme,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DetectionService()),
        ChangeNotifierProvider(create: (_) => GlossaryService()),
      ],
      child: MaterialApp(
        title: 'Glossary App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4361EE),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const DemoScreen(),
      ),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  List<Term> _terms = [];
  bool _showEmptyState = true;

  void _toggleEmptyState() {
    setState(() {
      _showEmptyState = !_showEmptyState;
      _terms = _showEmptyState 
          ? [] 
          : [
              Term(
                text: 'Example Term',
                usageScore: 25,
                examples: ['Used in documentation', 'Found in code'],
                exampleSources: ['/docs', '/code'],
                doNotTranslate: false,
                caseSensitive: true,
              ),
            ];
    });
  }

  void _detectTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detect terms button clicked!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _translateTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Translate button clicked!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossary Demo'),
        actions: [
          TextButton(
            onPressed: _toggleEmptyState,
            child: Text(_showEmptyState ? 'Show Terms' : 'Hide Terms'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TermTable(
          terms: _terms,
          onDoNotTranslateToggle: (term, value) {
            setState(() {
              term.doNotTranslate = value;
            });
          },
          onCaseSensitiveToggle: (term, value) {
            setState(() {
              term.caseSensitive = value;
            });
          },
          onAddTerm: (term) {},
          onRejectTerm: (term) {},
          onDetectTerms: _detectTerms,
          onTranslate: _translateTerms,
        ),
      ),
    );
  }
}