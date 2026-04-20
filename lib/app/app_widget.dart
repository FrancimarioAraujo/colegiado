import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    
    return MaterialApp.router(
      title: 'Sistema PPgEE - Coordenação de Pós-Graduação',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1877F2),
          brightness: Brightness.light,
          background: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1877F2),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 4,
        ),
        cardColor: Colors.white,
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black87,
          textColor: Colors.black87,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87),
          titleMedium: TextStyle(color: Colors.black87),
          labelLarge: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1877F2),
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1877F2),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF0F2F5),
          labelStyle: TextStyle(color: Color(0xFF0F172A)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1877F2), width: 2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1877F2),
          ),
        ),
        dividerColor: const Color(0xFFE5E7EB),
      ),
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}