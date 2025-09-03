// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';
import 'package:grocery_flutter_app/utils/themes/grocery_color_theme.dart';


class GroceryTextTheme {
  GroceryTextTheme._internal({this.fontFamily = "BalooDa2"})
    : _baseTextStyle = TextStyle(
        // fontFamily: fontFamily,
        fontWeight: FoxFontWeight.regular,
        letterSpacing: -0.8,
        height: 1.2,
        color: GroceryColorTheme().black
      );

  static final GroceryTextTheme _instance = GroceryTextTheme._internal();

  factory GroceryTextTheme() {
    return _instance;
  }

  final String fontFamily;
  final TextStyle _baseTextStyle;

  TextStyle get headingText =>
      _baseTextStyle.copyWith(fontSize: 32, fontWeight: FoxFontWeight.semiBold);
  TextStyle get boldText =>
      _baseTextStyle.copyWith(fontSize: 20, fontWeight: FoxFontWeight.bold);

  TextStyle get   bodyText =>
      _baseTextStyle.copyWith(fontSize: 16, fontWeight: FoxFontWeight.medium);

  TextStyle get lightText =>
      _baseTextStyle.copyWith(fontSize: 14, fontWeight: FoxFontWeight.regular);

  

  
}
