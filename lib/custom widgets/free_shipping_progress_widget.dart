part of 'widgets.dart';

class FreeShippingProgressWidget extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  const FreeShippingProgressWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.getCartItemsApiState != current.getCartItemsApiState ||
          previous.shippingApiState != current.shippingApiState,
      builder: (context, state) {
        final cartItems = state.getCartItemsApiState.model?.data ?? [];
        final shippingData = state.shippingApiState.model?.data;
        
        if (cartItems.isEmpty || shippingData == null) {
          return const SizedBox.shrink();
        }

        // Calculate cart total
        double cartTotal = 0;
        for (final item in cartItems) {
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

        final shippingThreshold = shippingData.shiipingApplicableAmount?.toDouble() ?? 0;
        final actualProgress = shippingThreshold > 0 ? (cartTotal / shippingThreshold).clamp(0.0, 1.0) : 0.0;
        
        // Determine if free shipping is achieved
        final isFreeShippingAchieved = cartTotal >= shippingThreshold && shippingThreshold > 0;
        final remainingAmount = shippingThreshold - cartTotal;
        
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:  GroceryColorTheme().black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: actualProgress,
                backgroundColor: GroceryColorTheme().black.withValues(alpha: 0.1),
                color: isFreeShippingAchieved 
                    ? Colors.green 
                    : GroceryColorTheme().primary,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isFreeShippingAchieved 
                        ? Icons.check_circle 
                        : Icons.local_shipping_outlined,
                    color: isFreeShippingAchieved 
                        ? Colors.green 
                        : GroceryColorTheme().primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isFreeShippingAchieved 
                          ? "Wow! You have unlocked free delivery" 
                          : "Add ₹${remainingAmount.toStringAsFixed(0)} more for free delivery",
                      style: GroceryTextTheme().boldText.copyWith(
                        color: GroceryColorTheme().white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}
