part of 'widgets.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        labelText: "Search here....",
        filled: true,
        fillColor: GroceryColorTheme().white,
        labelStyle: GroceryTextTheme().lightText.copyWith(
          color: GroceryColorTheme().black.withValues(alpha: 0.3),
          fontSize: 16,
        ),
        suffixIcon: SizedBox(
          width: 50,
          height: 49,

          child: Row(
            children: [
              Container(
                height: 20,
                width: 1,
                color: GroceryColorTheme().black.withValues(alpha: 0.3),
              ),
              SizedBox(width: 10),
              Icon(
                GroceryIcons().search,
                size: 23,
                color: GroceryColorTheme().black.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: GroceryColorTheme().black.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: GroceryColorTheme().black.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.black), // Highlight when focused
        ),
      ),
    );
  }
}
