import 'package:flutter/material.dart';
import 'package:grocery_flutter_app/utils/themes/grocery_color_theme.dart';
import 'package:grocery_flutter_app/utils/themes/grocery_text_theme.dart';

class FoxTheme {
  ThemeData get lightThemeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // fontFamily: GroceryTextTheme().fontFamily,
    inputDecorationTheme: inputDecorationThemeData,
    scaffoldBackgroundColor: Colors.white,
    dividerTheme: lightDividerTheme,
    iconTheme: iconThemeData,
    elevatedButtonTheme: elevatedButtonThemeData,
  );

  ThemeData get darkThemeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    dividerTheme: darkDividerTheme,

    fontFamily: GroceryTextTheme().fontFamily,
    inputDecorationTheme: inputDecorationThemeData,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: iconThemeData,

    elevatedButtonTheme: elevatedButtonThemeData,
  );

  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          // backgroundColor: WidgetStatePropertyAll(GroceryColorTheme().primary),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
        ),
      );

  InputDecorationTheme get inputDecorationThemeData => InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: GroceryColorTheme().lightGreyColor),
    ),
    hintStyle: GroceryTextTheme().lightText.copyWith(
      color: GroceryColorTheme().lightGreyColor,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: GroceryColorTheme().black, width: 2),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: GroceryColorTheme().black.withValues(alpha: 0.1),
      ),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
  );

  IconThemeData get iconThemeData =>
      IconThemeData(color: GroceryColorTheme().primary, size: 12);

  DividerThemeData get lightDividerTheme => DividerThemeData(
    color: GroceryColorTheme().lightGreyColor,
    indent: 5,
    thickness: 1,
  );

  DividerThemeData get darkDividerTheme => DividerThemeData(
    color: GroceryColorTheme().lightGreyColor,
    indent: 5,
    thickness: 1,
  );

  ChipThemeData get chipThemeData => ChipThemeData(
    backgroundColor: GroceryColorTheme().transparentColor,
    selectedColor: GroceryColorTheme().primary,
    secondarySelectedColor: GroceryColorTheme().primary,
    // disabledColor: GroceryColorTheme().lightGreyColor,
    selectedShadowColor: GroceryColorTheme().primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
      side: BorderSide.none,
    ),
  );
}
