import 'package:flutter/material.dart';

const nexoForest = Color(0xFF173F35);
const nexoLime = Color(0xFFD8F17A);
const nexoPaper = Color(0xFFF5F5EF);
const nexoInk = Color(0xFF1C2925);
const nexoMuted = Color(0xFF7C8983);
const nexoLine = Color(0xFFE6E9E1);

final nexoTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: nexoForest,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: nexoPaper,
  appBarTheme: const AppBarTheme(
    backgroundColor: nexoPaper,
    foregroundColor: nexoInk,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: nexoInk,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      color: nexoInk,
      fontSize: 30,
      height: 1.08,
      fontWeight: FontWeight.w800,
      letterSpacing: -1,
    ),
    titleLarge: TextStyle(
      color: nexoInk,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: nexoInk,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(color: nexoMuted, fontSize: 14, height: 1.45),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    hintStyle: const TextStyle(color: nexoMuted),
    labelStyle: const TextStyle(color: nexoMuted),
    prefixIconColor: nexoMuted,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: nexoLine),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: nexoLine),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: nexoForest, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFB54747)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFB54747), width: 1.5),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: nexoForest,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    ),
  ),
);
