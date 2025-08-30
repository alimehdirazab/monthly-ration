part of 'generics.dart';



extension NavigationExtension on BuildContext {
  void pushPage(Widget page, {Function()? then}) {
    Navigator.of(this).push(MaterialPageRoute(builder: (context) => page)).then(
      (_) {
        if (then != null) {
          then();
        }
      },
    );
  }

  void pushReplacementPage(Widget page, {Function()? then}) {
    Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (context) => page)).then((_) {
      if (then != null) {
        then();
      }
    });
  }

  void pushAndRemoveUntilPage(Widget page, {Function()? then}) {
    Navigator.of(this)
        .pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    )
        .then((_) {
      if (then != null) {
        then();
      }
    });
  }

  void popUntilPage() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  void popPage() {
    Navigator.of(this).pop();
  }
}

extension FoxFontWeight on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

extension SnackbarExtension on BuildContext {
  void showSnacbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    final bgColor = backgroundColor ?? GroceryColorTheme().primary;
    final txtStyle = textStyle ??
        GroceryTextTheme().lightText.copyWith(color: GroceryColorTheme().white);

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          content: Text(message, style: txtStyle),
          duration: duration,
        ),
      );
  }
}

extension MediaQueryValues on BuildContext {
  double get mWidth => MediaQuery.of(this).size.width;
  double get mHeight => MediaQuery.of(this).size.height;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String timeAgo() {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(this).toLocal();
    Duration diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else {
      return '${(diff.inDays / 365).floor()}y ago';
    }
  }
}

extension BuildContextUtils on BuildContext {
  bool get isDarkTheme {
    return watch<AppCubit>().state.isDarkTheme;
  }

  bool get isMeters {
    return watch<AppCubit>().state.isMeters;
  }

  bool get showOnboarding {
    return watch<AppCubit>().state.showOnboarding;
  }

  bool get isAuthenticated {
    return watch<AppCubit>().state.isAuthenticated;
  }

  Locale get locale {
    return watch<AppCubit>().state.locale;
  }

  Color get shimmerBaseColor {
    return GroceryColorTheme().lightShimmerBaseColor;
  }

  Color get shimmerHighlightColor {
    return GroceryColorTheme().lightShimmerHighlightColor;
  }

  Color get monochromeColor {
    return isDarkTheme ? GroceryColorTheme().white : GroceryColorTheme().black;
  }
}
