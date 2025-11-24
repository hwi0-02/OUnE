import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 기획서 기반 컬러 팔레트
  // Dark Theme Colors
  static const Color primaryPink = Color(0xFFFF80AB); // Hot Pink
  static const Color secondaryBlue = Color(0xFF64B5F6);
  static const Color pointGold = Color(0xFFFFD700);
  static const Color backgroundBlack = Color(0xFF121212); // Dark Background
  static const Color cardDark = Color(0xFF1E1E1E); // Dark Card
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0BEC5);
  static const Color textDark = Color(0xFF121212); // Added missing textDark

  // Aliases for compatibility
  static const Color primary = primaryPink;
  static const Color accent = secondaryBlue;
  static const Color accentPurple = Color(0xFF9C27B0);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundBlack,
      fontFamily: GoogleFonts.notoSansKr().fontFamily,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        brightness: Brightness.dark,
        primary: primaryPink,
        secondary: secondaryBlue,
        surface: cardDark,
        onSurface: textWhite,
        background: backgroundBlack,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        selectedItemColor: primaryPink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.black, // Pink bg -> Black text usually looks better or White
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
