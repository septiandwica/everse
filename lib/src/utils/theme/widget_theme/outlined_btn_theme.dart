import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:flutter/material.dart';

class COutlinedButtonTheme{
  COutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      foregroundColor: cSecondaryColor,
      side: BorderSide(color: cSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: cButtonHeight),
    ),
  );

  
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
     style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      foregroundColor: cWhiteColor,
      side: BorderSide(color: cWhiteColor),
      padding: EdgeInsets.symmetric(vertical: cButtonHeight),
    ),
  );
}