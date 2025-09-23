part of 'view.dart';

class ProductDetailPage extends StatelessWidget {
  final HomeCubit homeCubit;
  final int productId;
  final int initialQuantity;
  const ProductDetailPage({super.key, required this.homeCubit, required this.productId, this.initialQuantity = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: ProductDetailView(productId: productId, initialQuantity: initialQuantity),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  final int productId;
  final int initialQuantity;
  const ProductDetailView({super.key, required this.productId, this.initialQuantity = 0});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> with TickerProviderStateMixin {
  int _currentImageIndex = 0;
  Timer? _autoSlideTimer;
  List<String> _productImages = [];
  
  // Animation controller for key features slide
  late AnimationController _keyFeaturesController;
  late Animation<Offset> _keyFeaturesSlideAnimation;
  bool _isKeyFeaturesVisible = false;
  
  // Selected variant state
  AttributeValueDetail? _selectedVariant;
  int? _selectedAttributeValueId;

  // // Example product images (replace with actual image URLs)
  // final List<String> _productImages = [
  //   GroceryImages.product,
  //   GroceryImages.product,
  //   GroceryImages.product,
  //   GroceryImages.product,
  // ];

  // // Example similar products data
  // final List<Map<String, String>> _similarProducts = [
  //   {'image': GroceryImages.grocery2, 'name': 'Musha Atta'},
  //   {'image': GroceryImages.grocery3, 'name': 'Olive Oil'},
  //   {'image': GroceryImages.grocery4, 'name': 'Sunflower Oil'},
  // ];

  @override
  initState() {
    super.initState();
    _quantity = widget.initialQuantity; // Initialize from constructor parameter
    context.read<HomeCubit>().getProductDetails(widget.productId);
    
    // Initialize animation controller for key features
    _keyFeaturesController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _keyFeaturesSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from left (off-screen)
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _keyFeaturesController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAutoSlide() {
    // Cancel any existing timer
    _autoSlideTimer?.cancel();
    
    // Only start auto slide if there are multiple images
    if (_productImages.length > 1) {
      _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted) {
          setState(() {
            _currentImageIndex = (_currentImageIndex + 1) % _productImages.length;
          });
        }
      });
    }
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  void _toggleKeyFeatures() {
    setState(() {
      _isKeyFeaturesVisible = !_isKeyFeaturesVisible;
    });
    
    if (_isKeyFeaturesVisible) {
      _keyFeaturesController.forward();
    } else {
      _keyFeaturesController.reverse();
    }
  }

  void _selectVariant(AttributeValueDetail variant) {
    setState(() {
      _selectedVariant = variant;
      _selectedAttributeValueId = variant.id;
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _keyFeaturesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light grey background
        appBar: AppBar(
          backgroundColor:
              GroceryColorTheme().primary, // Yellow color for app bar
          elevation: 0,
      
          title: Text(
            'Product details',
            style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.productDetailsApiState != current.productDetailsApiState,
          builder: (context, state) {
            final productDetails = state.productDetailsApiState.model?.data;
            return _buildBottomBar(productDetails);
          },
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.productDetailsApiState != current.productDetailsApiState,
          builder: (context, state) {
            final apiState = state.productDetailsApiState;
            
            if (apiState.apiCallState == APICallState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (apiState.apiCallState == APICallState.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load product details',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().getProductDetails(widget.productId);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            final productDetails = apiState.model?.data;
            
            if (productDetails == null) {
              return const Center(child: Text('Product not found'));
            }
            
            return _buildProductDetailsContent(productDetails);
          },
        ),
      ),
    );
  }

  Widget _buildProductDetailsContent(ProductDetails productDetails) {
    // Use API images if available, otherwise use default image
    final List<String> productImages = productDetails.images?.isNotEmpty == true 
        ? productDetails.images! 
        : [GroceryImages.product];

    // Update product images and start auto slide if images changed
    if (_productImages != productImages) {
      _productImages = productImages;
      // Reset current index if it's out of bounds
      if (_currentImageIndex >= _productImages.length) {
        _currentImageIndex = 0;
      }
      // Start auto slide timer for multiple images
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoSlide();
      });
    }

    return Stack(
      children: [
        SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Carousel Section
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Card(
                  
                    color: GroceryColorTheme().white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: productImages[_currentImageIndex].startsWith('http')
                                  ? Image.network(
                                      productImages[_currentImageIndex],
                                      fit: BoxFit.contain,
                                      height: 250,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        GroceryImages.product,
                                        fit: BoxFit.contain,
                                        height: 250,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Image.asset(
                                      productImages[_currentImageIndex],
                                      fit: BoxFit.contain,
                                      height: 250,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 250,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                            ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(productImages.length, (
                              index,
                            ) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentImageIndex == index
                                          ? GroceryColorTheme().primary
                                              .withValues(
                                                alpha: 0.3,
                                              ) // Yellow for active dot
                                          : GroceryColorTheme().primary,
                                ),
                              );
                            }),
                          ),
                        ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                    
                // Thumbnail images
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productImages.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Stop auto slide temporarily when user manually selects
                          _stopAutoSlide();
                          setState(() {
                            _currentImageIndex = index;
                          });
                          // Restart auto slide after 10 seconds of user inactivity
                          Timer(const Duration(seconds: 10), () {
                            if (mounted) {
                              _startAutoSlide();
                            }
                          });
                        },
                        child: Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: GroceryColorTheme().white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  _currentImageIndex == index
                                      ? const Color(
                                        0xFFFFD700,
                                      ) // Yellow border for selected
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: productImages[index].startsWith('http')
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                      productImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        GroceryImages.product,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                )
                                : Image.asset(
                                    productImages[index],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Variant Selection Section
          _buildVariantSelection(productDetails),

          // Product details card with API data
          _buildProductDetailsCard(productDetails),
          
          // Description section from API
          if (productDetails.description != null && productDetails.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Html(
                    data: productDetails.description,
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        color: Colors.black54,
                      ),
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          
          // Similar products section
          _buildSimilarProductsSection(productDetails),
        ],
      ),
    ),
        // Sliding Key Features Panel
        Positioned(
          left: 0,
          top: 0,
          child: SlideTransition(
            position: _keyFeaturesSlideAnimation,
            child: _buildKeyFeaturesPanel(productDetails),
          ),
        ),
        // Arrow button positioned at the left edge when panel is closed
        if (!_isKeyFeaturesVisible)
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height * 0.2,
            child: GestureDetector(
              onTap: _toggleKeyFeatures,
              child: Container(
                width: 40,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Build variant selection cards
  Widget _buildVariantSelection(ProductDetails productDetails) {
    // Check if product has variants
    if (productDetails.attributeValues == null || productDetails.attributeValues!.isEmpty) {
      return const SizedBox.shrink();
    }

    final attributeValue = productDetails.attributeValues!.first;
    if (attributeValue.attribute?.values == null || attributeValue.attribute!.values!.isEmpty) {
      return const SizedBox.shrink();
    }

    final variants = attributeValue.attribute!.values!;
    
    // Initialize selected variant if not set
    if (_selectedVariant == null && variants.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectVariant(variants.first);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: variants.map((variant) {
              final isSelected = _selectedVariant?.id == variant.id;
              final mrpPrice = double.tryParse(variant.mrpPrice ?? '0') ?? 0.0;
              final sellPrice = double.tryParse(variant.sellPrice ?? '0') ?? 0.0;
              final discountPercent = variant.discount?.replaceAll('%', '') ?? '0';
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => _selectVariant(variant),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade50 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Discount badge
                            if (discountPercent != '0' && discountPercent.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '$discountPercent% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            
                            // Variant value (weight/size)
                            Text(
                              variant.value ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.green : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Price
                            Text(
                              '₹${sellPrice.toInt()}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.green : Colors.black87,
                              ),
                            ),
                            
                            // MRP
                            if (mrpPrice > 0 && mrpPrice != sellPrice)
                              Text(
                                'MRP ₹${mrpPrice.toInt()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            
                            // Price per unit
                            if (variant.value != null)
                              Text(
                                '₹${(sellPrice / _extractNumericValue(variant.value!)).toStringAsFixed(1)}/${_extractUnit(variant.value!)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                        
                        // Selected indicator
                        if (isSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper methods for price calculation
  double _extractNumericValue(String value) {
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(value);
    return double.tryParse(match?.group(1) ?? '1') ?? 1.0;
  }

  String _extractUnit(String value) {
    final regex = RegExp(r'[a-zA-Z]+');
    final match = regex.firstMatch(value);
    return match?.group(0) ?? '100 g';
  }

  // Helper method to build a tag (e.g., "10 kg")
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: GroceryColorTheme().white,
        border: Border.all(color: GroceryColorTheme().greyColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Build the Key Features panel that slides from left
  Widget _buildKeyFeaturesPanel(ProductDetails productDetails) {
    return Row(
      children: [
        // Main panel content
        Container(
          width: MediaQuery.of(context).size.width * 0.60, // 60% of screen width
          height: MediaQuery.of(context).size.height * 0.50, // 50% of screen height
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(0), // No radius since arrow button will be attached
              bottomRight: Radius.circular(8),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Key features',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: _toggleKeyFeatures,
                      //   child: const Icon(
                      //     Icons.close,
                      //     color: Colors.white,
                      //     size: 20,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                
                // Key features content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unit - show selected variant or default
                        if (_selectedVariant?.value != null)
                          _buildKeyFeatureItem('Unit', _selectedVariant!.value!)
                        else if (productDetails.weight != null && productDetails.weight!.isNotEmpty)
                          _buildKeyFeatureItem('Unit', productDetails.weight!),
                        
                        // Type (category)
                        if (productDetails.category != null && productDetails.category!.isNotEmpty)
                          _buildKeyFeatureItem('Type', productDetails.category!),
                        
                        // Shelf Life (static for now, can be added to API later)
                        _buildKeyFeatureItem('Shelf Life', '3 months'),
                        
                        // Brand
                        if (productDetails.brand != null && productDetails.brand!.isNotEmpty)
                          _buildKeyFeatureItem('Brand', productDetails.brand!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Integrated arrow button as part of the panel
        GestureDetector(
          onTap: _toggleKeyFeatures,
          child: Container(
            width: 40,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build each key feature item
  Widget _buildKeyFeatureItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsCard(ProductDetails productDetails) {
    // Build attribute tags with brand, category, and weight - use selected variant weight if available
    List<Widget> attributeTags = [];
    if (productDetails.brand != null && productDetails.brand!.isNotEmpty) {
      attributeTags.add(_buildTag(productDetails.brand!));
    }
    // Show selected variant value or default product weight
    if (_selectedVariant?.value != null && _selectedVariant!.value!.isNotEmpty) {
      if (attributeTags.isNotEmpty) attributeTags.add(const SizedBox(width: 8));
      attributeTags.add(_buildTag(_selectedVariant!.value!));
    } else if (productDetails.weight != null && productDetails.weight!.isNotEmpty) {
      if (attributeTags.isNotEmpty) attributeTags.add(const SizedBox(width: 8));
      attributeTags.add(_buildTag(productDetails.weight!));
    }
    if (productDetails.category != null && productDetails.category!.isNotEmpty) {
      if (attributeTags.isNotEmpty) attributeTags.add(const SizedBox(width: 8));
      attributeTags.add(_buildTag(productDetails.category!));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10.0,
      ),
      child: Card(
        elevation: 1,
        color: GroceryColorTheme().white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Attribute tags
              if (attributeTags.isNotEmpty)
                Wrap(
                  children: attributeTags,
                ),
              const SizedBox(height: 10),
              
              // Static rating (since not in API)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[700], size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    ' (15 Reviewed)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Static delivery time
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.timelapse,
                    size: 20,
                    color: GroceryColorTheme().greenColor,
                  ),
                  Text(
                    "15 mins",
                    style: GroceryTextTheme().bodyText.copyWith(
                      fontSize: 10,
                      color: GroceryColorTheme().lightGreyColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              
              // Product name from API
              Text(
                productDetails.name?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),
              
              // Price from selected variant or API default
              Row(
                children: [
                  Text(
                    '₹${_selectedVariant?.sellPrice ?? productDetails.sellPrice ?? 0}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GroceryColorTheme().black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // MRP from selected variant or API default
                  if ((_selectedVariant?.mrpPrice ?? productDetails.mrpPrice) != null)
                    Text(
                      'MRP ₹${_selectedVariant?.mrpPrice ?? productDetails.mrpPrice}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Static availability
              Text(
                'Available',
                style: TextStyle(
                  fontSize: 14,
                  color: GroceryColorTheme().greenColor,
                ),
              ),
              
              // Extra fields if available (now handling List<dynamic>)
              if (productDetails.extraFields?.isNotEmpty == true)
                const SizedBox(height: 10),
              if (productDetails.extraFields?.isNotEmpty == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: productDetails.extraFields!.map<Widget>((field) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Extra: ${field.toString()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimilarProductsSection(ProductDetails productDetails) {
    // Use related products from API if available, otherwise don't show section
    final hasRelatedProducts = productDetails.relatedProducts?.isNotEmpty == true;
    
    // If no related products from API, return empty widget (hide section completely)
    if (!hasRelatedProducts) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Similar products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 150, // Height for similar product cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productDetails.relatedProducts!.length,
              itemBuilder: (context, index) {
                // Use related products from API
                final relatedProduct = productDetails.relatedProducts![index];
                return _buildSimilarProductCard(
                  context,
                  relatedProduct: relatedProduct,
                );
              },
            ),
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(
    BuildContext context, {
    required RelatedProduct relatedProduct,
  }) {
    // Use API data
    final productName = relatedProduct.name ?? 'Unknown Product';
    final productId = relatedProduct.id;
    final productImages = relatedProduct.images;
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (productId != null) {
              // Navigate to product details with push replacement to avoid stack buildup
           context.pushReplacementPage(
            ProductDetailPage(
                    homeCubit: context.read<HomeCubit>(),
                    productId: productId,
                  ),
           );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: productImages?.isNotEmpty == true
                        ? Image.network(
                            productImages!.first,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.shopping_bag,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_bag,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 1,
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _quantity = 0; // Will be initialized from constructor
  bool _isPlaceOrderPressed = false; // Track place order button press

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    // Optional: You can add a callback here to notify the parent widget (e.g., a cart)
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
    // Optional: You can add a callback here to notify the parent widget (e.g., a cart)
  }

  Widget _buildBottomBar(ProductDetails? productDetails) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.addToCartApiState != current.addToCartApiState,
      listener: (context, state) {
        // Navigate to checkout after successful add to cart (for place order)
        if (state.addToCartApiState.apiCallState == APICallState.loaded && 
            _isPlaceOrderPressed) {
          _isPlaceOrderPressed = false;
          context.pushPage(CheckoutPage(
            homeCubit: context.read<HomeCubit>(),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ).copyWith(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price display section - show selected variant price or default product price
            if (_selectedVariant != null || productDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${_selectedVariant?.sellPrice ?? productDetails?.sellPrice ?? 0}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_selectedVariant?.value != null)
                    Text(
                      'Per ${_selectedVariant!.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    )
                  else if (productDetails?.weight != null && productDetails!.weight!.isNotEmpty)
                    Text(
                      'Per ${productDetails.weight}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              )
            else
              SizedBox(),
            
            Spacer(),
            
            // Dynamic button area - Add to Cart OR Quantity selector
            BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (previous, current) =>
                  previous.addToCartApiState != current.addToCartApiState,
              listener: (context, state) {
                if (state.addToCartApiState.apiCallState == APICallState.loaded &&
                    !_isPlaceOrderPressed) {
                  context.showSnacbar('Added to cart successfully');
                  // After successful add to cart, increment quantity to show +/- controls
                  setState(() {
                    _quantity = 1;
                  });
                } else if (state.addToCartApiState.apiCallState == APICallState.failure) {
                  context.showSnacbar('Failed to add to cart');
                }
              },
              buildWhen: (previous, current) =>
                  previous.addToCartApiState != current.addToCartApiState,
              builder: (context, state) {
                final isLoading = state.addToCartApiState.apiCallState == APICallState.loading;
                final isQuantityZero = _quantity == 0;
                
                if (isQuantityZero) {
                  // Show Add to Cart button when quantity is 0
                  return CustomElevatedButton(
                    backgrondColor: GroceryColorTheme().primary,
                    width: 120,
                    height: 40,
                    onPressed: isLoading
                        ? () {}
                        : () {
                            context.read<HomeCubit>().addToCart(
                              productId: widget.productId,
                              quantity: 1, // Add 1 item
                              attributeValueId: _selectedAttributeValueId,
                            );
                          },
                    buttonText: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "Add to Cart",
                            style: GroceryTextTheme().bodyText.copyWith(
                              color: GroceryColorTheme().black,
                              fontSize: 14,
                            ),
                          ),
                  );
                } else {
                  // Show quantity selector when quantity > 0
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                            size: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _incrementQuantity,
                          child: const Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            
            SizedBox(width: 10),
            
            // Place Order button (always visible)
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.addToCartApiState != current.addToCartApiState,
              builder: (context, state) {
                final isLoading = state.addToCartApiState.apiCallState == APICallState.loading;
                final isQuantityZero = _quantity == 0;
                
                return CustomElevatedButton(
                  backgrondColor: isQuantityZero 
                      ? Colors.grey[400]! 
                      : GroceryColorTheme().primary,
                  width: 100,
                  height: 40,
                  onPressed: isQuantityZero || isLoading
                      ? () {}
                      : () {
                          _isPlaceOrderPressed = true;
                          context.read<HomeCubit>().addToCart(
                            productId: widget.productId,
                            quantity: _quantity,
                            attributeValueId: _selectedAttributeValueId,
                          );
                        },
                  buttonText: isLoading && _isPlaceOrderPressed
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Place Order",
                          style: GroceryTextTheme().bodyText.copyWith(
                            color: isQuantityZero 
                                ? GroceryColorTheme().white
                                : GroceryColorTheme().black,
                            fontSize: 14,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to build a similar product card
// Widget _buildSimilarProductCard(
//   BuildContext context, {
//   required String image,
//   required String name,
// }) {
//   return Card(
//     color: GroceryColorTheme().white,
//     margin: const EdgeInsets.only(right: 15),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//     elevation: 0,
//     child: InkWell(
//       onTap: () {
//         // Handle similar product tap
//       },
//       child: SizedBox(
//         width: 120, // Fixed width for similar product cards
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(15),
//               ),
//               child: Image.asset(
//                 image,
//                 height: 90,
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//                 errorBuilder:
//                     (context, error, stackTrace) => Container(
//                       height: 90,
//                       color: Colors.grey[300],
//                       child: const Center(child: Icon(Icons.broken_image)),
//                     ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 name,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
