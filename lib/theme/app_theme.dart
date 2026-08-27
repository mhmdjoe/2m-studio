import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
  static const Color accentColor = Color(0xFFE31E24); 
  static const Color backgroundColor = Color(0xFF050505); 
  static const Color cardColor = Color(0xFF0D0D0D);
  static const Color glassColor = Color(0x0DFFFFFF);

  static BoxDecoration glassDecoration({double blur = 10.0, double opacity = 0.05}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    );
  }

  static Widget glassEffect({required Widget child, double blur = 8.0, double opacity = 0.1, BorderRadius? borderRadius}) {
    // WEB OPTIMIZATION: BackdropFilter can cause "White Screens" on some web browsers/renderers.
    // We use a solid semi-transparent background as a fallback for stability.
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: kIsWeb 
        ? Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85), // Solid dark for Web stability
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: borderRadius,
            ),
            child: child,
          )
        : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: opacity),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                borderRadius: borderRadius,
              ),
              child: child,
            ),
          ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: cardColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.italiana(
          fontSize: 90,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          letterSpacing: -2.0,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.italiana(
          fontSize: 64,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          letterSpacing: -1.0,
        ),
        displaySmall: GoogleFonts.italiana(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          color: primaryColor.withValues(alpha: 0.7),
          height: 1.8,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          color: primaryColor.withValues(alpha: 0.5),
          height: 1.6,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 5.0,
          color: accentColor,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
