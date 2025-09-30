part of 'widgets.dart';

class FreeShippingProgressWidget extends StatefulWidget {
  const FreeShippingProgressWidget({super.key});

  @override
  State<FreeShippingProgressWidget> createState() => _FreeShippingProgressWidgetState();
}

class _FreeShippingProgressWidgetState extends State<FreeShippingProgressWidget>
    with TickerProviderStateMixin {
  AnimationController? _lottieController;
  AnimationController? _progressController;
  Animation<double>? _progressAnimation;
  bool _showLottie = false;
  bool _hasShownLottie = false; // Track if lottie has been shown to show only once

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController!, curve: Curves.elasticOut),
    );
    
    _lottieController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _progressController?.dispose();
    _lottieController?.dispose();
    super.dispose();
  }

  void _triggerLottieAnimation() {
    if (!_showLottie && !_hasShownLottie) {
      setState(() {
        _showLottie = true;
        _hasShownLottie = true; // Mark as shown so it won't show again
      });
      _lottieController?.forward().then((_) {
        // Hide lottie after animation completes
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showLottie = false;
            });
            _lottieController?.reset();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.getCartItemsApiState != current.getCartItemsApiState ||
          previous.shippingApiState != current.shippingApiState,
      builder: (context, state) {
        // Get cart total
        final cartItems = state.getCartItemsApiState.model?.data ?? [];
        if (cartItems.isEmpty) return const SizedBox.shrink();

        double cartTotal = 0;
        for (final item in cartItems) {
          // Safely convert price from Object to double
          double price = 0;
          if (item.product?.salePrice != null) {
            if (item.product!.salePrice is num) {
              price = (item.product!.salePrice as num).toDouble();
            } else if (item.product!.salePrice is String) {
              price = double.tryParse(item.product!.salePrice.toString()) ?? 0;
            }
          }
          final quantity = item.quantity ?? 0;
          cartTotal += price * quantity;
        }

        // Get shipping info
        final shippingData = state.shippingApiState.model?.data;
        if (shippingData == null) return const SizedBox.shrink();

        final shippingThreshold = shippingData.shiipingApplicableAmount?.toDouble() ?? 0;
        final shippingAmount = shippingData.shippingAmount?.toDouble() ?? 0;

        if (shippingThreshold <= 0) return const SizedBox.shrink();

        // Calculate progress
        final progress = (cartTotal / shippingThreshold).clamp(0.0, 1.0);
        final isEligibleForFreeShipping = cartTotal >= shippingThreshold;
        final amountNeeded = shippingThreshold - cartTotal;

        // Animate progress
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _progressController?.animateTo(progress);
          
          // Trigger lottie if eligible for free shipping
          if (isEligibleForFreeShipping) {
            _triggerLottieAnimation();
          }
        });

        return Stack(
          children: [
            // Bottom positioned widget
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isEligibleForFreeShipping
                        ? [
                            const Color(0xFF4CAF50), // Green
                            const Color(0xFF2E7D32),
                          ]
                        : [
                            const Color(0xFF2196F3), // Blue
                            const Color(0xFF1565C0),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isEligibleForFreeShipping
                                ? Icons.local_shipping
                                : Icons.local_shipping_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEligibleForFreeShipping
                                    ? '🎉 Free Delivery Unlocked!'
                                    : '🚚 Free Delivery Available',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isEligibleForFreeShipping
                                    ? 'You saved ₹${shippingAmount.toStringAsFixed(0)} on delivery!'
                                    : 'Add ₹${amountNeeded.toStringAsFixed(0)} more items',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '₹${cartTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹0',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹${shippingThreshold.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressAnimation!,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressAnimation!.value,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Full screen lottie animation overlay
            if (_showLottie)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Lottie.asset(
                      'assets/images/confetti on transparent background.json',
                      controller: _lottieController,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}