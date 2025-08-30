part of 'view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryTabs(),
            Divider(
              color: GroceryColorTheme().black.withValues(alpha: 0.2),
              endIndent: 10,
              indent: 10,
            ),
            const SizedBox(height: 16),
            _buildBanner(),
            const SizedBox(height: 24),
            _buildSectionTitle('Grocery & Kitchen'),
            _buildProductGrid(_groceryKitchenItems),
            const SizedBox(height: 24),
            _buildSectionTitle('Snacks & Drinks'),
            _buildProductGrid(_snacksDrinksItems),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.cartItems.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                // Navigate to cart or perform action
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber, // Yellow background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        GroceryImages.category2, // Replace with your image
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'View cart',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${state.cartItems.length} item${state.cartItems.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Arrow Icon
                    InkWell(
                      onTap: () {
                        context.pushPage(CheckoutPage());
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GroceryColorTheme().white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            //  FloatingActionButton.extended(
            //   onPressed: () {
            //     // Navigate to cart screen or show cart details
            //   },
            //   label: Text('View Cart (${state.cartItems.length})'),
            //   icon: const Icon(Icons.shopping_cart),
            // );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // --- Widgets for different sections of the screen ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,

      backgroundColor: GroceryColorTheme().primary,
      automaticallyImplyLeading: false, // Adjust height as needed
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '15 minutes',
                    style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Block D, Noida Sector 3, Meerut Division',
                    style: GroceryTextTheme().lightText,
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GroceryColorTheme().white,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GroceryColorTheme().white,
                ),
                child: Icon(Icons.account_circle_outlined, color: Colors.black),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SizedBox(height: 25), // _buildSearchBar(),
          SearchField(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final List<String> categories = [
      'All',
      'Electronic',
      'Beauty',
      'Decor',
      'Kids',
      'Fashion',
      'Sports',
    ]; // Example categories

    final List<IconData> categoryIcons = [
      Icons.apps,
      Icons.electrical_services,
      Icons.brush,
      Icons.palette,
      Icons.child_care,
      Icons.shopping_bag,
      Icons.sports_baseball,
    ]; // Example icons

    return SizedBox(
      height: 70, // Height for category row
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final bool isSelected = index == 0; // 'All' is selected in screenshot
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(
                    categoryIcons[index],
                    color:
                        isSelected
                            ? GroceryColorTheme().black
                            : GroceryColorTheme().black.withValues(alpha: 0.2),
                    size: 30,
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isSelected
                            ? GroceryColorTheme().black
                            : GroceryColorTheme().black.withValues(alpha: 0.2),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 150,
        width: double.infinity, // Adjust banner height
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: Colors.blue[700], // Placeholder background
          // image: DecorationImage(
          //   image: AssetImage(
          //     GroceryImages.banner,
          //   ), // Replace with your banner image
          //   fit: BoxFit.fill,

          // ),
        ),

        child: Image.asset(
          GroceryImages.banner,
          height: double.infinity,
          width: double.infinity,
          // Replace with your banner image
          fit: BoxFit.cover,
        ),
        // You can add Text/Icons over the image if they are separate elements
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  final List<Map<String, String>> _groceryKitchenItems = [
    {'image': GroceryImages.grocery1, 'name': 'Vegetables & Fruits'},
    {'image': GroceryImages.grocery2, 'name': 'Atta Rice & Dal'},
    {'image': GroceryImages.grocery3, 'name': 'Oil Ghee & Masala'},
    {'image': GroceryImages.grocery4, 'name': 'Dairy Eggs & Bread'},
    {'image': GroceryImages.grocery5, 'name': 'Bakery & Biscuits'},
    {'image': GroceryImages.grocery6, 'name': 'Dry Fruits & Cereals'},
    {'image': GroceryImages.grocery7, 'name': 'Chicken Meat & Fish'},
    {'image': GroceryImages.grocery8, 'name': 'Kitchenware & Appliances'},
  ];

  final List<Map<String, String>> _snacksDrinksItems = [
    {'image': GroceryImages.grocery1, 'name': 'Chips & Namkoon'},
    {'image': GroceryImages.grocery2, 'name': 'Sweets & Chocolates'},
    {'image': GroceryImages.grocery3, 'name': 'Drinks & Juices'},
    {'image': GroceryImages.grocery4, 'name': 'Tea Coffee & Milkshakes'},
    {'image': GroceryImages.grocery5, 'name': 'Instant Food & Maggi'},
    {'image': GroceryImages.grocery6, 'name': 'Sauces & Nutella'},
    {'image': GroceryImages.grocery7, 'name': 'Pan Corner & Vape'},
    {'image': GroceryImages.grocery8, 'name': 'Ice creams & Falooda'},
  ];

  Widget _buildProductGrid(List<Map<String, String>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        shrinkWrap: true, // Important for nested scrolling
        physics:
            const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 items per row as per screenshot
          crossAxisSpacing: 0, // No horizontal spacing between items
          mainAxisSpacing: 0, // No vertical spacing between items
          childAspectRatio: 0.56, // Adjust as needed to fit content
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.pushPage(
                ProductDetailPage(homeCubit: context.read<HomeCubit>()),
              );
            },
            child: ItemContainer(
              imageUrl: items[index]['image']!,
              itemName: items[index]['name']!,
            ),
          );
        },
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final String imageUrl;
  final String itemName;

  const ItemContainer({
    super.key,
    required this.imageUrl,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130,

          // Fixed width based on the screenshot
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: GroceryColorTheme().primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Image.asset(
            imageUrl,
            width: 70, // Adjust image size as needed
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          itemName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
