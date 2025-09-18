part of 'view.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderView();
  }
}

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: GroceryColorTheme().offWhiteColor,
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Order Again',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body:  Column(
        children: [
          // Tab/Button Section for Active/Previous Orders
          SizedBox(height: 10),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   color: GroceryColorTheme().white,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               _showActiveOrders = true;
          //             });
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //             decoration: BoxDecoration(
          //               color:
          //                   _showActiveOrders
          //                       ? GroceryColorTheme().primary
          //                       : Colors.transparent,
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                 color:
          //                     _showActiveOrders
          //                         ? Colors.transparent
          //                         : Colors.white.withOpacity(0.5),
          //                 width: 1,
          //               ),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 'Active orders',
          //                 style: TextStyle(
          //                   color:
          //                       _showActiveOrders
          //                           ? Colors.black
          //                           : Colors.black54,
          //                   fontWeight: FontWeight.w600,
          //                   fontSize: 14,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               _showActiveOrders = false;
          //             });
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //             decoration: BoxDecoration(
          //               color:
          //                   !_showActiveOrders
          //                       ? GroceryColorTheme().primary
          //                       : Colors.transparent,
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                 color:
          //                     !_showActiveOrders
          //                         ? Colors.transparent
          //                         : Colors.white.withOpacity(0.5),
          //                 width: 1,
          //               ),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 'Previous order',
          //                 style: TextStyle(
          //                   color:
          //                       !_showActiveOrders
          //                           ? Colors.black
          //                           : Colors.black54,
          //                   fontWeight: FontWeight.w600,
          //                   fontSize: 14,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // // List of Orders
        
        
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 5, // Example: 5 orders
              itemBuilder: (context, index) {
                // You can customize order data based on _showActiveOrders
                return _buildOrderItem(
                  context,
                  orderNumber: '#7226',
                  date: '6 Jun 2025, 05:43 PM',
                  items: ['Black currant berries'],
                  totalPay: '₹465.07',
                  status: 'Cancelled', // Example status
                );
              },
            ),
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
              if (product?.images != null && product!.images!.isNotEmpty) {
                try {
                  // Parse images from JSON string if needed
                  final imageData = product.images!;
                  if (imageData.startsWith('[') && imageData.endsWith(']')) {
                    // It's a JSON array string, extract first image
                    final cleanedData = imageData.substring(1, imageData.length - 1);
                    final firstImage = cleanedData.split(',')[0].replaceAll('"', '').trim();
                    if (firstImage.isNotEmpty) {
                      productImages.add(firstImage);
                    }
                  } else {
                    // It's a single image URL
                    productImages.add(imageData);
                  }
                } catch (e) {
                  // If parsing fails, use default image
                  productImages.add(GroceryImages.category2);
                }
              } else {
                // Use default image if no product image
                productImages.add(GroceryImages.category2);
              }
            }
            
            // Ensure we have at least one image
            if (productImages.isEmpty) {
              productImages.add(GroceryImages.category2);
            }
            
            return FloatingActionButton.extended(
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

  // Helper method to build an individual order item card
  Widget _buildOrderItem(
    BuildContext context, {
    required String orderNumber,
    required String date,
    required List<String> items,
    required String totalPay,
    String? status,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: GroceryColorTheme().white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order $orderNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: GroceryColorTheme().white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red, width: 0.8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            // Display items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            '• $item',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total pay',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalPay,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4CAF50), // Green color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
