import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Brand colors
const kPrimary = Color(0xFF1B5E20);       // deep green
const kPrimaryLight = Color(0xFF4CAF50);  // green
const kPrimaryDark = Color(0xFF003300);
const kAccent = Color(0xFFFF8F00);        // amber (warning/highlight)
const kSuccess = Color(0xFF2E7D32);
const kWarning = Color(0xFFE65100);       // orange
const kDanger = Color(0xFFC62828);        // red
const kBackground = Color(0xFFF5F5F5);
const kSurface = Colors.white;
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

// Payment method colors
const kColorCash = Color(0xFF2E7D32);
const kColorFlooz = Color(0xFF0288D1);
const kColorMixx = Color(0xFFE91E63);
const kColorBank = Color(0xFF5E35B1);
const kColorCredit = Color(0xFFE65100);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kAccent,
      error: kDanger,
    ),
    scaffoldBackgroundColor: kBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: kTextPrimary),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kTextPrimary),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kTextPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kTextPrimary),
      bodyLarge: TextStyle(fontSize: 15, color: kTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: kTextSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kTextPrimary),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(space: 1, thickness: 1, color: Color(0xFFEEEEEE)),
  );
}

// FCFA formatter: 125 000 FCFA
String formatFcfa(int amount) {
  final f = NumberFormat('#,##0', 'fr_FR');
  // Use space as thousands separator (FCFA convention)
  return '${f.format(amount).replaceAll(',', ' ')} FCFA';
}

String formatFcfaCompact(int amount) {
  if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1).replaceAll('.', ',')} M FCFA';
  if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)} k FCFA';
  return '$amount FCFA';
}

Color paymentMethodColor(String method) {
  switch (method) {
    case 'CASH': return kColorCash;
    case 'FLOOZ': return kColorFlooz;
    case 'MIXX': return kColorMixx;
    case 'BANK_TRANSFER': return kColorBank;
    case 'CREDIT': return kColorCredit;
    default: return kTextSecondary;
  }
}

String paymentMethodLabel(String method, {bool fr = true}) {
  final labels = fr
      ? {'CASH': 'Espèces', 'FLOOZ': 'Flooz', 'MIXX': 'Mixx', 'BANK_TRANSFER': 'Banque', 'CREDIT': 'Crédit', 'CHEQUE': 'Chèque'}
      : {'CASH': 'Cash', 'FLOOZ': 'Flooz', 'MIXX': 'Mixx', 'BANK_TRANSFER': 'Bank', 'CREDIT': 'Credit', 'CHEQUE': 'Cheque'};
  return labels[method] ?? method;
}
