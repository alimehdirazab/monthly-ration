part of 'view.dart';

class SearchProductPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const SearchProductPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: _SearchProductView(),
    );
  }
}

class _SearchProductView extends StatefulWidget {
  const _SearchProductView();

  @override
  State<_SearchProductView> createState() => _SearchProductViewState();
}

class _SearchProductViewState extends State<_SearchProductView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _showSuggestions = true;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    // Get cart items and shipping info on page load
    context.read<HomeCubit>().getCartItems();
    context.read<HomeCubit>().getShippingFee();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<HomeCubit>().searchProducts(query);
        // Don't hide suggestions immediately, let the API response handle it
      } else {
        setState(() {
          _showSuggestions = true;
          _suggestions.clear();
        });
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      context.read<HomeCubit>().searchProducts(query);
      setState(() {
        _showSuggestions = false;
      });
      _focusNode.unfocus();
    }
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    context.read<HomeCubit>().searchProducts(suggestion);
    setState(() {
      _showSuggestions = false;
    });
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showSuggestions = true;
      _suggestions.clear();
    });
  }

  List<String> _extractSuggestions(List<SearchProduct> products) {
    final suggestions = <String>{};
    for (final product in products.take(10)) {
      if (product.name != null) {
        // Add product name
        suggestions.add(product.name!);
        
        // Add category if available
        if (product.category != null) {
          suggestions.add(product.category!);
        }
        
        // Add brand if available
        if (product.brand != null) {
          suggestions.add(product.brand!);
        }
      }
    }
    return suggestions.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: StatefulBuilder(
            builder: (context, setTextFieldState) {
              return TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (query) {
                  setTextFieldState(() {}); // Rebuild to show/hide clear button
                  _onSearchChanged(query);
                },
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setTextFieldState(() {}); // Rebuild after clear
                            _clearSearch();
                          },
                        )
                      : const Icon(Icons.mic, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.searchProductsApiState != current.searchProductsApiState,
              builder: (context, state) {
                // Update suggestions when we get search results
                if (state.searchProductsApiState.apiCallState == APICallState.loaded &&
                    state.searchProductsApiState.model?.data != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_showSuggestions && _searchController.text.isNotEmpty) {
                      setState(() {
                        _suggestions = _extractSuggestions(state.searchProductsApiState.model!.data!);
                      });
                    }
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Suggestions Section
              if (_showSuggestions && _searchController.text.isNotEmpty && _suggestions.isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
              ],

              // Results Section
              if (!_showSuggestions) ...[
                // Filters Bar (like in the second image)
                Container(
                  color: Colors.white,
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _buildFilterChip('Filters', Icons.tune),
                        const SizedBox(width: 12),
                        _buildFilterChip('Sort', Icons.sort),
                        const SizedBox(width: 12),
                        _buildFilterChip('Price', Icons.keyboard_arrow_down),
                        const SizedBox(width: 12),
                        _buildFilterChip('Brand', Icons.keyboard_arrow_down),
                        const SizedBox(width: 12),
                        _buildFilterChip('Category', Icons.keyboard_arrow_down),
                        const SizedBox(width: 12),
                        _buildFilterChip('Ratings', Icons.star_border),
                        const SizedBox(width: 12),
                        _buildFilterChip('Discount', Icons.local_offer_outlined),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Search Results Header
                if (_searchController.text.isNotEmpty)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Showing results for "${_searchController.text}"',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                // Products Grid
                Expanded(
                  child: _buildSearchResults(state),
                ),
              ],

              // Empty state when no search
              if (_showSuggestions && _searchController.text.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start typing to search products',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
                );
              },
            ),
          // Dynamic free shipping progress widget
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.getCartItemsApiState != current.getCartItemsApiState ||
                previous.shippingApiState != current.shippingApiState,
            builder: (context, state) {
              final cartItems = state.getCartItemsApiState.model?.data ?? [];
              final shippingData = state.shippingApiState.model?.data;
              
              if (cartItems.isEmpty || shippingData == null) {
                return const SizedBox.shrink();
              }

              final shippingThreshold = shippingData.shiipingApplicableAmount?.toDouble() ?? 0;
              
              // Calculate cart total
              double cartTotal = 0;
              for (final item in cartItems) {
                double price = 0;
                if (item.product?.salePrice != null) {
                  if (item.product!.salePrice is num) {
                    price = (item.product!.salePrice as num).toDouble();
                  } else if (item.product!.salePrice is String) {
                    price = double.tryParse(item.product!.salePrice.toString()) ?? 0;
                  }
                }
                final quantity = item.quantity ?? 0;
                cartTotal += price * quantity;
              }

              final progress = shippingThreshold > 0 ? (cartTotal / shippingThreshold).clamp(0.0, 1.0) : 0.0;

              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FreeShippingProgressWidget(
                  progress: progress,
                ),
              );
            },
          ),
          // Conditional Lottie Animation on full screen when free shipping is achieved
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.getCartItemsApiState != current.getCartItemsApiState ||
              previous.shippingApiState != current.shippingApiState,
          builder: (context, state) {
            final cartItems = state.getCartItemsApiState.model?.data ?? [];
            final shippingData = state.shippingApiState.model?.data;
            
            if (cartItems.isEmpty || shippingData == null) {
              return const SizedBox.shrink();
            }

            // Calculate cart total
            double cartTotal = 0;
            for (final item in cartItems) {
              double price = 0;
              if (item.product?.salePrice != null) {
                if (item.product!.salePrice is num) {
                  price = (item.product!.salePrice as num).toDouble();
                } else if (item.product!.salePrice is String) {
                  price = double.tryParse(item.product!.salePrice.toString()) ?? 0;
                }
              }
              final quantity = item.quantity ?? 0;
              cartTotal += price * quantity;
            }

            final shippingThreshold = shippingData.shiipingApplicableAmount?.toDouble() ?? 0;
            
            // Show lottie only if cart total is greater than or equal to shipping threshold
            if (cartTotal >= shippingThreshold && shippingThreshold > 0) {
              return Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.transparent, // Semi-transparent background
                    child: Lottie.asset(
                      GroceryImages.partyLottie,
                      repeat: false,
                      animate: true,
                      reverse: false,
                      fit: BoxFit.cover, // Full screen coverage
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print('Lottie error: $error');
                        return Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: Icon(
                              Icons.celebration,
                              size: 120,
                              color: Colors.amber,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
        ],
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cartItems = state.getCartItemsApiState.model?.data ?? [];
          
          if (cartItems.isNotEmpty) {
            // Get first 3 product images from cart items
            final List<String> productImages = [];
            for (int i = 0; i < cartItems.length && i < 3; i++) {
              final product = cartItems[i].product;
              if (product?.imagesUrls != null && product!.imagesUrls.isNotEmpty) {
                // Use first image from the URLs list
                productImages.add(product.imagesUrls.first);
              } else {
                // Use default image if no product image
                productImages.add(GroceryImages.category2);
              }
            }
            
            // Ensure we have at least one image
            if (productImages.isEmpty) {
              productImages.add(GroceryImages.category2);
            }
            
            return Padding(
               padding: const EdgeInsets.only(bottom: 48),
              child: FloatingActionButton.extended(
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
                      // Product images stack (max 3)
                      SizedBox(
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
                                  child:Image.network(
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
                                        )
                                      
                                ),
                              ),
                            );
                          }),
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
                            '${cartItems.length} item${cartItems.length > 1 ? 's' : ''}',
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

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(HomeState state) {
    if (state.searchProductsApiState.apiCallState == APICallState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.searchProductsApiState.apiCallState == APICallState.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to search products',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _onSearchSubmitted(_searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final products = state.searchProductsApiState.model?.data ?? [];
    
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.57,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final searchProduct = products[index];
        // Convert SearchProduct to Product for ProductCardFromApi
        final List<ProductAttributeValue> attributeValues = [];
        
        // Convert SearchAttributeValue to ProductAttributeValue if available
        if (searchProduct.attributeValues != null) {
          for (final searchAttrValue in searchProduct.attributeValues!) {
            if (searchAttrValue.attribute != null) {
              final List<ProductAttributeValueDetail> values = [];
              
              if (searchAttrValue.attribute!.values != null) {
                for (final searchValue in searchAttrValue.attribute!.values!) {
                  values.add(ProductAttributeValueDetail(
                    id: searchValue.id,
                    value: searchValue.value,
                    mrpPrice: searchValue.mrpPrice ?? '0',
                    discount: searchValue.discount ?? '0',
                    sellPrice: searchValue.sellPrice ?? '0',
                    stock: searchValue.stock ?? 0,
                  ));
                }
              }
              
              attributeValues.add(ProductAttributeValue(
                attribute: ProductAttribute(
                  id: searchAttrValue.attribute!.id ?? 0,
                  name: searchAttrValue.attribute!.name ?? '',
                  values: values,
                ),
              ));
            }
          }
        }
        
        final product = Product(
          id: searchProduct.id ?? 0,
          name: searchProduct.name ?? 'Unknown Product',
          description: searchProduct.description,
          category: searchProduct.category,
          subcategory: searchProduct.subcategory,
          brand: searchProduct.brand,
          mrpPrice: searchProduct.mrpPrice ?? '0',
          discount: searchProduct.discount,
          salePrice: searchProduct.salePrice ?? '0',
          weight: searchProduct.weight,
          imagesUrls: searchProduct.imagesUrls ?? [],
          tax: searchProduct.tax,
          cartQuantity: searchProduct.cartQuantity,
          attributeValues: attributeValues,
        );
        
        return ProductCardFromApi(
          product: product,
        );
      },
    );
  }


}