import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:flutter/material.dart';


class CElevatedButtonTheme{
  CElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: cWhiteColor,
      foregroundColor: cSecondaryColor,
      side: BorderSide(color: cSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: cButtonHeight),
    ),
  );

  
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
     style: OutlinedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: cWhiteColor ,
      foregroundColor: cSecondaryColor,
      side: BorderSide(color: cSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: cButtonHeight),
    ),
  );

}