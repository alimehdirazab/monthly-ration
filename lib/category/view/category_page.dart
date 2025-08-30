part of "view.dart";

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryView();
  }
}

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _selectedIndex = 0; // For the left-hand category navigation

  final List<String> _categories = [
    'Atta',
    'Rice',
    'Oil',
    'Basan',
    'Rajma',
    'Organic',
    // Added for more items
  ];

  // Dummy product data
  final List<Map<String, dynamic>> _products = [
    {
      'imageUrl': GroceryImages.category1,
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    {
      'imageUrl': GroceryImages.category1,
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    {
      'imageUrl': GroceryImages.category2,
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    {
      'imageUrl': GroceryImages.category1, // Duplicated for layout
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    {
      'imageUrl': GroceryImages.category3,
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    {
      'imageUrl': GroceryImages.category1,
      'title': 'Aashirvaad 0% Maida,',
      'description': '100% M.P, Chakki Atta',
      'rating': 4.8,
      'reviews': 75,
      'deliveryTime': '15 Mins',
      'price': '₹465',
      'mrp': 'MRP ₹900',
    },
    // Add more products as needed to fill the screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        title: Text(
          'Atta, Rice & Dal ',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        automaticallyImplyLeading: false,
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
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    // TODO: Filter products based on category
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
                          Image.asset(
                            'assets/images/${_categories[index].toLowerCase()}.png', // Assuming image names match categories
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _categories[index],
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
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns as per screenshot
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.44, // Adjust to fit content well
                        ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return InkWell(
                        onTap: () {
                          context.pushPage(CheckoutPage());
                        },
                        child: ProductCard(
                          imageUrl: product['imageUrl'],
                          title: product['title'],
                          description: product['description'],
                          rating: product['rating'],
                          reviews: product['reviews'],
                          deliveryTime: product['deliveryTime'],
                          price: product['price'],
                          mrp: product['mrp'],
                        ),
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
        border: Border.all(color: Colors.grey.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          text.toLowerCase() == "filter" || text.toLowerCase == "sort"
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
