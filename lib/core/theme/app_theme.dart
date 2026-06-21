import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFFE8330A);
  static const accent = Color(0xFFFF6B35);
  static const accentLight = Color(0xFFFF8C5A);

  // Dark Theme
  static const darkBackground = Color(0xFF0F0F1A);
  static const darkCard = Color(0xFF1A1A2E);
  static const darkSurface = Color(0xFF242438);
  static const darkBorder = Color(0xFF2E2E4A);
  static const darkDivider = Color(0xFF1E1E32);

  // Light Theme
  static const lightBackground = Color(0xFFF5F5FA);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF0F0F8);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0CC);
  static const textMuted = Color(0xFF6B6B8A);
  static const textDark = Color(0xFF1A1A2E);

  // Status
  static const success = Color(0xFF00C853);
  static const warning = Color(0xFFFFD600);
  static const error = Color(0xFFFF1744);
  static const info = Color(0xFF2979FF);

  // Timer
  static const timerWork = Color(0xFF00C853);
  static const timerRest = Color(0xFFFF1744);

  // Chart
  static const chartLine = Color(0xFFE8330A);
  static const chartFill = Color(0x33E8330A);
  static const chartGrid = Color(0xFF2E2E4A);

  // Muscle Group Colors
  static const chest = Color(0xFFE8330A);
  static const back = Color(0xFF2979FF);
  static const legs = Color(0xFF00C853);
  static const shoulders = Color(0xFFFFD600);
  static const arms = Color(0xFFFF6B35);
  static const core = Color(0xFF7B1FA2);
  static const cardio = Color(0xFF00BCD4);
}

class AppTheme {
  static ThemeData get dark => _buildTheme(isDark: true);
  static ThemeData get light => _buildTheme(isDark: false);

  static ThemeData _buildTheme({required bool isDark}) {
    final colorScheme = isDark ? _darkColorScheme : _lightColorScheme;
    final textTheme = _buildTextTheme(isDark: isDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      cardColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      dividerColor: isDark ? AppColors.darkDivider : Colors.grey.shade200,
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor:
            isDark ? AppColors.textPrimary : AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.rajdhani(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textPrimary : AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.textMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textMuted,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.rajdhani(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.rajdhani(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        selectedColor: AppColors.primary.withOpacity(0.2),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primary, width: 2.5),
          ),
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: GoogleFonts.rajdhani(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: GoogleFonts.rajdhani(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.darkSurface,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        thumbColor: AppColors.primary,
        inactiveTrackColor: AppColors.darkBorder,
        overlayColor: AppColors.primary.withOpacity(0.1),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.4);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.grey.shade900,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ColorScheme get _darkColorScheme => const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        surface: AppColors.darkBackground,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      );

  static ColorScheme get _lightColorScheme => ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        surface: AppColors.lightCard,
        onSurface: AppColors.textDark,
        error: AppColors.error,
        onError: Colors.white,
        outline: Colors.grey.shade300,
      );

  static TextTheme _buildTextTheme({required bool isDark}) {
    final baseColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final secondaryColor = isDark ? AppColors.textSecondary : Colors.grey.shade600;

    return TextTheme(
      // Display — Rajdhani
      displayLarge: GoogleFonts.rajdhani(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.rajdhani(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.rajdhani(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      // Headline — Rajdhani
      headlineLarge: GoogleFonts.rajdhani(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: 0.3,
      ),
      headlineMedium: GoogleFonts.rajdhani(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: 0.2,
      ),
      headlineSmall: GoogleFonts.rajdhani(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.2,
      ),
      // Title — Rajdhani
      titleLarge: GoogleFonts.rajdhani(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: 0.5,
      ),
      titleMedium: GoogleFonts.rajdhani(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.4,
      ),
      titleSmall: GoogleFonts.rajdhani(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.4,
      ),
      // Body — Inter
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      // Label — Inter
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }
}

// Gradient utilities
class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkCardGradient = LinearGradient(
    colors: [AppColors.darkCard, AppColors.darkSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0x00000000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static LinearGradient muscleGradient(Color color) => LinearGradient(
        colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

// Box decorations
class AppDecorations {
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      );

  static BoxDecoration get glassCard => BoxDecoration(
        color: AppColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get primaryCard => BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
}
