import 'package:flutter/material.dart';

abstract final class SignCobColors {
  static const navy = Color(0xFF0B1630);
  static const surface = Color(0xFF14294A);
  static const graphite = Color(0xFF111318);
  static const gold = Color(0xFFC6A15B);
  static const neon = Color(0xFF19C8FF);
  static const white = Color(0xFFF5F6F8);
  static const silver = Color(0xFFAAB3C2);
}

abstract final class SignCobTheme {
  static ThemeData get dark {
    const colors = ColorScheme.dark(
      primary: SignCobColors.gold,
      onPrimary: SignCobColors.graphite,
      secondary: SignCobColors.neon,
      onSecondary: SignCobColors.navy,
      surface: SignCobColors.surface,
      onSurface: SignCobColors.white,
      onSurfaceVariant: SignCobColors.silver,
      outline: SignCobColors.silver,
      outlineVariant: Color(0xFF344765),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
    );
    final base = ThemeData(useMaterial3: true, colorScheme: colors);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    return base.copyWith(
      scaffoldBackgroundColor: SignCobColors.navy,
      textTheme: base.textTheme.apply(
        bodyColor: SignCobColors.white,
        displayColor: SignCobColors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: SignCobColors.neon,
        selectionColor: SignCobColors.neon.withValues(alpha: .24),
        selectionHandleColor: SignCobColors.neon,
      ),
      focusColor: SignCobColors.neon.withValues(alpha: .16),
      hoverColor: SignCobColors.gold.withValues(alpha: .08),
      appBarTheme: const AppBarTheme(
        backgroundColor: SignCobColors.navy,
        foregroundColor: SignCobColors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: SignCobColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: SignCobColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF344765)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SignCobColors.navy,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        labelStyle: const TextStyle(color: SignCobColors.silver),
        hintStyle: const TextStyle(color: SignCobColors.silver),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60718C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SignCobColors.neon, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 50),
          backgroundColor: SignCobColors.gold,
          foregroundColor: SignCobColors.graphite,
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 50),
          backgroundColor: SignCobColors.gold,
          foregroundColor: SignCobColors.graphite,
          shape: shape,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: SignCobColors.white,
          side: const BorderSide(color: SignCobColors.silver),
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: SignCobColors.gold,
        ),
      ),
      iconTheme: const IconThemeData(color: SignCobColors.gold),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF344765),
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: SignCobColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: SignCobColors.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: const TextStyle(color: SignCobColors.white),
        shape: shape,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: SignCobColors.white),
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(SignCobColors.surface),
          shape: WidgetStatePropertyAll(shape),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: SignCobColors.surface,
        modalBackgroundColor: SignCobColors.surface,
        showDragHandle: true,
        dragHandleColor: SignCobColors.silver,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: SignCobColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: SignCobColors.graphite),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SignCobColors.navy,
        selectedColor: SignCobColors.neon.withValues(alpha: .14),
        checkmarkColor: SignCobColors.neon,
        labelStyle: const TextStyle(color: SignCobColors.white),
        side: const BorderSide(color: Color(0xFF344765)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: SignCobColors.surface,
        headerBackgroundColor: SignCobColors.navy,
        headerForegroundColor: SignCobColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: SignCobColors.graphite,
        contentTextStyle: TextStyle(color: SignCobColors.white),
        actionTextColor: SignCobColors.gold,
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SignCobColors.neon,
        linearTrackColor: SignCobColors.surface,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? SignCobColors.neon : null,
        ),
        checkColor: const WidgetStatePropertyAll(SignCobColors.navy),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: SignCobColors.gold,
        textColor: SignCobColors.white,
        selectedColor: SignCobColors.neon,
        selectedTileColor: SignCobColors.navy,
      ),
      dataTableTheme: const DataTableThemeData(
        headingTextStyle: TextStyle(
          color: SignCobColors.gold,
          fontWeight: FontWeight.w700,
        ),
        dataTextStyle: TextStyle(color: SignCobColors.white),
      ),
    );
  }
}
