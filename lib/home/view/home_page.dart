part of 'view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().clearCart();
    context.read<AuthCubit>().getAddress();
    context.read<HomeCubit>().getBanners();
    context.read<HomeCubit>().getDefaultCategories();
    context.read<HomeCubit>().getProducts();
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
            _buildSectionTitle('Products'),
            _buildProductGrid(),
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
    AppState appState = context.select((AppCubit cubit) => cubit.state);
    final address = appState.user.customer?.addressLine1 ?? "";
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
                    address,
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
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.defaultCategoriesApiState != current.defaultCategoriesApiState ||
          previous.selectedCategoryIndex != current.selectedCategoryIndex,
      builder: (context, state) {
        final apiState = state.defaultCategoriesApiState;
        final selectedCategoryIndex = state.selectedCategoryIndex;
        
        // Get categories from API or use empty list
        final apiCategories = apiState.model?.data ?? [];
        
        // Create final list with "All" first, then API categories
        final List<Category?> categories = [null, ...apiCategories]; // null represents "All"
        final List<String> categoryNames = ['All', ...apiCategories.map((cat) => cat.name)];

        if (apiState.apiCallState == APICallState.loading) {
          return SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (apiState.apiCallState == APICallState.failure) {
          log(apiState.errorMessage ?? 'Failed to load categories');
          return SizedBox(
            height: 70,
            child: Center(child: Text(apiState.errorMessage ?? 'Failed to load categories', style: TextStyle(color: Colors.red))),
          );
        }

        return SizedBox(
          height: 70, // Height for category row
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final bool isSelected = selectedCategoryIndex == index;
              final category = categories[index];
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                   onTap: () {
                        context.read<HomeCubit>().setSelectedCategoryIndex(index);
                        // Handle category selection logic here
                        // You can call API or filter products based on selected category
                        if (category != null) {
                          context.read<HomeCubit>().getProducts(categoryId: category.id);
                        } else {
                          context.read<HomeCubit>().getProducts();
                        }
                      },
                  child: Column(
                    children: [
                      category?.image != null && category!.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                category.image!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If image fails to load, show default icon
                                  return Icon(
                                    index == 0 ? Icons.apps : Icons.category,
                                    color: isSelected
                                        ? GroceryColorTheme().black
                                        : GroceryColorTheme().black.withValues(alpha: 0.2),
                                    size: 30,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              index == 0 ? Icons.apps : Icons.category,
                              color: isSelected
                                  ? GroceryColorTheme().black
                                  : GroceryColorTheme().black.withValues(alpha: 0.2),
                              size: 30,
                            ),
                      const SizedBox(height: 4),
                      Text(
                        categoryNames[index],
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.bannersApiState != current.bannersApiState,
      builder: (context, state) {
        final apiState = state.bannersApiState;
        if (apiState.apiCallState == APICallState.loading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 150,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (apiState.apiCallState == APICallState.failure) {
          log(apiState.errorMessage ?? 'Failed to load banners');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(apiState.errorMessage ?? 'Failed to load banners', style: TextStyle(color: Colors.red)),
            ),
          );
        }
        final banners = apiState.model?.data ?? [];
        if (banners.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 150,
              alignment: Alignment.center,
              child: Text('No banners available'),
            ),
          );
        }
        // Carousel slider for banners
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: PageView.builder(
              itemCount: banners.length,
              controller: PageController(viewportFraction: 0.92),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
          ),
        );
      },
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

  Widget _buildProductGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.productsApiState != current.productsApiState,
      builder: (context, state) {
        final apiState = state.productsApiState;
        
        if (apiState.apiCallState == APICallState.loading) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        
        if (apiState.apiCallState == APICallState.failure) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              apiState.errorMessage ?? 'Failed to load products',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        
        final products = apiState.model?.data ?? [];
        
        if (products.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text('No products available'),
          );
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            shrinkWrap: true, // Important for nested scrolling
            physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 items per row as per screenshot
              crossAxisSpacing: 0, // No horizontal spacing between items
              mainAxisSpacing: 0, // No vertical spacing between items
              childAspectRatio: 0.56, // Adjust as needed to fit content
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  context.pushPage(
                    ProductDetailPage(homeCubit: context.read<HomeCubit>()),
                  );
                },
                child: ProductItemContainer(
                  product: product,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ProductItemContainer extends StatelessWidget {
  final Product product;

  const ProductItemContainer({
    super.key,
    required this.product,
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
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: product.imagesUrls.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${GroceryApis.baseUrl}/${product.imagesUrls.first}',
                    width: 70,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: GroceryColorTheme().primary,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.shopping_bag,
                  size: 50,
                  color: GroceryColorTheme().primary,
                ),
        ),
        const SizedBox(height: 4),
        Text(
          product.name,
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
