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
    // Get product images from static assets since API doesn't provide images
    final List<String> productImages = [
      GroceryImages.product,
      GroceryImages.product,
      GroceryImages.product,
      GroceryImages.product,
    ];

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
                          child: Image.asset(
                            productImages[_currentImageIndex],
                            fit: BoxFit.contain,
                            height: 250,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
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
                          setState(() {
                            _currentImageIndex = index;
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
                            child: Image.asset(
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
          
          // Description section (static for now)
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
                const Text(
                  'Masha is a famous Indian flavor to improve health. Masha is the main ingredient which makes your teeth strong.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
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
    // Extract attribute values for tags (like weight, type)
    List<Widget> attributeTags = [];
    for (var attributeValue in productDetails.attributeValues) {
      for (var value in attributeValue.attribute.values) {
        attributeTags.add(_buildTag(value.value));
        attributeTags.add(const SizedBox(width: 8));
      }
    }
    
    // If no attributes, add brand as tag
    if (attributeTags.isEmpty && productDetails.brand != null) {
      attributeTags.add(_buildTag(productDetails.brand!));
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
                productDetails.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),
              
              // Price from API (with static MRP if needed)
              Row(
                children: [
                  Text(
                    '₹${productDetails.price??'0.0'}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GroceryColorTheme().black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Static MRP (higher than actual price)
                  Text(
                    'MRP ₹${(double.tryParse(productDetails.price.toString()) ?? 0) * 1.3}',
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
              if (productDetails.extraFields.isNotEmpty)
                const SizedBox(height: 10),
              if (productDetails.extraFields.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: productDetails.extraFields.map<Widget>((field) {
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
    // Use related products from API if available, otherwise use static data
    final hasRelatedProducts = productDetails.relatedProducts.isNotEmpty;
    final staticProducts = [
      {'image': GroceryImages.grocery2, 'name': 'Musha Atta'},
      {'image': GroceryImages.grocery3, 'name': 'Olive Oil'},
      {'image': GroceryImages.grocery4, 'name': 'Sunflower Oil'},
    ];

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
              itemCount: hasRelatedProducts ? productDetails.relatedProducts.length : staticProducts.length,
              itemBuilder: (context, index) {
                if (hasRelatedProducts) {
                  // Use related products from API (you might need to adjust based on the actual structure)
                  final relatedProduct = productDetails.relatedProducts[index];
                  return _buildSimilarProductCard(
                    context,
                    image: GroceryImages.product, // Static image since API doesn't provide
                    name: relatedProduct.toString(), // Convert to string or extract name field
                  );
                } else {
                  // Use static data
                  return _buildSimilarProductCard(
                    context,
                    image: staticProducts[index]['image']!,
                    name: staticProducts[index]['name']!,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(BuildContext context, {required String image, required String name}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 1,
                child: Text(
                  name,
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
              context.read<HomeCubit>().addToCart("itemName");
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
              context.pushPage(CheckoutPage());
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
