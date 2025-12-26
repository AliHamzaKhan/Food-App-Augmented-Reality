import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryBlue = Color(0xFF004E89);
  static const Color successGreen = Color(0xFF06A77D);
  
  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFF8F8F8);
  static const Color lightPrimaryText = Color(0xFF1A1A1A);
  static const Color lightSecondaryText = Color(0xFF666666);
  static const Color lightDivider = Color(0xFFE0E0E0);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFB0B0B0);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryOrange,
        secondary: secondaryBlue,
        tertiary: successGreen,
        surface: lightCardBackground,
        background: lightBackground,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: true,
        // titleTextStyle: GoogleFonts.poppins(
        //   fontSize: 20,
        //   fontWeight: FontWeight.w600,
        //   color: lightPrimaryText,
        // ),
        iconTheme: const IconThemeData(color: lightPrimaryText),
      ),
      // textTheme: TextTheme(
      //   displayLarge: GoogleFonts.poppins(
      //     fontSize: 32,
      //     fontWeight: FontWeight.bold,
      //     color: lightPrimaryText,
      //   ),
      //   displayMedium: GoogleFonts.poppins(
      //     fontSize: 28,
      //     fontWeight: FontWeight.bold,
      //     color: lightPrimaryText,
      //   ),
      //   headlineSmall: GoogleFonts.poppins(
      //     fontSize: 20,
      //     fontWeight: FontWeight.w600,
      //     color: lightPrimaryText,
      //   ),
      //   bodyLarge: GoogleFonts.poppins(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w500,
      //     color: lightPrimaryText,
      //   ),
      //   bodyMedium: GoogleFonts.poppins(
      //     fontSize: 14,
      //     fontWeight: FontWeight.normal,
      //     color: lightSecondaryText,
      //   ),
      //   bodySmall: GoogleFonts.poppins(
      //     fontSize: 12,
      //     fontWeight: FontWeight.normal,
      //     color: lightSecondaryText,
      //   ),
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // textStyle: GoogleFonts.poppins(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        // hintStyle: GoogleFonts.poppins(color: lightSecondaryText),
      ),
      cardTheme: CardThemeData(
        color: lightCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryOrange,
        secondary: secondaryBlue,
        tertiary: successGreen,
        surface: darkCardBackground,
        background: darkBackground,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        // titleTextStyle: GoogleFonts.poppins(
        //   fontSize: 20,
        //   fontWeight: FontWeight.w600,
        //   color: darkPrimaryText,
        // ),
        iconTheme: const IconThemeData(color: darkPrimaryText),
      ),
      // textTheme: TextTheme(
      //   displayLarge: GoogleFonts.poppins(
      //     fontSize: 32,
      //     fontWeight: FontWeight.bold,
      //     color: darkPrimaryText,
      //   ),
      //   displayMedium: GoogleFonts.poppins(
      //     fontSize: 28,
      //     fontWeight: FontWeight.bold,
      //     color: darkPrimaryText,
      //   ),
      //   headlineSmall: GoogleFonts.poppins(
      //     fontSize: 20,
      //     fontWeight: FontWeight.w600,
      //     color: darkPrimaryText,
      //   ),
      //   bodyLarge: GoogleFonts.poppins(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w500,
      //     color: darkPrimaryText,
      //   ),
      //   bodyMedium: GoogleFonts.poppins(
      //     fontSize: 14,
      //     fontWeight: FontWeight.normal,
      //     color: darkSecondaryText,
      //   ),
      //   bodySmall: GoogleFonts.poppins(
      //     fontSize: 12,
      //     fontWeight: FontWeight.normal,
      //     color: darkSecondaryText,
      //   ),
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // textStyle: GoogleFonts.poppins(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        // hintStyle: GoogleFonts.poppins(color: darkSecondaryText),
      ),
      cardTheme: CardThemeData(
        color: darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
