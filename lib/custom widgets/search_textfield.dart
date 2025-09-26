part of 'widgets.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          hintText: "Search here....",
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
              color: GroceryColorTheme().black.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: GroceryColorTheme().black.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.3)), // Highlight when focused
          ),
        ),
      ),
    );
  }
}
