import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand — deeper, richer orange
  static const primary = Color(0xFFFF4D1A);
  static const primaryDark = Color(0xFFCC3300);
  static const accent = Color(0xFFFF7A45);
  static const accentLight = Color(0xFFFFAA80);

  // Deep dark palette — true depth layering
  static const darkBackground = Color(0xFF080B14);
  static const darkCard = Color(0xFF0E1422);
  static const darkSurface = Color(0xFF141A2E);
  static const darkElevated = Color(0xFF1A2138);
  static const darkBorder = Color(0xFF1E2640);
  static const darkBorderBright = Color(0xFF2A3560);
  static const darkDivider = Color(0xFF111828);

  // Light Theme
  static const lightBackground = Color(0xFFF2F4F8);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFEEF0F7);

  // Text
  static const textPrimary = Color(0xFFF0F4FF);
  static const textSecondary = Color(0xFF8898BB);
  static const textMuted = Color(0xFF4A5578);
  static const textDark = Color(0xFF0E1422);

  // Status
  static const success = Color(0xFF00E676);
  static const successDim = Color(0xFF00C853);
  static const warning = Color(0xFFFFAB40);
  static const warningDim = Color(0xFFFF8F00);
  static const error = Color(0xFFFF3D71);
  static const info = Color(0xFF4D8FFF);
  static const infoDim = Color(0xFF2979FF);

  // Timer
  static const timerWork = Color(0xFF00E676);
  static const timerRest = Color(0xFFFF3D71);

  // Chart
  static const chartLine = Color(0xFFFF4D1A);
  static const chartFill = Color(0x33FF4D1A);
  static const chartGrid = Color(0xFF1A2138);

  // Muscle Group Colors
  static const chest = Color(0xFFFF4D1A);
  static const back = Color(0xFF4D8FFF);
  static const legs = Color(0xFF00E676);
  static const shoulders = Color(0xFFFFAB40);
  static const arms = Color(0xFFFF7A45);
  static const core = Color(0xFFAB47BC);
  static const cardio = Color(0xFF00E5FF);

  // Glass / overlay
  static const glassWhite = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);
  static const glassHighlight = Color(0x08FFFFFF);
}

// ─────────────────────────────────────────
// SHADOWS
// ─────────────────────────────────────────
class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> glow(Color color, {double intensity = 0.35}) => [
        BoxShadow(
          color: color.withValues(alpha: intensity),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: color.withValues(alpha: intensity * 0.5),
          blurRadius: 48,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
      ];

  static List<BoxShadow> get navBar => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 32,
          offset: const Offset(0, -8),
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 48,
          offset: const Offset(0, -4),
        ),
      ];
}

// ─────────────────────────────────────────
// GRADIENTS
// ─────────────────────────────────────────
class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF4D1A), Color(0xFFFF2D55)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primarySoft = LinearGradient(
    colors: [Color(0xFFFF4D1A), Color(0xFFFF7A45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundMesh = LinearGradient(
    colors: [Color(0xFF080B14), Color(0xFF0A0F1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const heroOverlay = LinearGradient(
    colors: [Color(0x00080B14), Color(0xFF080B14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.4, 1.0],
  );

  static const cardSheen = LinearGradient(
    colors: [Color(0x12FFFFFF), Color(0x00FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get timerWork => const LinearGradient(
        colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get timerRest => const LinearGradient(
        colors: [Color(0xFFFF3D71), Color(0xFFFF4D1A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient muscleGradient(Color color) => LinearGradient(
        colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static const darkCardGradient = LinearGradient(
    colors: [Color(0xFF0E1422), Color(0xFF141A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─────────────────────────────────────────
// DECORATIONS
// ─────────────────────────────────────────
class AppDecorations {
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder, width: 1),
        boxShadow: AppShadows.card,
      );

  static BoxDecoration get surfaceCard => BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      );

  static BoxDecoration get glassCard => BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: AppShadows.elevated,
      );

  static BoxDecoration get primaryCard => BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.glow(AppColors.primary),
      );

  static BoxDecoration glowCard(Color color) => BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      );

  static BoxDecoration sheenCard({
    Color? color,
    double radius = 20,
  }) =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (color ?? AppColors.darkCard).withValues(alpha: 1.0),
            AppColors.darkSurface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.darkBorder, width: 1),
        boxShadow: AppShadows.card,
      );
}

// ─────────────────────────────────────────
// THEME
// ─────────────────────────────────────────
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
        backgroundColor: Colors.transparent,
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
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
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
          borderRadius: BorderRadius.circular(20),
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
            borderRadius: BorderRadius.circular(14),
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
            borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
        labelStyle:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: BoxDecoration(
          gradient: AppGradients.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
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
        overlayColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.4);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkElevated : Colors.grey.shade900,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final baseColor =
        isDark ? AppColors.textPrimary : AppColors.textDark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : Colors.grey.shade600;

    return TextTheme(
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
