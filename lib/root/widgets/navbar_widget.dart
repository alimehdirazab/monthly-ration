// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'widgets.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTapHome,
    required this.onTapCategory,
    required this.onTapOrder,
    required this.onTapAccount,
  });

  final int currentIndex;
  final VoidCallback onTapHome;
  final VoidCallback onTapCategory;
  final VoidCallback onTapOrder;
  final VoidCallback onTapAccount;

  @override
  Widget build(BuildContext context) {
    return
    // Scaffold(
    //   bottomNavigationBar:
    Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
            color: GroceryColorTheme().greyColor,
          ),
        ],
        // borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        child: BottomAppBar(
          notchMargin: 5.0,
          height: 80,
          color: GroceryColorTheme().white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _CustomNavbarIcons(
                icon: GroceryIcons().homeIcon,
                label: 'Home',
                onTap: () {
                  onTapHome();
                },
                isSelected: 0 == currentIndex,
              ),
              _CustomNavbarIcons(
                icon: GroceryIcons().category,
                label: 'Category',
                onTap: () {
                  onTapCategory();
                },
                isSelected: 1 == currentIndex,
              ),
              _CustomNavbarIcons(
                icon: GroceryIcons().orders,
                label: 'Order Again',
                isSelected: 2 == currentIndex,
                onTap: () {
                  onTapOrder();
                },
              ),
              _CustomNavbarIcons(
                isSelected: 3 == currentIndex,
                icon: GroceryIcons().account,
                label: 'Account',
                onTap: () {
                  onTapAccount();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomNavbarIcons extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CustomNavbarIcons({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Icon(
            icon,
            size: 22,
            color:
                isSelected
                    ? GroceryColorTheme().primary
                    : GroceryColorTheme().black,
          ),
          Text(
            label,
            style: GroceryTextTheme().lightText.copyWith(
              overflow: TextOverflow.ellipsis,
              color:
                  isSelected
                      ? GroceryColorTheme().primary
                      : GroceryColorTheme().black,
            ),
          ),
        ],
      ),
    );
  }
}


    // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    // floatingActionButton: Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Container(
    //           padding: EdgeInsets.all(5),
    //           height:
    //               //  90,
    //               context.mHeight * 0.2,
    //           width: 90,
    //           // context.mWidth * 0.25,
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: GroceryColorTheme().fabOutlinerColor,
    //           ),
    //           child: FloatingActionButton.large(
    //             onPressed: () {},
    //             shape: CircleBorder(),
    //             backgroundColor: GroceryColorTheme().primary,
    //             child: ClipOval(
    //               // Ensures the image fits within the circular FAB
    //               child: Image.asset(
    //                 FoxImages.shipLogo, // Replace with your asset path
    //                 fit:
    //                     BoxFit
    //                         .cover, // Ensures the image covers the area properly
    //                 width: 46, // Adjust to fit within FAB
    //                 height: 46,
    //               ),
    //             ),
    //           ),
    //         ),
    //         // SizedBox(height: 4), // Space between FAB and label
    //         // Text("Find Boat", style: GroceryTextTheme().lightText),
    //         Transform.translate(
    //           offset: Offset(0, -8.9), // Moves text 10px up
    //           child: Text("Find Boat", style: GroceryTextTheme().lightText),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),