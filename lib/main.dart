import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/formula_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormulaProvider()),
      ],
      child: const FormulaDeckApp(),
    ),
  );
}

class FormulaDeckApp extends StatelessWidget {
  const FormulaDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formula X',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0B1120),
      primaryColor: const Color(0xFF38BDF8),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF38BDF8),
        secondary: Color(0xFF818CF8),
        surface: Color(0xFF1E293B),
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
