part of 'view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckoutView();
  }
}

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final List<Map<String, String>> _checkoutItems = const [
    {
      'imageUrl': GroceryImages.ration1,
      'title': 'Aashirvaad 0% Maida,',
      'description': '10 Kg',
      'deliveryTime': '14 minutes',
      'saveForLaterText': 'Save for later',
      'weight': '10 kg', // Example of additional data
    },
    {
      'imageUrl': GroceryImages.ration2,
      'title': 'Aashirvaad 0% Maida,',
      'description': '10 Kg',
      'deliveryTime': '14 minutes',
      'saveForLaterText': 'Save for later',
      'weight': '10 kg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        title: Text(
          'Checkout',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(GroceryIcons().orders),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkout Items
                    ..._checkoutItems.map(
                      (item) => CheckoutProductCard(
                        imageUrl: item['imageUrl']!,
                        title: item['title']!,
                        description: item['description']!,
                        deliveryTime: item['deliveryTime']!,
                        saveForLaterText: item['saveForLaterText']!,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // You might also like section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'You might also like',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true, // Important for nested scrolling
                      physics:
                          const NeverScrollableScrollPhysics(), // Important for nested scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing:
                                6.0, // Horizontal space between cards
                            mainAxisSpacing:
                                6.0, // Vertical space between cards
                            childAspectRatio:
                                0.5, // Adjust this ratio for card height
                          ),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return _ProductCard(product: productList[index]);
                      },
                    ),
                    // SizedBox(
                    //   height: 280, // Height for the horizontal list
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: _recommendedProducts.length,
                    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //     itemBuilder: (context, index) {
                    //       final product = _recommendedProducts[index];
                    //       return RecommendedProductCard(
                    //         imageUrl: product['imageUrl'],
                    //         title: product['title'],
                    //         description: product['description'],
                    //         rating: product['rating'],
                    //         reviews: product['reviews'],
                    //         deliveryTime: product['deliveryTime'],
                    //         price: product['price'],
                    //         mrp: product['mrp'],
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 24),

                    // You got Free delivery banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: GroceryColorTheme().statusBlueColor
                                  .withValues(alpha: 0.1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timelapse_outlined,
                                  color: GroceryColorTheme().statusBlueColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'You got Free delivery',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'No coupons needed',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle "See all coupons" tap
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'See all coupons',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bill Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Bill details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBillDetailRow('Items total', '₹465', isBold: false),
                    _buildBillDetailRow(
                      'Delivery charge',
                      '₹20 FREE',
                      isBold: false,
                      valueColor: Colors.green,
                    ),
                    _buildBillDetailRow(
                      'Handling charge',
                      '₹465',
                      isBold: false,
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                      height: 20,
                      thickness: 1,
                    ),
                    _buildBillDetailRow('Grand total', '₹477', isBold: true),
                    const SizedBox(height: 24),

                    // Issue GST Invoice
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Issue GST Invoice',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        'Click on the check box to get GST invoice on this order. ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: 'Edit',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: false, // This should be managed by state
                            onChanged: (bool? newValue) {
                              // TODO: Handle checkbox state change
                            },
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomElevatedButton(
                      backgrondColor: GroceryColorTheme().primary,
                      width: double.infinity,
                      onPressed: () {
                        context.pushPage(AddAddressPage());
                      },
                      buttonText: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            "Select address at next step",
                            style: GroceryTextTheme().bodyText.copyWith(
                              fontSize: 14,
                              color: GroceryColorTheme().black, 
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: GroceryColorTheme().black,
                          ),
                        ],
                      ),
                    ),
                    // Space for the floating button
                  ],
                ),
              ),
            ),

            // Bottom Floating Button
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.grey[800],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String deliveryTime; // e.g., "10 kg"
  final String saveForLaterText; // e.g., "Save for later"

  const CheckoutProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.deliveryTime,
    required this.saveForLaterText,
  });

  @override
  State<CheckoutProductCard> createState() => _CheckoutProductCardState();
}

class _CheckoutProductCardState extends State<CheckoutProductCard> {
  int _quantity = 1; // Start with 1 for items in checkout

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    print('${widget.title} quantity: $_quantity');
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
    print('${widget.title} quantity: $_quantity');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.timelapse_outlined,
                color: Colors.green,
                size: 20,
              ), // Placeholder for delivery icon
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free delivery in ${widget.deliveryTime}', // Using deliveryTime for "14 minutes"
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Shipment of 1 item', // Using deliveryTime for "14 minutes"
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            height: 20,
            thickness: 1,
            color: GroceryColorTheme().black.withValues(alpha: 0.3),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  widget.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                    Text(
                      widget.saveForLaterText,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _incrementQuantity,
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecommendedProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double rating;
  final int reviews;
  final String deliveryTime;
  final String price;
  final String mrp;

  const RecommendedProductCard({
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
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  int _quantity =
      0; // 0 means "ADD" button is shown, >0 means quantity selector

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    print('${widget.title} quantity: $_quantity');
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
    print('${widget.title} quantity: $_quantity');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
                child: Image.asset(
                  widget.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child:
                    _quantity == 0
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
                              border: Border.all(color: Colors.orange),
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                color: Colors.orange,
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
                            color: Colors.orange,
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
              // Placeholder for "10 kg" and "Wheat Atta"
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '10 kg', // This should ideally come from data
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        'Wheat Atta', // This should ideally come from data
                        style: TextStyle(color: Colors.white, fontSize: 10),
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
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.description,
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
                    ),
                    Text(
                      ' (${widget.reviews} Reviews)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 16),
                    Text(
                      widget.deliveryTime,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.mrp,
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

// A simple data model for the product
class Product {
  final String imageUrl;
  final String title;
  final String weight;
  final String category;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double price;
  final double mrp;

  Product({
    required this.imageUrl,
    required this.title,
    required this.weight,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.price,
    required this.mrp,
  });
}

// Dummy data list - replace with your actual data source
final List<Product> productList = [
  Product(
    imageUrl: GroceryImages.category1, // Placeholder image
    title: 'Aashirvaad 0% Maida, 100% M.P, Chakki Atta',
    weight: '10 kg',
    category: 'Wheat Atta',
    rating: 4.8,
    reviewCount: 15,
    deliveryTime: '15 Mins',
    price: 465,
    mrp: 666,
  ),
  Product(
    imageUrl: GroceryImages.category2, // Placeholder image
    title: 'Silver Star Basmati Rice - Premium Quality',
    weight: '10 kg',
    category: 'Basmati Rice',
    rating: 4.9,
    reviewCount: 22,
    deliveryTime: '15 Mins',
    price: 1250,
    mrp: 1500,
  ),
  Product(
    imageUrl: GroceryImages.category3, // Placeholder image
    title: 'The Good Life Organic Brown Rice',
    weight: '5 kg',
    category: 'Rice',
    rating: 4.7,
    reviewCount: 18,
    deliveryTime: '20 Mins',
    price: 550,
    mrp: 620,
  ),
  Product(
    imageUrl: GroceryImages.category1, // Placeholder image
    title: 'Silver Star Basmati Rice - Premium Quality',
    weight: '10 kg',
    category: 'Basmati Rice',
    rating: 4.9,
    reviewCount: 22,
    deliveryTime: '15 Mins',
    price: 1250,
    mrp: 1500,
  ),
];

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior:
          Clip.antiAlias, // Ensures content respects card's rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with ADD button overlay
          Stack(
            children: [
              Image.asset(
                product.imageUrl,
                height: 130, // Fixed height for the image container
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GroceryColorTheme().primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTag(product.weight),
                    const SizedBox(width: 4),
                    _buildTag(product.category),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating} (${product.reviewCount} Reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.green.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.deliveryTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'M.R.P: ₹${product.mrp.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.lineThrough,
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

  // Helper widget for the small tags
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
      ),
    );
  }
}
