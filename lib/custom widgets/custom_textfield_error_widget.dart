part of 'widgets.dart';

class CustomTextfieldErrorWidget extends StatelessWidget {
  const CustomTextfieldErrorWidget({
    super.key,
    required this.title,
    this.padding,
    this.spacing,
  });

  final String? title;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Padding(
            padding: padding ?? const EdgeInsets.only(left: 0, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(GroceryIcons().errorIcon,
                    size: 16, color: GroceryColorTheme().redColor),
                SizedBox(width: spacing ?? 8),
                Flexible(
                  child: Text(title!,
                      style: GroceryTextTheme().lightText.copyWith(
                          color: GroceryColorTheme().redColor, fontSize: 14)),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
