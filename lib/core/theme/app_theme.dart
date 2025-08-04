import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final _baseColor = Color.fromRGBO(24, 183, 206, 15);

  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    onPrimary: Colors.white,
    seedColor: _baseColor,

    brightness: Brightness.light,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: _baseColor,
    brightness: Brightness.dark,
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFFF8F8FF),
    appBarTheme: _appBarTheme(_lightColorScheme),
    textTheme: _textTheme(Colors.black),
    primaryTextTheme: _textTheme(Colors.white),
    elevatedButtonTheme: _elevatedButtonTheme(_lightColorScheme),
    textButtonTheme: _textButtonTheme(_lightColorScheme),
    outlinedButtonTheme: _outlinedButtonTheme(_lightColorScheme),
    cardTheme: _cardTheme(_lightColorScheme),
    datePickerTheme: _datePickerTheme(_lightColorScheme),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: _darkColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: _appBarTheme(_darkColorScheme),
    textTheme: _textTheme(Colors.white),
    primaryTextTheme: _textTheme(Colors.white),
    elevatedButtonTheme: _elevatedButtonTheme(_darkColorScheme),
    textButtonTheme: _textButtonTheme(_darkColorScheme),
    outlinedButtonTheme: _outlinedButtonTheme(_darkColorScheme),
    cardTheme: _cardTheme(_darkColorScheme),
    datePickerTheme: _datePickerTheme(_darkColorScheme),
  );

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 4,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
    );
  }

  static TextTheme _textTheme(Color defaultColor) {
    return TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: defaultColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: defaultColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: defaultColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: defaultColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: defaultColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: defaultColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: defaultColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: defaultColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 1.5),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // margin: const EdgeInsets.all(8),
    );
  }

  static DatePickerThemeData _datePickerTheme(ColorScheme colorScheme) {
    return DatePickerThemeData(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.primary,
      headerForegroundColor: colorScheme.onPrimary,
      rangeSelectionBackgroundColor: colorScheme.primary.withValues(alpha: 0.2),
      rangeSelectionOverlayColor: WidgetStateProperty.resolveWith((states) {
        // Bisa pakai hover, pressed, focused, dsb kalau mau
        return colorScheme.primary.withValues(alpha: 0.1);
      }),
      dayForegroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      dayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateColor.resolveWith((states) {
        return colorScheme.primary;
      }),
      todayBackgroundColor: WidgetStateColor.resolveWith((states) {
        return colorScheme.primary.withValues(alpha: 0.15);
      }),
    );
  }
}
