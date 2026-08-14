import 'package:flutter/material.dart';

import 'colors.dart'; // Assuming the colors are imported from the file you provided

class AppStyle {
  static const String fontFamily = "Poppins";

  // -------------------- ThemeData --------------------
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColor.primary,
    primaryColorDark: AppColor.primary,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColor.surface,
    appBarTheme: AppBarTheme(
      color: AppColor.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.primary),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColor.primary,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: title.copyWith(color: AppColor.onPrimary),
      headlineMedium: subtitle.copyWith(color: AppColor.onPrimary),
      bodyLarge: body,
      bodyMedium: body.copyWith(color: AppColor.onBackground),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary)
        .copyWith(surface: AppColor.background),
    dividerColor: AppColor.border,
    indicatorColor: AppColor.primary,
  );

  // -------------------- Text Styles --------------------
  static TextStyle title = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.12,
  );

  static TextStyle subtitle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle body = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColor.background,
    letterSpacing: 1.25,
  );

  static TextStyle captionText = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0x80000000),
    letterSpacing: 0.12,
  );

  // -------------------- Shadows --------------------
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      spreadRadius: 0,
      blurRadius: 4,
    ),
  ];

  static final List<BoxShadow> mildCardShadow = [
    BoxShadow(
      color: AppColor.secondary.withOpacity(0.2),
      spreadRadius: 0.5,
      blurRadius: 1,
    ),
  ];

  // -------------------- Card Decorations --------------------
  static Decoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: cardShadow,
  );

  // -------------------- Dividers --------------------
  static const Widget customDivider = SizedBox(
    height: 0.6,
    child: Divider(
      color: AppColor.divider,
      thickness: 1.2,
    ),
  );

  // -------------------- Button Styles --------------------
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: AppColor.onPrimary, backgroundColor: AppColor.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  );

  // -------------------- Gradient Colors --------------------
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6), // Blue Start
    Color(0xFF9333EA), // Purple End
  ];

  static const List<Color> neutralGradient = [
    Color(0xFFF9FAFB), // Light Start
    Color(0xFFE5E7EB), // Light End
  ];

}
