part of 'view.dart';

class OrderDetailsPage extends StatelessWidget {
  final dynamic order;
  final HomeCubit homeCubit;

  const OrderDetailsPage({super.key, required this.order, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: OrderDetailsView(order: order),
    );
  }
}

class OrderDetailsView extends StatefulWidget {
  final dynamic order;
  
  const OrderDetailsView({super.key, required this.order});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  
  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderId = order.id?.toString();
    final orderIdDisplay = order.orderId?.toString();
    final totalAmount = order.totalAmount?.toString();
    final orderItems = order.items ?? [];
    final orderStatus = order.status?.toString();
    final createdAt = order.createdAt?.toString();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderId != null || orderIdDisplay != null)
                Text(
                  'Order #${orderIdDisplay ?? orderId ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              if (orderItems.isNotEmpty)
                Text(
                  '${orderItems.length} items',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Help functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.pink,
                size: 18,
              ),
              label: const Text(
                'Get Help',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Bill Summary Section - Only show if total amount is available
              if (totalAmount != null && totalAmount.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Total Bill - Only show actual data
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Bill',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Incl. all taxes and charges',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹$totalAmount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Download Invoice Button
                      BlocConsumer<HomeCubit, HomeState>(
                        listener: (context, state) {
                          // Handle order invoice API response
                          if (state.orderInvoiceApiState.apiCallState == APICallState.loaded) {
                            final invoiceModel = state.orderInvoiceApiState.model;
                            if (invoiceModel != null) {
                              // Reset order invoice state immediately before generating PDF
                              context.read<HomeCubit>().resetOrderInvoiceState();
                              context.read<HomeCubit>().generateInvoicePdf(invoiceModel);
                            }
                          } else if (state.orderInvoiceApiState.apiCallState == APICallState.failure) {
                            // Reset state and show error
                            context.read<HomeCubit>().resetOrderInvoiceState();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.orderInvoiceApiState.errorMessage ?? 'Failed to get invoice data'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          
                          // Handle PDF generation response
                          if (state.pdfGenerationApiState.apiCallState == APICallState.loaded) {
                            final filePath = state.pdfGenerationApiState.model;
                            if (filePath != null) {
                              // Reset state and show success
                              context.read<HomeCubit>().resetPdfGenerationState();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '✅ Invoice PDF Generated Successfully!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getDisplayPath(filePath),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 5),
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            }
                          } else if (state.pdfGenerationApiState.apiCallState == APICallState.failure) {
                            // Reset state and show error
                            context.read<HomeCubit>().resetPdfGenerationState();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.pdfGenerationApiState.errorMessage ?? 'Failed to generate PDF',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state.orderInvoiceApiState.apiCallState == APICallState.loading ||
                                          state.pdfGenerationApiState.apiCallState == APICallState.loading;
                          
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : () {
                                _handleDownloadInvoice();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8D7FF),
                                foregroundColor: const Color(0xFF8B5CF6),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          state.orderInvoiceApiState.apiCallState == APICallState.loading 
                                              ? 'Fetching Invoice...'
                                              : 'Generating PDF...',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Download Invoice / Credit Note',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Order Details Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Delivery Address - Only show if available
                    if (order.deliveryAddress != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (order.deliveryAddress!.name != null)
                                  Text(
                                    order.deliveryAddress!.name!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    order.deliveryAddress!.addressLine1,
                                    order.deliveryAddress!.addressLine2,
                                    order.deliveryAddress!.city,
                                    order.deliveryAddress!.state,
                                    order.deliveryAddress!.country,
                                    order.deliveryAddress!.pincode,
                                  ].where((element) => element != null && element.isNotEmpty).join(', '),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (order.deliveryAddress!.phone != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phone: ${order.deliveryAddress!.phone}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Order ID - Only show if available
                    if (orderId != null || orderIdDisplay != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order ID',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '#${orderIdDisplay ?? orderId}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final orderIdText = orderIdDisplay ?? orderId ?? '';
                                  if (orderIdText.isNotEmpty) {
                                    Clipboard.setData(ClipboardData(text: orderIdText));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Order ID copied to clipboard'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Order Status - Only show if available
                    if (orderStatus != null && orderStatus.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            orderStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Order Created Date - Only show if available
                    if (createdAt != null && createdAt.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Placed at',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            createdAt,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Need Help Section
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help feature coming soon!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.pink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Need help with this order?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Find your issue or reach out via chat',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 100), // Space for bottom buttons
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Row(
              children: [
                // Rate Order Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pushPage(RateOrderPage(order: widget.order, homeCubit: context.read<HomeCubit>()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pink, width: 1.5),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Rate Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Order Again Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleReorder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Order Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
      
     
  }







  // Handle download invoice with permission check first
  Future<void> _handleDownloadInvoice() async {
    final orderId = widget.order.id?.toString();
    final orderIdInt = int.tryParse(orderId ?? '0') ?? 0;
    
    if (orderIdInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid order ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check permissions first on Android
    if (Platform.isAndroid) {
      try {
        var storageStatus = await Permission.storage.status;
        var manageStorageStatus = await Permission.manageExternalStorage.status;
        
        // Request storage permission if not granted
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            // open app settings if permission is permanently denied
            if (storageStatus.isPermanentlyDenied) {
              await openAppSettings();
            }
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Storage permission is required to save PDF files'),
            //     backgroundColor: Colors.red,
            //     duration: Duration(seconds: 4),
            //   ),
            // );
            return;
          }
        }
        
        // For Android 11+, request manage external storage permission
        if (!manageStorageStatus.isGranted) {
          manageStorageStatus = await Permission.manageExternalStorage.request();
          // Continue even if this permission is not granted as we have fallback options
        }
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Reset all states before proceeding
    if (mounted) {
      context.read<HomeCubit>().resetAllInvoiceStates();
      context.read<HomeCubit>().getOrderInvoice(orderIdInt);
    }
  }

  void _handleReorder() {
    // Add all order items to cart
    final orderItems = widget.order.items ?? [];
    
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
          // No attributes needed for reordering - will use default values
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

  // Helper method to format file path for display
  String _getDisplayPath(String filePath) {
    if (filePath.contains('/storage/emulated/0/Download')) {
      final fileName = filePath.split('/').last;
      return 'Downloads/$fileName';
    } else if (filePath.contains('/storage/emulated/0/Downloads')) {
      final fileName = filePath.split('/').last;
      return 'Downloads/$fileName';
    } else if (filePath.contains('Downloads')) {
      // If it contains Downloads somewhere in the path
      final parts = filePath.split('/');
      final downloadsIndex = parts.indexWhere((part) => part == 'Downloads');
      if (downloadsIndex >= 0 && downloadsIndex < parts.length - 1) {
        return 'Downloads/${parts.last}';
      }
    }
    
    // Fallback: show last two directories and file name
    final parts = filePath.split('/');
    if (parts.length >= 2) {
      return '.../${parts[parts.length - 2]}/${parts.last}';
    }
    
    return filePath;
  }
}