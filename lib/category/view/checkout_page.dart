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
  // Remove dummy data - will use cart data from API
  Razorpay? _razorpay;
  bool _isGSTSelected = false; // State for GST checkbox

  bool _isCheckoutEnabled() {
    final state = context.read<HomeCubit>().state;
    final cartItems = state.getCartItemsApiState.model?.data ?? [];
    print('Checkout validation - deliveryDate: ${state.selectedDeliveryDateIndex}, timeSlot: ${state.selectedTimeSlotIndex}, address: ${state.selectedAddress}, cartItems: ${cartItems.length}'); // Debug print
    return state.selectedDeliveryDateIndex >= 0 &&
           state.selectedTimeSlotIndex >= 0 &&
           state.selectedAddress != null &&
           cartItems.isNotEmpty;
  }

  void _handleCheckout() async {
    final homeCubit = context.read<HomeCubit>();
    final state = homeCubit.state;
    
    if (!_isCheckoutEnabled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select delivery date, time slot, and address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get cart items from API state
    final cartItems = state.getCartItemsApiState.model?.data ?? [];
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare cart items for checkout API
    print('Cart items from API: ${cartItems.length}'); // Debug print
    final checkoutCartItems = cartItems.map((cartItem) {
      final productId = cartItem.productId ?? 0;
      final quantity = cartItem.quantity ?? 1;
      
      return home_models.CheckoutCartItem(
        productId: productId,
        quantity: quantity,
      );
    }).toList();
    print('Checkout cart items prepared: ${checkoutCartItems.length}'); // Debug print

    try {
      // Call checkout API to get order ID
      await homeCubit.checkout(
        addressId: state.selectedAddress!.id!,
        paymentMethod: 'rzp', // Always use online payment (Razorpay)
        cart: checkoutCartItems,
      );
      
      final checkoutState = homeCubit.state;
      if (checkoutState.checkoutApiState.apiCallState == APICallState.loaded && 
          checkoutState.checkoutApiState.model != null) {
        
        // Get order ID and amount from checkout response
        final checkoutResponse = checkoutState.checkoutApiState.model!;
        final orderId = checkoutResponse.razorpayOrderId;
        final amount = checkoutResponse.amount;
        
        if (orderId != null && amount != null) {
          // Open Razorpay payment sheet
          _openRazorpayPayment(orderId, amount, checkoutResponse);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get payment details from server'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (checkoutState.checkoutApiState.apiCallState == APICallState.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(checkoutState.checkoutApiState.errorMessage ?? 'Checkout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openRazorpayPayment(String orderId, double amount, home_models.CheckoutResponse checkoutResponse) {
    // Get user details from cubit
    final userState = context.read<AppCubit>().state.user;
    final customerName = userState.customer?.name ?? 'Customer';
    final customerEmail = userState.customer?.email ?? '';
    final customerContact = userState.customer?.phone ?? '';
    
    // For now, use a default key since razorpayKey is null in the response
    // You should get this from your backend or environment variables
    const String razorpayKey = 'rzp_test_hOZCibf5Ibk62K'; // Replace with your actual key
    
    var options = {
      'key': razorpayKey,
      'amount': (amount * 100).toInt(), // amount in the smallest currency unit (paise)
      'name': 'Monthly Ration',
      'order_id': orderId,
      'description': 'Order Payment',
      'prefill': {
        'contact': customerContact,
        'email': customerEmail,
        'name': customerName,
      },
      'theme': {
        'color': '#FECC00' // Your app's primary color
      }
    };

    try {
      if (_razorpay != null) {
        _razorpay!.open(options);
      } else {
        throw Exception('Razorpay not initialized');
      }
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening payment gateway: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Verify payment with backend
    final homeCubit = context.read<HomeCubit>();
    
    homeCubit.verifyPayment(
      razorpayPaymentId: response.paymentId!,
      razorpayOrderId: response.orderId!,
      razorpaySignature: response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showOrderSuccessDialog(home_models.CheckoutResponse checkoutResponse) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(context, checkoutResponse),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, home_models.CheckoutResponse checkoutResponse) {
    return Stack(
      children: [
        // 🎯 Dialog content
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon with circular background
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade50,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Success message
                Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: GroceryTextTheme().boldText.copyWith(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Order details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${checkoutResponse.orderId ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '₹${(checkoutResponse.amount ?? 0) / 100}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Method:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.payment,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Razorpay',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Success message
                Text(
                  'Thank you for your order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Continue shopping button
                CustomElevatedButton(
                  backgrondColor: GroceryColorTheme().primary,
                  width: double.infinity,
                  onPressed: () {
                    context.pushAndRemoveUntilPage(const RootPage());
                  },
                  buttonText: Text(
                    "Continue Shopping",
                    style: GroceryTextTheme().boldText.copyWith(
                      fontSize: 14,
                      color: GroceryColorTheme().black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🎉 Lottie animation on top, but doesn't block taps
        IgnorePointer(
          child: Container(
            color: Colors.transparent,
            child: Lottie.asset(
              GroceryImages.partyLottie,
              repeat: false,
              animate: true,
              reverse: false,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print('Lottie error: $error');
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.celebration,
                      size: 120,
                      color: Colors.amber,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Default payment method selection and helper methods

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
    context.read<AuthCubit>().getAddress();
    
    // Get shipping and handling fees
    context.read<HomeCubit>().getShippingFee();
    context.read<HomeCubit>().getHandlingFee();
    context.read<HomeCubit>().getTimeSlots();
    
    // Initialize Razorpay
    try {
      _razorpay = Razorpay();
      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      debugPrint('Error initializing Razorpay: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _razorpay?.clear();
    } catch (e) {
      debugPrint('Error disposing Razorpay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // Handle cart operations
        if(state.clearCartApiState.apiCallState == APICallState.loaded) {
          context.showSnacbar('Cart cleared successfully');
          context.read<HomeCubit>().getCartItems();
        } else if(state.clearCartApiState.apiCallState == APICallState.failure) {
          context.showSnacbar(state.clearCartApiState.errorMessage ?? 'Failed to clear cart',backgroundColor: GroceryColorTheme().redColor);
        }
        
        // Handle shipping fee API errors
        if(state.shippingApiState.apiCallState == APICallState.failure) {
          debugPrint('Shipping fee API error: ${state.shippingApiState.errorMessage}');
        }
        
        // Handle handling fee API errors
        if(state.handlingApiState.apiCallState == APICallState.failure) {
          debugPrint('Handling fee API error: ${state.handlingApiState.errorMessage}');
        }
        
        // Handle payment verification
        if(state.paymentVerifyApiState.apiCallState == APICallState.loaded && state.paymentVerifyApiState.model != null) {
          // Payment verification successful
          final checkoutResponse = state.checkoutApiState.model;
          if (checkoutResponse != null) {
            _showOrderSuccessDialog(checkoutResponse);
            // Clear checkout state after showing dialog
            context.read<HomeCubit>().resetCheckoutState();
          }
        } else if(state.paymentVerifyApiState.apiCallState == APICallState.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.paymentVerifyApiState.errorMessage ?? 'Payment verification failed. Please contact support.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            // Custom gradient app bar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    GroceryColorTheme().primary,
                    GroceryColorTheme().primary.withOpacity(0.8),
                    GroceryColorTheme().primary.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Title section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Review your order',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Clear all button
                      GestureDetector(
                        onTap: () {
                          context.read<HomeCubit>().clearCart();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.black,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Clear All',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Body content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        
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
                          // show loading indicator while fetching cart items
                          if (state.getCartItemsApiState.apiCallState == APICallState.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                           return ListView.builder(
                             shrinkWrap: true, // Takes only the space it needs
                             physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                             itemCount: cartItems.length,
                             itemBuilder: (context, index) {
                               final item = cartItems[index];
                               
                               return CheckoutProductCard(
                                      imageUrl: item.product?.imagesUrls != null && item.product!.imagesUrls.isNotEmpty
                                        ? item.product!.imagesUrls.first
                                        : '',
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
        
                        // // You might also like section
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Text(
                        //     'You might also like',
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey[800],
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12),
        
                        // GridView.builder(
                        //   shrinkWrap: true, // Important for nested scrolling
                        //   physics:
                        //       const NeverScrollableScrollPhysics(), // Important for nested scrolling
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 2, // Number of columns
                        //         crossAxisSpacing:
                        //             6.0, // Horizontal space between cards
                        //         mainAxisSpacing:
                        //             6.0, // Vertical space between cards
                        //         childAspectRatio:
                        //             0.5, // Adjust this ratio for card height
                        //       ),
                        //   itemCount: productList.length,
                        //   itemBuilder: (context, index) {
                        //     return _ProductCard(product: productList[index]);
                        //   },
                        // ),
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
                        _buildDeliveryDateSection(),
                        const SizedBox(height: 16),
                        _buildTimeSlotSection(),
                        const SizedBox(height: 16),
                        _buildAddressSection(),
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
                                    BlocBuilder<HomeCubit, HomeState>(
                                      buildWhen: (previous, current) =>
                                          previous.applyCouponApiState != current.applyCouponApiState,
                                      builder: (context, state) {
                                        final isApplied = state.applyCouponApiState.apiCallState == APICallState.loaded &&
                                                         state.applyCouponApiState.model != null &&
                                                         state.applyCouponApiState.model!.success == true;

                                        if (isApplied) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Coupon Applied: ${state.applyCouponApiState.model!.coupon}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(
                                                'You saved ₹${state.applyCouponApiState.model!.discount}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
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
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<HomeCubit, HomeState>(
                                buildWhen: (previous, current) =>
                                    previous.applyCouponApiState != current.applyCouponApiState,
                                builder: (context, state) {
                                  final isApplied = state.applyCouponApiState.apiCallState == APICallState.loaded &&
                                                   state.applyCouponApiState.model != null &&
                                                   state.applyCouponApiState.model!.success == true;

                                  // Hide the button if coupon is applied
                                  if (isApplied) {
                                    return const SizedBox.shrink();
                                  }

                                  return TextButton(
                                    onPressed: () {
                                      context.pushPage(FreeCouponPage(
                                        homeCubit: context.read<HomeCubit>(),
                                      ));
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Coupon Section
                       // _buildCouponSection(),
                        const SizedBox(height: 24),
        
                        // Bill Details
                        BlocBuilder<HomeCubit, HomeState>(
                          buildWhen: (previous, current) =>
                              previous.getCartItemsApiState != current.getCartItemsApiState ||
                              previous.updateCartItemApiState != current.updateCartItemApiState ||
                              previous.deleteCartItemApiState != current.deleteCartItemApiState ||
                              previous.shippingApiState != current.shippingApiState ||
                              previous.handlingApiState != current.handlingApiState ||
                              previous.applyCouponApiState != current.applyCouponApiState,
                          builder: (context, state) {
                            final cartItems = state.getCartItemsApiState.model?.data ?? [];
                            
                            // Calculate totals
                            double itemsTotal = 0;
                            double mrpTotal = 0;
                            
                            for (var cartItem in cartItems) {
                              final product = cartItem.product;
                              if (product != null && cartItem.quantity != null) {
                                final salePrice = double.tryParse(product.salePrice?.toString() ?? '0') ?? 0;
                                final mrpPrice = double.tryParse(product.mrpPrice ?? '0') ?? 0;
                                final quantity = cartItem.quantity!;
                                
                                itemsTotal += salePrice * quantity;
                                mrpTotal += mrpPrice * quantity;
                              }
                            }
                            
                            // Get shipping fee from API
                            double deliveryCharge = 0.0;
                            final shippingModel = state.shippingApiState.model;
                            if (shippingModel?.data != null) {
                              final shippingApplicableAmount = shippingModel!.data!.shiipingApplicableAmount ?? 0;
                              final shippingAmount = shippingModel.data!.shippingAmount ?? 0;
                              
                              // Apply shipping charge if items total is less than applicable amount
                              if (itemsTotal < shippingApplicableAmount) {
                                deliveryCharge = shippingAmount.toDouble();
                              }
                            }
                            
                            // Get handling fee from API
                            double handlingCharge = 0.0;
                            final handlingModel = state.handlingApiState.model;
                            if (handlingModel?.data != null) {
                              final handlingApplicableAmount = handlingModel!.data!.handlingApplicableAmount ?? 0;
                              final handlingAmount = handlingModel.data!.handlingAmount ?? 0;
                              
                              // Apply handling charge if items total is less than applicable amount
                              if (itemsTotal < handlingApplicableAmount) {
                                handlingCharge = handlingAmount.toDouble();
                              }
                            }
                            
                            final savings = mrpTotal - itemsTotal;
                            
                            // Get coupon discount
                            double couponDiscount = 0.0;
                            if (state.applyCouponApiState.apiCallState == APICallState.loaded &&
                                state.applyCouponApiState.model != null &&
                                state.applyCouponApiState.model!.success == true) {
                              couponDiscount = (state.applyCouponApiState.model!.discount ?? 0).toDouble();
                            }
                            
                            final grandTotal = itemsTotal + deliveryCharge + handlingCharge - couponDiscount;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                _buildBillDetailRow(
                                  'Items total', 
                                  '₹${itemsTotal.toStringAsFixed(0)}', 
                                  isBold: false
                                ),
                                if (savings > 0)
                                  _buildBillDetailRow(
                                    'You saved', 
                                    '₹${savings.toStringAsFixed(0)}', 
                                    isBold: false,
                                    valueColor: Colors.green,
                                  ),
                                _buildBillDetailRow(
                                  'Delivery charge',
                                  state.shippingApiState.apiCallState == APICallState.loading
                                      ? 'Loading...'
                                      : (deliveryCharge == 0 ? 'FREE' : '₹${deliveryCharge.toStringAsFixed(0)}'),
                                  isBold: false,
                                  valueColor: deliveryCharge == 0 ? Colors.green : null,
                                ),
                                _buildBillDetailRow(
                                  'Handling charge',
                                  state.handlingApiState.apiCallState == APICallState.loading
                                      ? 'Loading...'
                                      : (handlingCharge == 0 ? 'FREE' : '₹${handlingCharge.toStringAsFixed(0)}'),
                                  isBold: false,
                                  valueColor: handlingCharge == 0 ? Colors.green : null,
                                ),
                                // Show discount if coupon is applied
                                if (state.applyCouponApiState.apiCallState == APICallState.loaded &&
                                    state.applyCouponApiState.model != null &&
                                    state.applyCouponApiState.model!.success == true &&
                                    (state.applyCouponApiState.model!.discount ?? 0) > 0)
                                  _buildBillDetailRow(
                                    'Coupon discount',
                                    '-₹${state.applyCouponApiState.model!.discount}',
                                    isBold: false,
                                    valueColor: Colors.green,
                                  ),
                                const Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  height: 20,
                                  thickness: 1,
                                ),
                                _buildBillDetailRow(
                                  'Grand total', 
                                  (state.shippingApiState.apiCallState == APICallState.loading ||
                                   state.handlingApiState.apiCallState == APICallState.loading)
                                      ? 'Calculating...'
                                      : '₹${grandTotal.toStringAsFixed(0)}', 
                                  isBold: true
                                ),
                              ],
                            );
                          },
                        ),
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
                                value: _isGSTSelected,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isGSTSelected = newValue ?? false;
                                  });
                                },
                                activeColor: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        
                        // GST Details Section (shown when GST is selected)
                        if (_isGSTSelected) ...[
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Colors.orange.shade200, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.business,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'GST Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Company Name Field
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Company Name *',
                                    labelStyle: TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Colors.orange),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // GST Number Field
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'GST Number *',
                                    labelStyle: TextStyle(color: Colors.grey[600]),
                                    hintText: 'Enter 15-digit GST number',
                                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Colors.orange),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  maxLength: 15,
                                  textCapitalization: TextCapitalization.characters,
                                ),
                                const SizedBox(height: 8),
                                
                                // Info text
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'GST will be calculated and added to your bill. You will receive a GST invoice for this order.',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        SizedBox(height: 10),
                        CustomElevatedButton(
                          backgrondColor: GroceryColorTheme().primary,
                          width: double.infinity,
                          onPressed:  () => _handleCheckout() ,
                          buttonText: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state.checkoutApiState.apiCallState == APICallState.loading) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: GroceryColorTheme().black,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Processing...",
                                      style: GroceryTextTheme().bodyText.copyWith(
                                        fontSize: 14,
                                        color: GroceryColorTheme().black, 
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 6,
                                children: [
                                  Text(
                                    "Checkout",
                                    style: GroceryTextTheme().bodyText.copyWith(
                                      fontSize: 14,
                                      color: GroceryColorTheme().black, 
                                    ),
                                  ),
                                ],
                              );
                            },
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
      ],
    ),
  ),
);
  }

  Widget _buildDeliveryDateSection() {
    // Generate next 10 days starting from today
    final List<DateTime> deliveryDates = List.generate(10, (index) {
      return DateTime.now().add(Duration(days: index));
    });

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedDeliveryDateIndex != current.selectedDeliveryDateIndex,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferred Delivery Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deliveryDates.length,
                itemBuilder: (context, index) {
                  final date = deliveryDates[index];
                  final isSelected = state.selectedDeliveryDateIndex == index;
                  return GestureDetector(
                    onTap: () {
                      context.read<HomeCubit>().setSelectedDeliveryDateIndex(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                              color:
                                  isSelected
                                      ? Colors.green.shade800
                                      : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.green.shade800 : Colors.black,
                            ),
                          ),
                          Text(
                            _getMonthName(date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                              color:
                                  isSelected
                                      ? Colors.green.shade800
                                      : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeSlotSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedTimeSlotIndex != current.selectedTimeSlotIndex ||
          previous.timeSlotsApiState != current.timeSlotsApiState,
      builder: (context, state) {
        final timeSlotsApiState = state.timeSlotsApiState;
        final timeSlots = timeSlotsApiState.model ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferred Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (timeSlotsApiState.apiCallState == APICallState.loading)
              Container(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: GroceryColorTheme().primary,
                  ),
                ),
              )
            else if (timeSlotsApiState.apiCallState == APICallState.failure)
              Container(
                height: 50,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to load time slots: ${timeSlotsApiState.errorMessage ?? 'Unknown error'}',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.read<HomeCubit>().getTimeSlots(),
                      child: Text('Retry', style: TextStyle(color: Colors.red.shade700)),
                    ),
                  ],
                ),
              )
            else if (timeSlots.isEmpty)
              Container(
                height: 50,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No time slots available',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final timeSlot = timeSlots[index];
                    final isSelected = state.selectedTimeSlotIndex == index;
                    String displayText = '';
                    if (timeSlot.slot != null && timeSlot.slot!.isNotEmpty) {
                      displayText = timeSlot.slot!;
                    } else {
                      displayText = 'Time Slot ${index + 1}';
                    }
                    return GestureDetector(
                      onTap: () {
                        context.read<HomeCubit>().setSelectedTimeSlotIndex(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            displayText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green.shade800 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        ]
        );
      },
    );
  }

  String _getDayName(DateTime date) {
    const List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayNames[date.weekday - 1];
  }

  String _getMonthName(DateTime date) {
    const List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[date.month - 1];
  }

  Widget _buildAddressSection() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.getAddressApiState != current.getAddressApiState,
      builder: (context, authState) {
        return BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.selectedAddress != current.selectedAddress,
          builder: (context, homeState) {
            final addressApiState = authState.getAddressApiState;
            final addresses = addressApiState.model?.data ?? [];
            final selectedAddress = homeState.selectedAddress;
            
            // Find default address if no address is selected
            Address? displayAddress = selectedAddress;
            if (displayAddress == null && addresses.isNotEmpty) {
              displayAddress = addresses.firstWhere(
                (address) => address.isDefault == 1,
                orElse: () => addresses.first,
              );
              // Set the default/first address as selected
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<HomeCubit>().setSelectedAddress(displayAddress);
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: addressApiState.apiCallState == APICallState.loading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : addresses.isEmpty
                          ? _buildNoAddressWidget(context)
                          : displayAddress != null
                              ? _buildAddressWidget(context, displayAddress, addresses)
                              : _buildSelectAddressWidget(context, addresses),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNoAddressWidget(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.location_off,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Text(
          'No delivery address found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please add a delivery address to continue',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            context.pushPage(AddressPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: GroceryColorTheme().primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Add Address',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectAddressWidget(BuildContext context, List<Address> addresses) {
    return Column(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Text(
          'Select a delivery address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose from your saved addresses',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _showAddressBottomSheet(context, addresses);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: GroceryColorTheme().primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Select Address',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressWidget(BuildContext context, Address address, List<Address> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address.name ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (address.isDefault == 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${address.addressLine1 ?? ''}'
          '${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}'
          '${address.city != null ? ', ${address.city}' : ''}'
          '${address.state != null ? ', ${address.state}' : ''}'
          '${address.pincode != null ? ' - ${address.pincode}' : ''}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        if (address.phone != null) ...[
          const SizedBox(height: 4),
          Text(
            'Phone: ${address.phone}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _showAddressBottomSheet(context, addresses);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: GroceryColorTheme().primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Change Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
         
          ],
        ),
      ],
    );
  }

  void _showAddressBottomSheet(BuildContext context, List<Address> addresses) {
    final homeCubit = context.read<HomeCubit>(); // Capture the HomeCubit instance
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Delivery Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit, // Use the captured HomeCubit instance
                      buildWhen: (previous, current) =>
                          previous.selectedAddress != current.selectedAddress,
                      builder: (context, state) {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            final isSelected = state.selectedAddress?.id == address.id;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.green : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected ? Colors.green.shade50 : Colors.white,
                              ),
                              child: ListTile(
                                onTap: () {
                                  homeCubit.setSelectedAddress(address);
                                  Navigator.pop(context);
                                },
                                leading: Icon(
                                  Icons.location_on,
                                  color: isSelected ? Colors.green : Colors.grey,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        address.name ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isSelected ? Colors.green.shade800 : Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (address.isDefault == 1)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '${address.addressLine1 ?? ''}'
                                      '${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}'
                                      '${address.city != null ? ', ${address.city}' : ''}'
                                      '${address.state != null ? ', ${address.state}' : ''}'
                                      '${address.pincode != null ? ' - ${address.pincode}' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected ? Colors.green.shade600 : Colors.grey.shade600,
                                      ),
                                    ),
                                    if (address.phone != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'Phone: ${address.phone}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected ? Colors.green.shade600 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                     context.popPage();
                     context.pushPage(AddressPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GroceryColorTheme().primary,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add New Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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

//   Widget _buildCouponSection() {
//     return BlocBuilder<HomeCubit, HomeState>(
//       buildWhen: (previous, current) =>
//           previous.applyCouponApiState != current.applyCouponApiState,
//       builder: (context, state) {
//         final isApplied = state.applyCouponApiState.apiCallState == APICallState.loaded &&
//                          state.applyCouponApiState.model != null &&
//                          state.applyCouponApiState.model!.success == true;

//         // Only show if coupon is applied
//         if (!isApplied) {
//           return const SizedBox.shrink();
//         }

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16.0),
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green[300]!),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green[700], size: 20),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Coupon Applied: ${state.applyCouponApiState.model!.coupon}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green[700],
//                         ),
//                       ),
//                       Text(
//                         'You saved ₹${state.applyCouponApiState.model!.discount}',
//                         style: TextStyle(
//                           color: Colors.green[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Navigate to coupons page to manage coupons
//                     context.pushPage(FreeCouponPage(
//                       homeCubit: context.read<HomeCubit>(),
//                     ));
//                   },
//                   child: Text('Manage', style: TextStyle(color: Colors.orange[600])),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
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
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.timelapse_outlined,
          //       color: Colors.green,
          //       size: 20,
          //     ), // Placeholder for delivery icon
          //     const SizedBox(width: 8),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Free delivery in $deliveryTime', // Using deliveryTime for "14 minutes"
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w700,
          //             fontSize: 16,
          //           ),
          //         ),
          //         Text(
          //           'Shipment of $quantity item${quantity > 1 ? 's' : ''}', // Dynamic shipment count
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w300,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10),
          // Divider(
          //   height: 20,
          //   thickness: 1,
          //   color: GroceryColorTheme().black.withValues(alpha: 0.3),
          // ),
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
                    // Text(
                    //   description,
                    //   style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
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
