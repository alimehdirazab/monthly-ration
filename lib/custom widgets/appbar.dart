part of 'widgets.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar(
      {super.key,
      required this.text,
      this.haveActionButton = false,
      this.actionButtonWidget,
      this.showBackButton = false,
      this.toolBarHeight = 107,
      this.containerHeight = 107});
  final String text;
  final bool haveActionButton;
  final Widget? actionButtonWidget;
  final bool showBackButton;
  final int toolBarHeight;
  final int containerHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(color: Colors.transparent),

        // Blurred AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(0), // Ensure all corners are rounded
              topRight: Radius.circular(0),
            ),
            child: Container(
              height: containerHeight.toDouble(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    GroceryColorTheme().primary.withValues(alpha: 0.3),
                    GroceryColorTheme().primary.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: AppBar(
                leadingWidth: 20,
                automaticallyImplyLeading: false,
                toolbarHeight: toolBarHeight.toDouble(),
                scrolledUnderElevation: 0,
                leading: showBackButton
                    ? InkWell(
                        onTap: () => context.popPage(),
                        child: Icon(GroceryIcons().backButton, size: 22),
                      )
                    : SizedBox(),
                title: Text(
                  text,
                  style: GroceryTextTheme().headingText.copyWith(fontSize: 16),
                ),
                backgroundColor: Colors.transparent,
                actions: [
                  haveActionButton ? actionButtonWidget! : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    
  }
}
