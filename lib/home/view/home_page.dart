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
  PageController? _bannerPageController;
  Timer? _bannerTimer;
  // banner 2
  PageController? _banner2PageController;
  Timer? _banner2Timer;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getAddress();
    context.read<HomeCubit>().getBanners();
    context.read<HomeCubit>().getDefaultCategories();
    context.read<HomeCubit>().getCategories();
    context.read<HomeCubit>().getCartItems();
    context.read<HomeCubit>().getOrders();
    context.read<HomeCubit>().getTrendingProducts();
    context.read<HomeCubit>().getShippingFee();
    context.read<HomeCubit>().getFeaturedProducts();
    context.read<HomeCubit>().getWalletBalance();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController?.dispose();
    // banner 2
    _banner2PageController?.dispose();
    _banner2Timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeCubit>().getBanners();
              context.read<HomeCubit>().getDefaultCategories();
              context.read<HomeCubit>().getCategories();
              context.read<HomeCubit>().getCartItems();
              context.read<HomeCubit>().getOrders();
              context.read<HomeCubit>().getTrendingProducts();
              context.read<HomeCubit>().getShippingFee();
              context.read<HomeCubit>().getFeaturedProducts();
              context.read<HomeCubit>().getWalletBalance();
              // Reset banner controller and timer on refresh
              _bannerTimer?.cancel();
              _bannerPageController?.dispose();
              _bannerPageController = null;
              // banner 2
              _banner2Timer?.cancel();
              _banner2PageController?.dispose();
              _banner2PageController = null;
            },
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(context),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildBanner(),
                            const SizedBox(height: 8),
                            _buildBestsellersSection(),
                            _buildCategoriesWithSubcategories(),
                            _buildBanner2(),
                            _buildTrendingSection(),
                            const SizedBox(height: 10), // Space for floating cart and progress widget
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: const FreeShippingProgressWidget(),
                // ),
              ],
            ),
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
        ),
        // Free shipping progress widget at bottom with dynamic progress
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
    );
  }

  // --- Widgets for different sections of the screen ---
  Widget _buildSliverAppBar(BuildContext context) {
    AppState appState = context.select((AppCubit cubit) => cubit.state);
    final address = appState.user.customer?.addressLine1 ?? "";
    
    return SliverAppBar(
      backgroundColor: GroceryColorTheme().primary, // Make transparent to show gradient
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                GroceryColorTheme().primary, // Top color
                GroceryColorTheme().primary.withValues(alpha: 0.8), // Middle
                GroceryColorTheme().white.withValues(alpha: 0.1), // Bottom fade to white
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with delivery info and icons
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Ration',
                        style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: GroceryTextTheme().lightText,
                      ),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => 
                        previous.walletBalanceApiState != current.walletBalanceApiState,
                    builder: (context, state) {
                      final walletBalance = state.walletBalanceApiState.model?.currentWalletBalance ?? '0';
                      
                      return GestureDetector(
                        onTap: () {
                          context.pushPage(MyWalletPage(accountCubit: context.read<AccountCubit>()));
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: GroceryColorTheme().white,
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: GroceryColorTheme().black,
                                size: 20,
                              ),
                            ),
                            // Wallet balance badge
                            // if (state.walletBalanceApiState.apiCallState == APICallState.loaded && 
                            //     walletBalance != '0' && walletBalance.isNotEmpty)  
                              Positioned(
                                right: 16,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '₹$walletBalance',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      context.read<NavBarCubit>().getNavBarItem(NavBarItem.account);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GroceryColorTheme().white,
                      ),
                      child: Icon(Icons.account_circle_outlined, color: GroceryColorTheme().black, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(92),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                GroceryColorTheme().primary.withValues(alpha: 0.3), // Fade from top
                GroceryColorTheme().white, // White at bottom
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            children: [
              // Search Field
              GestureDetector(
                onTap: () {
                context.pushPage(SearchProductPage(homeCubit: context.read<HomeCubit>()));
                },
                child: const SearchField(
                  
                ),
              ),
              SizedBox(height: 8),
              _buildCategoryTabs(),
              ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
         // previous.defaultCategoriesApiState != current.defaultCategoriesApiState ||
          previous.categoriesApiState != current.categoriesApiState ||
          previous.selectedCategoryIndex != current.selectedCategoryIndex,
      builder: (context, state) {
        //final apiState = state.defaultCategoriesApiState;
        final apiState = state.categoriesApiState;
       // final selectedCategoryIndex = state.selectedCategoryIndex;
        
        // Get categories from API or use empty list
        final apiCategories = apiState.model?.data ?? [];
        
        // Create final list with "All" first, then API categories
        // final List<Category?> categories = [null, ...apiCategories]; // null represents "All"
        // final List<String> categoryNames = ['All', ...apiCategories.map((cat) => cat.name)];
          final List<Category?> categories = [...apiCategories]; 
        final List<String> categoryNames = [...apiCategories.map((cat) => cat.name)];

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
          height: 75, // Height for category row
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemBuilder: (context, index) {
             // final bool isSelected = selectedCategoryIndex == index;
              final category = categories[index];
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                   onTap: () {
                        context.read<HomeCubit>().setSelectedCategoryIndex(index);
                        // Handle category selection logic here
                        // You can call API or filter products based on selected category
                        // if (category != null) {
                        //   context.read<HomeCubit>().getProducts(categoryId: category.id);
                        // } else {
                        //   context.read<HomeCubit>().getProducts();
                        // }
                        if (category != null) {
                          context.pushPage(
                          ProductsByCategoryPage(
                            homeCubit: context.read<HomeCubit>(),
                            categoryName: category.name,
                            subCategory: category.subCategories, // Keep subSubCategories as you wanted
                          ),
                        );
                        } else {
                         
                        }
                      },
                  child: Column(
                    children: [
                      category?.image != null && category!.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                category.image!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If image fails to load, show default icon
                                  return Icon(
                                    Icons.category,
                                    color: GroceryColorTheme().black,
                                    size: 36,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              GroceryIcons().category,
                              color: GroceryColorTheme().black,
                              size: 30,
                            ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 70,
                        child: Text(
                          categoryNames[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: GroceryColorTheme().black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center
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
        
        // Initialize page controller if not already done
        if (_bannerPageController == null) {
          int initialPage = banners.length > 1 ? banners.length * 500 : 0; // Start from middle for infinite scroll
          _bannerPageController = PageController(
            viewportFraction: 0.92,
            initialPage: initialPage,
          );
          
          // Start auto-scroll timer only if there are multiple banners
          if (banners.length > 1) {
            _startBannerAutoScroll(banners.length);
          }
        }
        
        // Carousel slider for banners with infinite scroll capability
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: 190,
            width: double.infinity,
            child: PageView.builder(
              itemCount: banners.length > 1 ? banners.length * 1000 : banners.length, // Infinite scroll for multiple banners
              controller: _bannerPageController,
              onPageChanged: (index) {
                // When user manually scrolls, restart the auto-scroll timer
                if (banners.length > 1) {
                  _startBannerAutoScroll(banners.length);
                }
              },
              itemBuilder: (context, index) {
                final bannerIndex = index % banners.length; // Get actual banner index
                final banner = banners[bannerIndex];
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

    void _startBannerAutoScroll(int bannerCount) {
    _bannerTimer?.cancel(); // Cancel any existing timer
    
    if (bannerCount <= 1) return; // No need to auto-scroll for single banner
    
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerPageController != null && _bannerPageController!.hasClients) {
        int currentPage = _bannerPageController!.page?.round() ?? 0;
        int nextPage = currentPage + 1;
        
        _bannerPageController!.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildTrendingSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.trendingProductsApiState != current.trendingProductsApiState,
      builder: (context, state) {
        final apiState = state.trendingProductsApiState;
        
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GroceryColorTheme().gradient1,
                GroceryColorTheme().gradient2,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title and subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Trending Items',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C), // Dark teal color
                          ),
                        ),
                        // see more
                        Spacer(),
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF004D40), // Darker teal for "See More"
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Discover the top products trending today',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF004D40), // Darker teal for subtitle
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // API-based horizontal scrollable product list
              if (apiState.apiCallState == APICallState.loading)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              else if (apiState.apiCallState == APICallState.failure)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        apiState.errorMessage ?? 'Failed to load trending products',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else if (apiState.model?.data == null || apiState.model!.data.isEmpty)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.trending_up, size: 48, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        'No trending products available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 300, // Fixed height for the horizontal scroll
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: apiState.model!.data.length,
                      itemBuilder: (context, index) {
                        final product = apiState.model!.data[index];
                        return SizedBox(
                          width: 180, // Fixed width for each ProductCardFromApi
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ProductCardFromApi(
                              product: product,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }


  // build banner 2
   Widget _buildBanner2() {
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
        
        // Initialize page controller if not already done
        if (_banner2PageController == null) {
          int initialPage = banners.length > 1 ? banners.length * 500 : 0; // Start from middle for infinite scroll
          _banner2PageController = PageController(
            viewportFraction: 0.92,
            initialPage: initialPage,
          );
          
          // Start auto-scroll timer only if there are multiple banners
          if (banners.length > 1) {
            _startBanner2AutoScroll(banners.length);
          }
        }
        
        // Carousel slider for banners with infinite scroll capability
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: 190,
            width: double.infinity,
            child: PageView.builder(
              itemCount: banners.length > 1 ? banners.length * 1000 : banners.length, // Infinite scroll for multiple banners
              controller: _banner2PageController,
              onPageChanged: (index) {
                // When user manually scrolls, restart the auto-scroll timer
                if (banners.length > 1) {
                  _startBanner2AutoScroll(banners.length);
                }
              },
              itemBuilder: (context, index) {
                final bannerIndex = index % banners.length; // Get actual banner index
                final banner = banners[bannerIndex];
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

    void _startBanner2AutoScroll(int bannerCount) {
    _banner2Timer?.cancel(); // Cancel any existing timer
    
    if (bannerCount <= 1) return; // No need to auto-scroll for single banner

    _banner2Timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_banner2PageController != null && _banner2PageController!.hasClients) {
        int currentPage = _banner2PageController!.page?.round() ?? 0;
        int nextPage = currentPage + 1;
        
        _banner2PageController!.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }


  Widget _buildBestsellersSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.featuredProductsApiState != current.featuredProductsApiState,
      builder: (context, state) {
        final apiState = state.featuredProductsApiState;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Bestsellers',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            // API-based content
            if (apiState.apiCallState == APICallState.loading)
              Container(
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            else if (apiState.apiCallState == APICallState.failure)
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      apiState.errorMessage ?? 'Failed to load featured products',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else if (apiState.model == null || apiState.model!.isEmpty)
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'No featured products available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: apiState.model!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row as requested
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.84, // Increased to fix overflow
                  ),
                  itemBuilder: (context, index) {
                    final featuredCategory = apiState.model![index];
                    
                    // Convert API data to the format expected by BestsellerCategoryCard
                    final categoryData = {
                      'title': featuredCategory.categoryName ?? 'Unknown Category',
                      'moreCount': '+${(featuredCategory.products?.length ?? 0)} more',
                      'images': featuredCategory.products?.take(4).map((product) => 
                        product.thumbnailImg ?? '').where((img) => img.isNotEmpty).toList() ?? [],
                      'categoryId': featuredCategory.categoryId, // Add categoryId for navigation
                    };
                    
                    return BestsellerCategoryCard(
                      category: categoryData,
                      onTap: () {
                        // Navigate to ProductsByCategoryPage when tapped
                        // You'll need to get the category details first
                      //  _navigateToFeaturedCategory(context, featuredCategory);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Helper method to navigate to featured category
  void _navigateToFeaturedCategory(BuildContext context, FeaturedProductsModel featuredCategory) {
    if (featuredCategory.categoryId != null && featuredCategory.categoryName != null) {
      // For now, we'll navigate with the category name and id
      // You might need to fetch subcategories for this category if required
      context.pushPage(
        ProductsByCategoryPage(
          homeCubit: context.read<HomeCubit>(),
          categoryName: featuredCategory.categoryName!,
          subCategory: [], // You might need to fetch subcategories based on categoryId
          selectedSubCategoryIndex: 0,
          isFromSubCategory: false,
        ),
      );
    } else {
      // Show a message if category data is insufficient
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to navigate to this category'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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

  Widget _buildCategoriesWithSubcategories() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categoriesApiState != current.categoriesApiState,
      builder: (context, state) {
        final apiState = state.categoriesApiState;
        
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
              apiState.errorMessage ?? 'Failed to load categories',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        
        final categories = apiState.model?.data ?? [];
        
        if (categories.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text('No categories available'),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(category.name),
                _buildSubcategoryGrid(category.subCategories),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSubcategoryGrid(List<Category> subcategories) {
    if (subcategories.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'No subcategories available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subcategories.length,
        padding: const EdgeInsets.symmetric(vertical: 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 items per row
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return InkWell(
            onTap: () {
              // Navigate to products by subcategory
               if (subcategory.subSubCategories != null) {
              context.pushPage(
                ProductsByCategoryPage(
                  homeCubit: context.read<HomeCubit>(),
                  categoryName: subcategory.name, // Pass the clicked subcategory name
                  subCategory: subcategory.subSubCategories, // Pass subSubCategories of the clicked subcategory
                  selectedSubCategoryIndex: index,
                  isFromSubCategory: true, // Indicate it's from subcategory
                ),
              );
               }
            },
            child: SubcategoryItemContainer(
              subcategory: subcategory,
            ),
          );
        },
      ),
    );
  }
}


class BestsellerCategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback? onTap;

  const BestsellerCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = category['images'] ?? [];
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
           
            decoration: BoxDecoration(
              color: GroceryColorTheme().weatherBlueColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Grid (2x2)
              Container(
               height: context.mHeight * 0.22,
                padding: const EdgeInsets.all(6), // Reduced padding
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: images.length > 4 ? 4 : images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3, // Reduced spacing
                    mainAxisSpacing: 3, // Reduced spacing
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                       
                      padding: const EdgeInsets.all(4), // Reduced padding
                      decoration: BoxDecoration(
              
                        borderRadius: BorderRadius.circular(20), // Smaller radius
                        color: GroceryColorTheme().white,
                      ),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: GroceryColorTheme().white,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 16, // Smaller icon
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 2),
                    // Category title
                    Text(
                      category['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          Positioned(
                  top: context.mHeight * 0.195,
                  right: context.mWidth * 0.15,
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: GroceryColorTheme().weatherBlueColor.withValues(alpha: 1),
                      borderRadius:  BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                    category['moreCount'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                                  ),
                )
        ],
      ),
    );
  }
}


class SubcategoryItemContainer extends StatelessWidget {
  final Category subcategory;

  const SubcategoryItemContainer({
    super.key,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.mWidth * 0.24,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: GroceryColorTheme().primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: subcategory.image != null && subcategory.image!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    subcategory.image!,
                    width: 70,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.category,
                        size: 80,
                        color: GroceryColorTheme().primary,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.category,
                  size: 80,
                  color: GroceryColorTheme().primary,
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: context.mWidth * 0.2,
          child: Text(
            subcategory.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
