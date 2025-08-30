// ignore_for_file: public_member_api_docs, sort_constructors_first
//Custom Auth Button
part of 'widgets.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color backgrondColor;
  final bool showBorder;
  final double? borderWidth;
  final double width;
  final Color borderColor;
  final void Function() onPressed;
  final Widget buttonText;
  final double height;

  const CustomElevatedButton({
    super.key,
    required this.backgrondColor,
    this.showBorder = false,
    required this.width,
    required this.onPressed,
    required this.buttonText,
    this.borderColor = Colors.white,
    this.height = 48,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          shadowColor: WidgetStatePropertyAll(
            GroceryColorTheme().transparentColor,
          ),
          backgroundColor: WidgetStatePropertyAll(backgrondColor),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),

          side: WidgetStatePropertyAll(
            showBorder
                ? BorderSide(color: borderColor, width: borderWidth ?? 1)
                : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: buttonText,
      ),
    );
  }
}
