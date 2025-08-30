import 'package:flutter/material.dart';

class GroceryColorTheme {
  //Private constructor
  GroceryColorTheme._internal();

  //Single instance of the class
  static final GroceryColorTheme _instance = GroceryColorTheme._internal();

  //Factory constructor to return same instance
  factory GroceryColorTheme() {
    return _instance;
  }
  //Color definitions
  Color get black => const Color(0xFF000000);
  Color get white => const Color(0xFFffffff);
  Color get lightBackgroundColor => Color(0xFFF0F0F0);
  Color get primary => const Color(0xFFFECC00);
  Color get lightPeachColor => const Color(0xFFFECC00);

  Color get secondary => const Color(0xFF1F1F1F);
  Color get borderColor => Colors.black26;
  Color get lightGreyColor => Color(0xff98A2B3);
  Color get lightGreyColor2 => Color(0xff8D8D8D);
  Color get transparentColor => Colors.transparent;
  Color get greyColor => Color(0xFFDADADA);
  Color get darkGreyColor => Color(0xFF707070);
  Color get greyShade1 => Color(0xFFF6F6F6);
  Color get fabOutlinerColor => Color(0xFFDFF3FF);
  Color get statusBlueColor => Color(0xFF00D0E2);
  Color get brandBlueColor => Color(0xFFEBF3FF);
  Color get lightPinkColor => Color(0xFFE75480);
  Color get statusPinkColor => Color(0xFFFFC9C9);
  Color get lightPinkShade => Color(0xFFE884A1);
  Color get darkPinkShade => Color(0xFFE56188);
  Color get pinkColor => Color(0xFFEB779E);
  Color get progressbarGreyColor => Color(0xFFD9D9D9);
  Color get progressbarGradiantColor1 => Color(0xFF4095B9);
  Color get progressbarGradiantColor2 => Color(0xFF84CDD6);
  Color get counterbgColor => Color(0xFFEAEAEA);
  Color get lightBlueColor => Color(0xFFDFF3FF);
  Color get greenColor => Color(0xFF16A91C);
  Color get lightShimmerBaseColor => Colors.grey[300]!;
  Color get lightShimmerHighlightColor => Colors.grey[100]!;
  Color get chipBackgroundColor => Color(0xFFF8F8F8);

  // Color get goldenColor => Color(0xFFEFB906);
  Color get gradient1 => Color(0xFF72CCFF);
  Color get gradient2 => Color(0xFF3A9AD0);
  Color get gradient3 => Color(0xFFB9B9B9);
  Color get gradient4 => Color(0xFF363636);
  Color get greyColor54 => Color(0xFF545454);
  Color get lightGreenColor => Color(0xFFBCFFBF);
  Color get offWhiteColor => Color(0xFFFBFBFB);
  Color get starBorderGrey => Color(0xFF797979);
  Color get optionalGrey => Color(0xFFC0C0C0);
  Color get skipGreyColor => Color(0xFFF1F1F1);
  Color get weatherBlueColor => Color(0xFFEFFAFF);
  Color get weatherLeadingBgColor => Color(0xFF9AB6FF);
  Color get redColor => Color(0xFFFF3B30);
  Color get lightRedColor => Color(0xFFFFADAD);
  Color get switchBgColor => Color(0xFFE4E4E4);
  Color get switchInActiveColor => Color(0xFF8D8D8D);
  Color get walletGradiant1 => Color(0xFF447A99);
  Color get walletGradiant2 => Color(0xFF72CCFF);
  Color get refundColor => Color(0xFF007BC0);
  Color get orderaColor => Color(0xFFDD0000);
}
