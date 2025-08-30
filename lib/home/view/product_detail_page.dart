part of 'view.dart';

class ProductDetailPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const ProductDetailPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,

      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _currentImageIndex = 0;

  // Example product images (replace with actual image URLs)
  final List<String> _productImages = [
    GroceryImages.product,
    GroceryImages.product,
    GroceryImages.product,
    GroceryImages.product,
  ];

  // Example similar products data
  final List<Map<String, String>> _similarProducts = [
    {'image': GroceryImages.grocery2, 'name': 'Musha Atta'},
    {'image': GroceryImages.grocery3, 'name': 'Olive Oil'},
    {'image': GroceryImages.grocery4, 'name': 'Sunflower Oil'},
  ];

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
      body: SingleChildScrollView(
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
                              _productImages[_currentImageIndex],
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
                              children: List.generate(_productImages.length, (
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
                      itemCount: _productImages.length,
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
                                _productImages[index],
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                    ),
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
            // Product Details Card
            Padding(
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
                      Row(
                        children: [
                          _buildTag('10 kg'),
                          const SizedBox(width: 8),
                          _buildTag('Wheat Atta'),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                      const Text(
                        'Aashirvaad 0% Maida, 100% M.P,Chakki Atta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '₹465',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: GroceryColorTheme().black, // Green color
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'MRP ₹666',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 14,
                          color: GroceryColorTheme().greenColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Similar Products Section
            Padding(
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
                      itemCount: _similarProducts.length,
                      itemBuilder: (context, index) {
                        return _buildSimilarProductCard(
                          context,
                          image: _similarProducts[index]['image']!,
                          name: _similarProducts[index]['name']!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ],
        ),
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
Widget _buildSimilarProductCard(
  BuildContext context, {
  required String image,
  required String name,
}) {
  return Card(
    color: GroceryColorTheme().white,
    margin: const EdgeInsets.only(right: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    elevation: 0,
    child: InkWell(
      onTap: () {
        // Handle similar product tap
      },
      child: SizedBox(
        width: 120, // Fixed width for similar product cards
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                image,
                height: 90,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 90,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
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
