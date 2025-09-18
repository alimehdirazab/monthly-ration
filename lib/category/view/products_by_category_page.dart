part of "view.dart";

class ProductsByCategoryPage extends StatelessWidget {
  final HomeCubit homeCubit;
  final String categoryName;
  final List<Category>? subCategory;
  final int selectedSubCategoryIndex;
  final bool isFromSubCategory; // New parameter to indicate if navigated from subcategory
  const ProductsByCategoryPage({super.key, required this.homeCubit, required this.categoryName, this.subCategory, this.selectedSubCategoryIndex = 0, this.isFromSubCategory = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: CategoryView(categoryName: categoryName, subCategory: subCategory, selectedSubCategoryIndex: selectedSubCategoryIndex, isFromSubCategory: isFromSubCategory),
    );
  }
}

class CategoryView extends StatefulWidget {
  final String categoryName;
  final List<Category>? subCategory;
  final int selectedSubCategoryIndex;
  final bool isFromSubCategory; // New parameter to indicate if navigated from subcategory

  const CategoryView({super.key, required this.categoryName, this.subCategory, this.selectedSubCategoryIndex = 0, this.isFromSubCategory = false});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _selectedIndex = 0; // For the left-hand category navigation

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCartItems();
    
    if (widget.isFromSubCategory) {
       context.read<HomeCubit>().getProductsBySubCategory(subSubCategoryId: widget.subCategory?[_selectedIndex].id);
 
    } else {
      context.read<HomeCubit>().getProductsBySubCategory(subCategoryId: widget.subCategory?[_selectedIndex].id);
    }
  }

  void _refreshCartItems() {
    // Debounced cart refresh to avoid excessive API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<HomeCubit>().getCartItems();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => 
          previous.addToCartApiState != current.addToCartApiState ||
          previous.updateCartItemApiState != current.updateCartItemApiState ||
          previous.deleteCartItemApiState != current.deleteCartItemApiState,
      listener: (context, state) {
        // Refresh cart items when add/update/delete operations complete successfully
        if (state.addToCartApiState.apiCallState == APICallState.loaded ||
            state.updateCartItemApiState.apiCallState == APICallState.loaded ||
            state.deleteCartItemApiState.apiCallState == APICallState.loaded) {
          _refreshCartItems();
        }
      },
      child: Scaffold(
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
                     // context.read<HomeCubit>().getProductsBySubCategory(subCategoryId: subCat.id);
                     if (widget.isFromSubCategory) {
                       context.read<HomeCubit>().getProductsBySubCategory(subSubCategoryId: subCat.id);
 
                     } else {
                       context.read<HomeCubit>().getProductsBySubCategory(subCategoryId: subCat.id);
                     }
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
                        padding: const EdgeInsets.all(4.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns as per screenshot
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.52, // Adjust to fit content well
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              context.pushPage(ProductDetailPage(homeCubit: context.read<HomeCubit>(), productId: product.id));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RepaintBoundary(
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) {
            // Only rebuild when cart has items or becomes empty
            final prevCartItems = previous.getCartItemsApiState.model?.data ?? [];
            final currCartItems = current.getCartItemsApiState.model?.data ?? [];
            
            return (prevCartItems.isEmpty && currCartItems.isNotEmpty) ||
                   (prevCartItems.isNotEmpty && currCartItems.isEmpty);
          },
          builder: (context, state) {
            final cartItems = state.getCartItemsApiState.model?.data ?? [];
            
            if (cartItems.isNotEmpty) {
              return FloatingActionButton.extended(
                onPressed: () {
                   context.pushPage(CheckoutPage(
                            homeCubit: context.read<HomeCubit>(),
                          ));
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
                      // Product images stack with separate BlocBuilder
                      BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) {
                          // Only rebuild when cart content changes (products, not just quantities)
                          final prevCartItems = previous.getCartItemsApiState.model?.data ?? [];
                          final currCartItems = current.getCartItemsApiState.model?.data ?? [];
                          
                          if (prevCartItems.length != currCartItems.length) return true;
                          
                          // Check if the actual products in cart changed (for first 3 items)
                          for (int i = 0; i < prevCartItems.length && i < 3; i++) {
                            if (i >= currCartItems.length || 
                                prevCartItems[i].product?.id != currCartItems[i].product?.id) {
                              return true;
                            }
                          }
                          return false;
                        },
                        builder: (context, state) {
                          final cartItems = state.getCartItemsApiState.model?.data ?? [];
                          
                          // Get first 3 product images from cart items
                          final List<String> productImages = [];
                          for (int i = 0; i < cartItems.length && i < 3; i++) {
                            final product = cartItems[i].product;
                            if (product?.images != null && product!.images!.isNotEmpty) {
                              try {
                                // Parse images from JSON string if needed
                                final imageData = product.images!;
                                if (imageData.startsWith('[') && imageData.endsWith(']')) {
                                  // It's a JSON array string, extract first image
                                  final cleanedData = imageData.substring(1, imageData.length - 1);
                                  final firstImage = cleanedData.split(',')[0].replaceAll('"', '').trim();
                                  if (firstImage.isNotEmpty) {
                                    productImages.add(firstImage);
                                  }
                                } else {
                                  // It's a single image URL
                                  productImages.add(imageData);
                                }
                              } catch (e) {
                                // If parsing fails, use default image
                                productImages.add(GroceryImages.category2);
                              }
                            } else {
                              // Use default image if no product image
                              productImages.add(GroceryImages.category2);
                            }
                          }
                          
                          // Ensure we have at least one image
                          if (productImages.isEmpty) {
                            productImages.add(GroceryImages.category2);
                          }
                          
                          return SizedBox(
                            width: 40 + (productImages.length > 1 ? (productImages.length - 1) * 15 : 0),
                            height: 40,
                            child: Stack(
                              children: List.generate(productImages.length, (index) {
                                return Positioned(
                                  left: index * 15.0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        productImages[index].startsWith('http') 
                                            ? productImages[index]
                                            : '${GroceryApis.baseUrl}/${productImages[index]}',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            GroceryImages.category2,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      // Text section with separate BlocBuilder for count
                      BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) {
                          // Only rebuild when cart items count changes
                          final prevCartItems = previous.getCartItemsApiState.model?.data ?? [];
                          final currCartItems = current.getCartItemsApiState.model?.data ?? [];
                          
                          return prevCartItems.length != currCartItems.length;
                        },
                        builder: (context, state) {
                          final cartItems = state.getCartItemsApiState.model?.data ?? [];
                          
                          return Column(
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
                                '${cartItems.length} item${cartItems.length > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      // Arrow Icon (static, no BlocBuilder needed)
                      InkWell(
                        onTap: () {
                          context.pushPage(CheckoutPage(
                            homeCubit: context.read<HomeCubit>(),
                          ));
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
            }
            return const SizedBox();
          },
        ),
      ),





      ));
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
  bool _isLoading = false; // Local loading state for this specific product

  @override
  void initState() {
    super.initState();
    // Initialize quantity from cart if product exists
    _initializeQuantityFromCart();
  }

  void _initializeQuantityFromCart() {
    final cartItems = context.read<HomeCubit>().state.getCartItemsApiState.model?.data ?? [];
    
    // Find if this product exists in cart
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == widget.product.id,
      orElse: () => home_models.CartItem(), // Return empty CartItem if not found
    );
    
    // Set quantity from cart if found, otherwise keep 0
    if (cartItem.productId != null) {
      final newQuantity = cartItem.quantity ?? 0;
      if (_quantity != newQuantity) {
        setState(() {
          _quantity = newQuantity;
        });
      }
    } else {
      if (_quantity != 0) {
        setState(() {
          _quantity = 0;
        });
      }
    }
  }

  void _incrementQuantity() {
    if (_isLoading) return; // Prevent multiple calls
    
    final cartItems = context.read<HomeCubit>().state.getCartItemsApiState.model?.data ?? [];
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == widget.product.id,
      orElse: () => home_models.CartItem(),
    );

    setState(() {
      _isLoading = true;
    });

    if (_quantity == 0) {
      // Product not in cart yet, call addToCart API
      context.read<HomeCubit>().addToCart(
        productId: widget.product.id,
        quantity: 1,
      );
      
      // Update local state immediately for better UX
      setState(() {
        _quantity = 1;
      });
    } else {
      // Product already in cart, call updateCartItem API
      if (cartItem.id != null) {
        final newQuantity = _quantity + 1;
        
        context.read<HomeCubit>().updateCartItem(
          cartItemId: cartItem.id!,
          quantity: newQuantity,
        );
        
        // Update local state immediately for better UX
        setState(() {
          _quantity = newQuantity;
        });
      }
    }
  }

  void _decrementQuantity() {
    if (_quantity > 0 && !_isLoading) {
      final cartItems = context.read<HomeCubit>().state.getCartItemsApiState.model?.data ?? [];
      final cartItem = cartItems.firstWhere(
        (item) => item.productId == widget.product.id,
        orElse: () => home_models.CartItem(),
      );

      setState(() {
        _isLoading = true;
      });

      if (cartItem.id != null) {
        final newQuantity = _quantity - 1;
        
        if (newQuantity == 0) {
          // Delete cart item when quantity becomes 0
          context.read<HomeCubit>().deleteCartItem(
            cartItemId: cartItem.id!,
          );
        } else {
          // Update with decremented quantity
          context.read<HomeCubit>().updateCartItem(
            cartItemId: cartItem.id!,
            quantity: newQuantity,
          );
        }
        
        // Update local state immediately for better UX
        setState(() {
          _quantity = newQuantity;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage
    final mrpPrice = double.tryParse(widget.product.mrpPrice) ?? 0.0;
    final salePrice = double.tryParse(widget.product.salePrice) ?? 0.0;
    final discountPercentage = mrpPrice > 0 ? ((mrpPrice - salePrice) / mrpPrice * 100).round() : 0;
    
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => 
          previous.addToCartApiState != current.addToCartApiState ||
          previous.updateCartItemApiState != current.updateCartItemApiState ||
          previous.deleteCartItemApiState != current.deleteCartItemApiState,
      listener: (context, state) {
        // Stop loading when API calls complete (success or failure)
        if (state.addToCartApiState.apiCallState == APICallState.loaded ||
            state.addToCartApiState.apiCallState == APICallState.failure ||
            state.updateCartItemApiState.apiCallState == APICallState.loaded ||
            state.updateCartItemApiState.apiCallState == APICallState.failure ||
            state.deleteCartItemApiState.apiCallState == APICallState.loaded ||
            state.deleteCartItemApiState.apiCallState == APICallState.failure) {
          if (_isLoading) {
            setState(() {
              _isLoading = false;
            });
          }
        }
        
        // Handle API failures and revert local state if needed
        if (state.addToCartApiState.apiCallState == APICallState.failure) {
          // Revert to 0 if add failed
          setState(() {
            _quantity = 0;
          });
        }
        
        if (state.updateCartItemApiState.apiCallState == APICallState.failure ||
            state.deleteCartItemApiState.apiCallState == APICallState.failure) {
          // Revert to previous cart state if update/delete failed
          _initializeQuantityFromCart();
        }
      },
      child: Stack(
        children: [
          Card(
            color: GroceryColorTheme().white,
            
            // margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 1,
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
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                               widget.product.imagesUrls.first,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.fill,
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
                              ),
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
                    // Add/Quantity control at bottom right
                    Positioned(
                      bottom: 1,
                      right: 8,
                      child: _quantity == 0
                          ? GestureDetector(
                              onTap: _isLoading ? null : () {
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
                                    color: _isLoading ? Colors.grey : GroceryColorTheme().greenColor,
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            GroceryColorTheme().greenColor,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'ADD',
                                        style: TextStyle(
                                          color: GroceryColorTheme().greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
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
                                    onTap: _isLoading ? null : _decrementQuantity,
                                    child: Icon(
                                      Icons.remove,
                                      color: _isLoading ? Colors.grey[300] : Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            '$_quantity',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: _isLoading ? null : _incrementQuantity,
                                    child: Icon(
                                      Icons.add,
                                      color: _isLoading ? Colors.grey[300] : Colors.white,
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
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Weight/Brand information
                    if (widget.product.brand != null && widget.product.brand!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          widget.product.brand!,
                          style: TextStyle(
                            color: Colors.grey[600], 
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                       ...List.generate(
                          5,
                          (index) => Icon(
                            index < 4 // Assuming a static rating of 4.5 for demo
                                ? Icons.star
                                : Icons.star_half,
                            color: Colors.amber,
                            size: 12,
                          ),

                       ),
                        Text(
                          ' (25)', // You might want to add reviews to the Product model
                          style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Row(
                      children: [
                        Text(
                          '₹${widget.product.salePrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),

                      ],
                    ),
                    Text(
                          'MRP ₹${widget.product.mrpPrice}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        ),
                  ],
                
            
            ),
          ),
              ],
            ),
          ),
          // Discount chip at top right corner of entire card
          if (discountPercentage > 0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: GroceryColorTheme().greenColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    //bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                ),
                child: Text(
                  '$discountPercentage% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      )
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    widget
                        .imageUrl, // Use widget.imageUrl to access imageUrl from ProductCard
                    height: 130, // Adjust height as needed
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
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
                    fontSize: 11,
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
                   ...List.generate(
                      5,
                      (index) => Icon(
                        index < 4 // Assuming a static rating of 4.5 for demo
                            ? Icons.star
                            : Icons.star_half,
                        color: Colors.amber,
                        size: 12,
                      ),

                   ),
                    Text(
                      ' (25)', // You might want to add reviews to the Product model
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
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
