part of 'view.dart';

class CheckoutPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const CheckoutPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: CheckoutView(),
    );
  }
}

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final List<Map<String, dynamic>> _checkoutItems = [
    {
      'imageUrl': GroceryImages.ration1,
      'title': 'Aashirvaad 0% Maida,',
      'description': '10 Kg',
      'deliveryTime': '14 minutes',
      'saveForLaterText': 'Save for later',
      'weight': '10 kg',
      'quantity': 2,
      'price': '465',
      'mrpPrice': '550',
    },
    {
      'imageUrl': GroceryImages.ration2,
      'title': 'Aashirvaad 0% Maida,',
      'description': '10 Kg',
      'deliveryTime': '14 minutes',
      'saveForLaterText': 'Save for later',
      'weight': '10 kg',
      'quantity': 1,
      'price': '320',
      'mrpPrice': '400',
    },
  ];

  void _incrementQuantity(int id,int quantity) {
    context.read<HomeCubit>().updateCartItem(
      cartItemId: id,
      quantity: quantity + 1, 
    );
  }

  void _decrementQuantity(int id,int quantity) {
    if(quantity > 1) {
      context.read<HomeCubit>().updateCartItem(
        cartItemId: id,
        quantity: quantity - 1, 
      );
    }
    else if (quantity == 1) {
      context.read<HomeCubit>().deleteCartItem(cartItemId: id);
    }
   
   
  }
  void _removeItem(int id) {
   context.read<HomeCubit>().deleteCartItem(cartItemId: id);
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if(state.clearCartApiState.apiCallState == APICallState.loaded) {
        context.showSnacbar('Cart cleared successfully');
        context.read<HomeCubit>().getCartItems();
        } else if(state.clearCartApiState.apiCallState == APICallState.failure) {
        context.showSnacbar(state.clearCartApiState.errorMessage ?? 'Failed to clear cart',backgroundColor: GroceryColorTheme().redColor);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GroceryColorTheme().primary,
          title: Text(
            'Checkout',
            style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            TextButton(
            child: Text('Clear All',
            style: GroceryTextTheme().bodyText.copyWith(
              fontSize: 14,
              color: GroceryColorTheme().black, 
              decoration: TextDecoration.underline,
              ),
              ),
              onPressed: () {
                context.read<HomeCubit>().clearCart();
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
                     BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                       previous.getCartItemsApiState != current.getCartItemsApiState||
                       previous.addToCartApiState != current.addToCartApiState||
                       previous.clearCartApiState != current.clearCartApiState||
                       previous.deleteCartItemApiState != current.deleteCartItemApiState||
                       previous.updateCartItemApiState != current.updateCartItemApiState,
                       builder: (context, state) {
                        final cartItems = state.getCartItemsApiState.model?.data ?? [];
                        
                        
                         return ListView.builder(
                           shrinkWrap: true, // Takes only the space it needs
                           physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                           itemCount: cartItems.length,
                           itemBuilder: (context, index) {
                             final item = cartItems[index];
                             
                             return CheckoutProductCard(
                                    imageUrl: item.product?.images != null && item.product!.images!.startsWith('[') && item.product!.images!.endsWith(']')
                                      ? item.product!.images!.substring(1, item.product!.images!.length - 1).split(',')[0].replaceAll('"', '').trim()
                                      : (item.product?.images ?? ''),
                                    title: item.product?.name??'',
                                    description: item.product?.description??'',
                                    deliveryTime: '14 minutes',
                                    quantity: item.quantity??0,
                                    price: item.product?.salePrice??'',
                                    mrpPrice: item.product?.mrpPrice??'',
                                    onIncrement: () => _incrementQuantity(item.id??0,item.quantity??0), 
                                    onDecrement: () => _decrementQuantity(item.id??0,item.quantity??0),
                                    onRemove: () => _removeItem(item.id??0),
                                  );
                           },
                         );
                       }
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

class CheckoutProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String deliveryTime; // e.g., "14 minutes"
  final int quantity;
  final String price;
  final String mrpPrice;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onRemove;

  const CheckoutProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.deliveryTime,
    required this.quantity,
    required this.price,
    required this.mrpPrice,
    required this.onIncrement,
    required this.onDecrement,
    this.onRemove,
  });

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
                    'Free delivery in $deliveryTime', // Using deliveryTime for "14 minutes"
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Shipment of $quantity item${quantity > 1 ? 's' : ''}', // Dynamic shipment count
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
                child: 
                   Image.network(
                        imageUrl.startsWith('http') ? imageUrl : '${GroceryApis.baseUrl}/$imageUrl',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported),
                        ),
                      )
                    
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹$price',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                       
                      ],
                    ),
                     Text(
                          '₹$mrpPrice',
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: onRemove,
                      child: Text(
                        'Remove Item',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
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
                      onTap: onDecrement,
                      child: const Icon(
                        Icons.remove,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onIncrement,
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

  const _ProductCard({required this.product});

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
