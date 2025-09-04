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

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().clearCart();
    context.read<AuthCubit>().getAddress();
    context.read<HomeCubit>().getBanners();
    context.read<HomeCubit>().getDefaultCategories();
    context.read<HomeCubit>().getCategories();
    context.read<HomeCubit>().getProducts();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeCubit>().getBanners();
          context.read<HomeCubit>().getDefaultCategories();
          context.read<HomeCubit>().getProducts();
          
          // Reset banner controller and timer on refresh
          _bannerTimer?.cancel();
          _bannerPageController?.dispose();
          _bannerPageController = null;
        },
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildBanner(),
                  const SizedBox(height: 16),
                  _buildBestsellersSection(),
                  _buildCategoriesWithSubcategories(),
                ],
              ),
            ),
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
  Widget _buildSliverAppBar(BuildContext context) {
    AppState appState = context.select((AppCubit cubit) => cubit.state);
    final address = appState.user.customer?.addressLine1 ?? "";
    
    return SliverAppBar(
      backgroundColor: GroceryColorTheme().primary,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: GroceryColorTheme().primary,
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
                        '15 minutes',
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
                  GestureDetector(
                    onTap: () {
                     context.pushPage(MyWalletPage(accountCubit: context.read<AccountCubit>()));
                    },
                    child: Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          color: GroceryColorTheme().primary,
          child: Column(
            children: [
              // Search Field
              const SearchField(),
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
                            subCategory: category.subCategories,
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

  Widget _buildBestsellersSection() {
    // Category data matching the reference image design
    // Static bestseller categories generated from provided API response
    final List<Map<String, dynamic>> bestsellerCategories = [
      {
      'title': 'Gcocery & Kitchen',
      'moreCount': '+7 more',
      'images': [
        // Take 4 images from sub_categories, repeat last if missing
        'https://monthlyration.in/uploads/categories/images/1756711680_aata-removebg-preview.png',
        'https://monthlyration.in/uploads/categories/images/1756711117_cooking_oils-removebg-preview.png',
        'https://monthlyration.in/uploads/categories/images/1756711211_biscuits__bakery-removebg-preview.png',
        'https://monthlyration.in/uploads/categories/images/1756711286_dry-removebg-preview.png',
      ],
      },
      {
      'title': 'Drinks & Snacks',
      'moreCount': '+5 more',
      'images': [
        'https://monthlyration.in/uploads/categories/images/1756713226_0xvfhoAqcQ.png',
        'https://monthlyration.in/uploads/categories/images/1756713317_eaCzSsCPMF.png',
        'https://monthlyration.in/uploads/categories/images/1756713499_cWhBuHsRGW.png',
        'https://monthlyration.in/uploads/categories/images/1756713716_gPQhk15Rf5.png',
      ],
      },
      {
      'title': 'Beauty & Personal Care',
      'moreCount': '+3 more',
      'images': [
        'https://monthlyration.in/uploads/categories/images/1756714399_3ZnbkxFKZc.png',
        'https://monthlyration.in/uploads/categories/images/1756714536_5tsAL8lOMi.png',
        'https://monthlyration.in/uploads/categories/images/1756714613_rUrFEIsvXa.png',
        'https://monthlyration.in/uploads/categories/images/1756714720_Egj0VJHZoh.png',
      ],
      },
      {
      'title': 'Household Needs',
      'moreCount': '+12 more',
      'images': [
        // No images in sub_categories, so repeat main category image
        'https://monthlyration.in/uploads/categories/images/1756713499_cWhBuHsRGW.png',
        'https://monthlyration.in/uploads/categories/images/1756711211_biscuits__bakery-removebg-preview.png',
        'https://monthlyration.in/uploads/categories/images/1756711286_dry-removebg-preview.png',
        'https://monthlyration.in/uploads/categories/images/1756714536_5tsAL8lOMi.png',
        ],
      },
    ];

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
          const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bestsellerCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row as requested
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.84, // Increased to fix overflow
            ),
            itemBuilder: (context, index) {
              final category = bestsellerCategories[index];
              return BestsellerCategoryCard(category: category);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
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
              context.pushPage(
                ProductsByCategoryPage(
                  homeCubit: context.read<HomeCubit>(),
                  categoryName: subcategory.name,
                  subCategory: subcategories,
                  selectedSubCategoryIndex: index,
                ),
              );
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

  const BestsellerCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = category['images'] ?? [];
    
    return Stack(
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
        Text(
          subcategory.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
