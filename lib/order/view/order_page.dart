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
  initState() {
    super.initState();
    context.read<HomeCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GroceryColorTheme().primary,
        automaticallyImplyLeading: false,
      centerTitle: true,
        title: const Text(
          'Your Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.ordersApiState != current.ordersApiState,
        builder: (context, state) {
          final apiState = state.ordersApiState;

            if (apiState.apiCallState == APICallState.loading) {
            return SliverFillRemaining(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CircularProgressIndicator(
                  color: GroceryColorTheme().primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading your orders...',
                  style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  ),
                ),
                ],
              ),
              ),
            );
            }
            
            if (apiState.apiCallState == APICallState.failure) {
            return SliverFillRemaining(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load orders',
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  apiState.errorMessage ?? 'Something went wrong',
                  style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                  context.read<HomeCubit>().getOrders();
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: GroceryColorTheme().primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.black),
                  ),
                ),
                ],
              ),
              ),
            );
            }
            
            final orders = apiState.model?.orders ?? [];
            
            if (orders.isEmpty) {
            return SliverFillRemaining(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  'No orders yet',
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'When you place orders, they\'ll appear here',
                  style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                  // Navigate to home to start shopping
                  //context.read<NavBarCubit>().getNavBarItem(NavBarItem.home);
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: GroceryColorTheme().primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: const Text(
                  'Start Shopping',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                ],
              ),
              ),
            );
            }
            
            return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
            );
          },
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

  // Order card matching the design from the image
  Widget _buildOrderCard(BuildContext context, dynamic order) {
    // Parse order data - only use actual data, no dummy values
    final orderDate = order.createdAt;
    final orderStatus = order.status;
    final totalAmount = order.totalAmount?.toString();
    final orderItems = order.items ?? [];
    
    return GestureDetector(
      onTap: () {
       context.pushPage(OrderDetailsPage(order: order, homeCubit: context.read<HomeCubit>()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order status header with checkmark
          Row(
            children: [
              if (orderStatus != null && orderStatus.isNotEmpty) ...[
                Text(
                  'Order ${orderStatus.toLowerCase()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                if (orderStatus.toLowerCase() == 'delivered' || orderStatus.toLowerCase() == 'completed')
                  Container(
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
              ],
              const Spacer(),
              if (totalAmount != null && totalAmount.isNotEmpty)
                Text(
                  '₹$totalAmount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'details') {
                    context.pushPage(OrderDetailsPage(order: order, homeCubit: context.read<HomeCubit>()));
      
                  } else if (value == 'rate') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rating feature coming soon!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 12),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'rate',
                    child: Row(
                      children: [
                        Icon(Icons.star_rate, size: 20),
                        SizedBox(width: 12),
                        Text('Rate Us'),
                      ],
                    ),
                  ),
                ],
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          if (orderStatus != null || totalAmount != null || orderDate != null)
            const SizedBox(height: 8),
          
          // Order date - only show if available
          if (orderDate != null && orderDate.isNotEmpty) ...[
            Text(
              'Placed at ${_formatOrderDate(orderDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Product images row
          if (orderItems.isNotEmpty)
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderItems.length > 5 ? 5 : orderItems.length,
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  final imageUrl = item.image ?? '';
                  
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl.startsWith('https')
                                  ? imageUrl
                                  : '${GroceryApis.baseUrl}/$imageUrl',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[100],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 24,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Action buttons row
          Row(
            children: [
              // Rate Order button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rating feature coming soon!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Rate Order',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Order Again button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _handleReorder(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GroceryColorTheme().primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Order Again',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  // Helper method to format order date exactly like in the image
  String _formatOrderDate(String dateString) {
    try {
      // Parse the date string - assuming it's in format like "24-09-2025 12:51"
      final parts = dateString.split(' ');
      if (parts.length >= 2) {
        final datePart = parts[0];
        final timePart = parts[1];
        final dateParts = datePart.split('-');
        
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          
          // Format: "19th Sep 2025, 06:34 am"
          final monthNames = [
            '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          
          final dayWithSuffix = _getDayWithSuffix(day);
          final monthName = monthNames[month];
          
          // Convert 24-hour time to 12-hour with am/pm
          final timeFormatted = _formatTime(timePart);
          
          return '$dayWithSuffix $monthName $year, $timeFormatted';
        }
      }
      
      // Fallback to original format if parsing fails
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
  
  String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
  
  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        final minute = parts[1];
        
        String period = 'am';
        if (hour >= 12) {
          period = 'pm';
          if (hour > 12) {
            hour = hour - 12;
          }
        }
        if (hour == 0) {
          hour = 12;
        }
        
        return '$hour:$minute $period';
      }
      return time24;
    } catch (e) {
      return time24;
    }
  }
  
  void _handleReorder(dynamic order) {
    final orderItems = order.items ?? [];
    
    if (orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items found in this order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder Items'),
        content: Text('Add ${orderItems.length} item${orderItems.length != 1 ? 's' : ''} from this order to your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addItemsToCart(orderItems);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            child: const Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  void _addItemsToCart(List<dynamic> orderItems) {
    // Add each item to cart using the HomeCubit
    for (final item in orderItems) {
      final productId = item.productId;
      final quantity = item.quantity ?? 1;
      
      if (productId != null) {
        context.read<HomeCubit>().addToCart(
          productId: productId,
          quantity: quantity,
        );
      }
      // in last call getCartItems to refresh the cart state
      if (item == orderItems.last) {
        context.read<HomeCubit>().getCartItems();
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${orderItems.length} item${orderItems.length != 1 ? 's' : ''} added to cart!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            context.pushPage(CheckoutPage(
              homeCubit: context.read<HomeCubit>(),
            ));
          },
        ),
      ),
    );
  }
}
