part of 'widgets.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    this.isChecked = false,
    this.onChanged,
    required this.title,
    this.hasPrice = false,
    this.price = '0.0',
  });

  final bool isChecked;
  final String title;
  final bool hasPrice;
  final String price;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isChecked);
        }
      },
      child: ListTile(
        minTileHeight: 0,
        title: Text(title,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isChecked
                ? GroceryTextTheme().bodyText.copyWith(fontSize: 14)
                : GroceryTextTheme().lightText),
        leading: Container(
          height: 18,
          width: 18,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isChecked
                  ? GroceryColorTheme().primary
                  : GroceryColorTheme().lightGreyColor,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isChecked ? GroceryColorTheme().primary : GroceryColorTheme().white,
            ),
            height: 14,
            width: 14,
          ),
        ),
        trailing: hasPrice
            ? Text(
                '\$$price',
                style: GroceryTextTheme().lightText.copyWith(
                      fontSize: 12,
                      color: GroceryColorTheme().black,
                    ),
              )
            : null,
      ),
    );
  }
}
