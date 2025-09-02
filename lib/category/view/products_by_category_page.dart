part of "view.dart";

class ProductsByCategoryPage extends StatelessWidget {
  final HomeCubit homeCubit;
  final String categoryName;
  final List<Category>? subCategory;
  const ProductsByCategoryPage({super.key, required this.homeCubit, required this.categoryName, this.subCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: CategoryView(categoryName: categoryName, subCategory: subCategory),
    );
  }
}

class CategoryView extends StatefulWidget {
  final String categoryName;
  final List<Category>? subCategory;

  const CategoryView({super.key, required this.categoryName, this.subCategory});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _selectedIndex = 0; // For the left-hand category navigation

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProductsBySubCategory(subCategoryId: widget.subCategory?.first.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        title: Text(
          widget.categoryName,
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar for Categories
          Container(
            width: 70, // Fixed width for sidebar
            color: Colors.white,
            child: ListView.builder(
              itemCount: widget.subCategory?.length ?? 0,
              itemBuilder: (context, index) {
                final subCat = widget.subCategory![index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      context.read<HomeCubit>().getProductsBySubCategory(subCategoryId: subCat.id);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          // _selectedIndex == index
                          //     ? const Color(
                          //       0xFFFEEECF,
                          //     ) // Light yellow for selected
                          //     :
                          Colors.white,
                      border: Border(
                        right: BorderSide(
                          color:
                              _selectedIndex == index
                                  ? GroceryColorTheme().primary
                                  : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Show subcategory image if available, otherwise show default icon
                          subCat.image != null && subCat.image!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    subCat.image!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.category,
                                        size: 40,
                                        color: _selectedIndex == index
                                            ? GroceryColorTheme().primary
                                            : Colors.grey,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.category,
                                  size: 40,
                                  color: _selectedIndex == index
                                      ? GroceryColorTheme().primary
                                      : Colors.grey,
                                ),
                          const SizedBox(height: 5),
                          Text(
                            subCat.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  _selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  _selectedIndex == index
                                      ? GroceryColorTheme().primary
                                      : Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Main Content Area (Filters + Product Grid)
          Expanded(
            child: Column(
              children: [
                // Filter and Sort Bar
                Container(
                  height: 50, // Height for the filter bar
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('Filter', Icons.filter_list),
                      _buildFilterChip('Sort', Icons.sort),
                      _buildFilterChip('Brand', Icons.keyboard_arrow_down),
                      _buildFilterChip('Atta', Icons.keyboard_arrow_down),
                      // Add more filter chips as needed
                    ],
                  ),
                ),
                // Product Grid
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.productsBySubCategoryApiState != current.productsBySubCategoryApiState,
                    builder: (context, state) {
                      final apiState = state.productsBySubCategoryApiState;
                      
                      if (apiState.apiCallState == APICallState.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      
                      if (apiState.apiCallState == APICallState.failure) {
                        return Center(
                          child: Text(
                            apiState.errorMessage ?? 'Failed to load products',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      
                      final products = apiState.model?.data ?? [];
                      
                      if (products.isEmpty) {
                        return Center(
                          child: Text('No products available'),
                        );
                      }
                      
                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns as per screenshot
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.44, // Adjust to fit content well
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              context.pushPage(CheckoutPage());
                            },
                            child: ProductCardFromApi(
                              product: product,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          text.toLowerCase() == "filter" || text.toLowerCase() == "sort"
              ? Icon(Icons.tune, size: 18)
              : SizedBox.shrink(),
          const SizedBox(width: 4),

          Text(text, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Icon(icon, size: 18),
        ],
      ),
    );
  }
}

class ProductCardFromApi extends StatefulWidget {
  final home_models.Product product;

  const ProductCardFromApi({
    super.key,
    required this.product,
  });

  @override
  State<ProductCardFromApi> createState() => _ProductCardFromApiState();
}

class _ProductCardFromApiState extends State<ProductCardFromApi> {
  int _quantity = 0; // 0 means "ADD" button is shown, >0 means quantity selector

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
 }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: GroceryColorTheme().white,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image and Add Button/Quantity Selector
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
                child: widget.product.imagesUrls.isNotEmpty
                    ? Image.network(
                        widget.product.imagesUrls.first,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 130,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.shopping_bag,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 130,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.shopping_bag,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              Positioned(
                bottom: 1,
                right: 8,
                child: _quantity == 0
                    ? GestureDetector(
                        onTap: () {
                          _incrementQuantity();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: GroceryColorTheme().black,
                            ),
                          ),
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              color: GroceryColorTheme().black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: GroceryColorTheme().primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _decrementQuantity,
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _incrementQuantity,
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.product.brand,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '4.5', // You might want to add rating to the Product model
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      ' (25 Reviews)', // You might want to add reviews to the Product model
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 16),
                    Text(
                      '15 Mins', // You might want to add delivery time to the Product model
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${widget.product.salePrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MRP ₹${widget.product.mrpPrice}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double rating;
  final int reviews;
  final String deliveryTime;
  final String price;
  final String mrp;
  // You might want to add product-specific details like weight (e.g., '10 kg', 'Wheat Atta')
  // For now, these are hardcoded placeholders in the UI for demonstration.

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.deliveryTime,
    required this.price,
    required this.mrp,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity =
      0; // 0 means "ADD" button is shown, >0 means quantity selector

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    // Optional: You can add a callback here to notify the parent widget (e.g., a cart)
    print('${widget.title} quantity: $_quantity');
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
    // Optional: You can add a callback here to notify the parent widget (e.g., a cart)
    print('${widget.title} quantity: $_quantity');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: GroceryColorTheme().white,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image and Add Button/Quantity Selector
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
                child: Image.asset(
                  widget
                      .imageUrl, // Use widget.imageUrl to access imageUrl from ProductCard
                  height: 130, // Adjust height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom:
                    1, // Adjusted from 8 to 1 for a closer fit to the bottom
                right: 8,
                child:
                    _quantity ==
                            0 // Conditional rendering based on _quantity
                        ? GestureDetector(
                          onTap: () {
                            _incrementQuantity(); // When ADD is tapped, set quantity to 1
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: GroceryColorTheme().black,
                              ), // Using your custom theme color
                            ),
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                color:
                                    GroceryColorTheme()
                                        .black, // Using your custom theme color
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        : Container(
                          // Quantity selector container
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                GroceryColorTheme()
                                    .primary, // Orange background as per image_0fc063.png
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Keep row compact
                            children: [
                              GestureDetector(
                                onTap: _decrementQuantity,
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  '$_quantity', // Display current quantity
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _incrementQuantity,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
              // Placeholder for "10 kg" and "Wheat Atta" - uncomment if needed
              // Positioned(
              //   top: 8,
              //   left: 8,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 6,
              //       vertical: 3,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.6),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           '10 kg', // This should ideally come from data
              //           style: TextStyle(color: Colors.white, fontSize: 10),
              //         ),
              //         Text(
              //           'Wheat Atta', // This should ideally come from data
              //           style: TextStyle(color: Colors.white, fontSize: 10),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title, // Use widget.title
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.description, // Use widget.description
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '${widget.rating}',
                      style: const TextStyle(fontSize: 12),
                    ), // Use widget.rating
                    Text(
                      ' (${widget.reviews} Reviews)', // Use widget.reviews
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 16),
                    Text(
                      widget.deliveryTime, // Use widget.deliveryTime
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.price, // Use widget.price
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.mrp, // Use widget.mrp
                      style: TextStyle(
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
