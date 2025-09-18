part of 'view.dart';

class ProductDetailPage extends StatelessWidget {
  final HomeCubit homeCubit;
  final int productId;
  const ProductDetailPage({super.key, required this.homeCubit, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: ProductDetailView(productId: productId),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  final int productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _currentImageIndex = 0;
  Timer? _autoSlideTimer;
  List<String> _productImages = [];

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
    context.read<HomeCubit>().getProductDetails(widget.productId);
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

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: _buildBottomBar(),
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

    return SingleChildScrollView(
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
                    child: Column(
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

          // Product details card with API data
          _buildProductDetailsCard(productDetails),
          
          // // Description section (static for now)
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         'Description',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black87,
          //         ),
          //       ),
          //       const SizedBox(height: 10),
          //       const Text(
          //         'Masha is a famous Indian flavor to improve health. Masha is the main ingredient which makes your teeth strong.',
          //         style: TextStyle(
          //           fontSize: 14,
          //           color: Colors.black54,
          //           height: 1.4,
          //         ),
          //       ),
          //       const SizedBox(height: 20),
          //     ],
          //   ),
          // ),
          
          // Similar products section
          _buildSimilarProductsSection(productDetails),
        ],
      ),
    );
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

  Widget _buildProductDetailsCard(ProductDetails productDetails) {
    // Since attributeValues is now List<dynamic>, we'll skip complex attribute parsing
    // and use brand as tag if available
    List<Widget> attributeTags = [];
    if (productDetails.brand != null && productDetails.brand!.isNotEmpty) {
      attributeTags.add(_buildTag(productDetails.brand!));
    }
    if (productDetails.category != null && productDetails.category!.isNotEmpty) {
      attributeTags.add(const SizedBox(width: 8));
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
                  children: attributeTags.take(attributeTags.length - 1).toList(), // Remove last SizedBox
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
              
              // Price from API
              Row(
                children: [
                  Text(
                    '₹${productDetails.sellPrice ?? 0}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GroceryColorTheme().black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // MRP from API
                  if (productDetails.mrpPrice != null)
                    Text(
                      'MRP ₹${productDetails.mrpPrice}',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    homeCubit: context.read<HomeCubit>(),
                    productId: productId,
                  ),
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
                  child: // For API products, show shopping bag icon since no image URL provided
                      Container(
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

  int _quantity =
      0; // 0 means "ADD" button is shown, >0 means quantity selector

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

  Widget _buildBottomBar() {
    return Container(
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
          Container(
            // Quantity selector container
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                    size: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$_quantity', // Display current quantity
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
          ),
          Spacer(),
          CustomElevatedButton(
            backgrondColor: GroceryColorTheme().primary,
            width: 100,
            height: 40,
            onPressed: () {
              context.read<HomeCubit>().addToCart(
                productId: widget.productId,
                quantity: _quantity > 0 ? _quantity : 1, // Default to 1 if 0
              );
              context.popPage();
            },
            buttonText: Text(
              "Add to Cart",
              style: GroceryTextTheme().bodyText.copyWith(
                color: GroceryColorTheme().black,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 10),
          CustomElevatedButton(
            backgrondColor: GroceryColorTheme().primary,
            width: 100,
            height: 40,
            onPressed: () {
              context.pushPage(CheckoutPage(
                homeCubit: context.read<HomeCubit>(),
              ));
            },
            buttonText: Text(
              "Place Order",
              style: GroceryTextTheme().bodyText.copyWith(
                color: GroceryColorTheme().black,
                fontSize: 14,
              ),
            ),
          ),
        ],
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
