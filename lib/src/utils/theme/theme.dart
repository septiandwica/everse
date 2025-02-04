import 'package:compuvers/src/utils/theme/widget_theme/elevated_btn_theme.dart';
import 'package:compuvers/src/utils/theme/widget_theme/outlined_btn_theme.dart';
import 'package:compuvers/src/utils/theme/widget_theme/text_theme.dart';
import 'package:flutter/material.dart';

class CAppTheme{
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: CTextTheme.lightTextTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: CTextTheme.darkTextTheme,
    outlinedButtonTheme: COutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
  );
  
}