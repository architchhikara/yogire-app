import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color backgroundWhite = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
  static const Color accentGreen = Color(0xFF4CAF50); // For completed tasks

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
        accentColor: primaryOrange,
        backgroundColor: backgroundWhite,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.merriweather(
          color: textDark,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.merriweather(
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.lato(
          color: textDark,
        ),
        bodyMedium: GoogleFonts.lato(
          color: textGrey,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryOrange),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryOrange,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
