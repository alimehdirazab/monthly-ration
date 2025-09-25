part of 'view.dart';

class ProductVariantsBottomSheet extends StatefulWidget {
  final home_models.Product product;
  final List<home_models.CartItem> cartItems;
  final Function(int attributeValueId, int quantity) onAddToCart;

  const ProductVariantsBottomSheet._({
    required this.product,
    required this.cartItems,
    required this.onAddToCart,
  });

  @override
  State<ProductVariantsBottomSheet> createState() => _ProductVariantsBottomSheetState();

  static void show({
    required BuildContext context,
    required home_models.Product product,
    required Function(int attributeValueId, int quantity) onAddToCart,
  }) {
    final homeCubit = context.read<HomeCubit>();  // Get the HomeCubit before showing bottom sheet
    final cartItems = homeCubit.state.getCartItemsApiState.model?.data ?? [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: homeCubit,  // Provide the HomeCubit to the bottom sheet
        child: ProductVariantsBottomSheet._(
          product: product,
          cartItems: cartItems,
          onAddToCart: onAddToCart,
        ),
      ),
    );
  }
}

class _ProductVariantsBottomSheetState extends State<ProductVariantsBottomSheet> {
  Map<int, int> _quantities = {}; // Map of attributeValueId to quantity

  @override
  void initState() {
    super.initState();
    _initializeQuantitiesFromCart();
  }

  void _initializeQuantitiesFromCart() {
    // Initialize quantities for each variant from cart
    for (final attributeValue in widget.product.attributeValues) {
      for (final value in attributeValue.attribute.values) {
        if (value.id != null) {
          final cartItem = widget.cartItems.firstWhere(
            (item) => item.productId == widget.product.id && item.attributeValueId == value.id,
            orElse: () => home_models.CartItem(),
          );
          
          _quantities[value.id!] = cartItem.quantity ?? 0;
        }
      }
    }
  }

  void _incrementQuantity(int attributeValueId) {
    final currentQuantity = _quantities[attributeValueId] ?? 0;
    final newQuantity = currentQuantity + 1;
    
    // Optimistic UI update
    setState(() {
      _quantities[attributeValueId] = newQuantity;
    });
    
    // For increment, we need to determine if this is the first add or an increment
    if (currentQuantity == 0) {
      // First time adding - pass the new quantity (1)
      widget.onAddToCart(attributeValueId, newQuantity);
    } else {
      // Incrementing existing - pass the new total quantity but API should use addToCart with quantity 1
      widget.onAddToCart(attributeValueId, newQuantity);
    }
  }

  void _decrementQuantity(int attributeValueId) {
    final currentQuantity = _quantities[attributeValueId] ?? 0;
    if (currentQuantity > 0) {
      final newQuantity = currentQuantity - 1;
      
      // Optimistic UI update
      setState(() {
        _quantities[attributeValueId] = newQuantity;
      });
      
      // Call parent's callback which will handle optimistic API calls
      widget.onAddToCart(attributeValueId, newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => 
          previous.addToCartApiState != current.addToCartApiState ||
          previous.updateCartItemApiState != current.updateCartItemApiState ||
          previous.deleteCartItemApiState != current.deleteCartItemApiState,
      listener: (context, state) {
        // Sync quantities when cart state changes (from optimistic updates)
        if (state.getCartItemsApiState.apiCallState == APICallState.loaded) {
          final cartItems = state.getCartItemsApiState.model?.data ?? [];
          
          // Update quantities from current cart state
          for (final attributeValue in widget.product.attributeValues) {
            for (final value in attributeValue.attribute.values) {
              if (value.id != null) {
                final cartItem = cartItems.firstWhere(
                  (item) => item.productId == widget.product.id && item.attributeValueId == value.id,
                  orElse: () => home_models.CartItem(),
                );
                
                final newQuantity = cartItem.quantity ?? 0;
                if (_quantities[value.id!] != newQuantity) {
                  setState(() {
                    _quantities[value.id!] = newQuantity;
                  });
                }
              }
            }
          }
        }
      },
      child: Container(
      decoration:  BoxDecoration(
        color: const Color.fromARGB(255, 238, 240, 248),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
               
                const SizedBox(width: 12),
                
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                     
                    ],
                  ),
                ),
                
            
              ],
            ),
          ),
          
          // Variants list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.product.attributeValues.length,
              itemBuilder: (context, index) {
                final attributeValue = widget.product.attributeValues[index];
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // // Attribute name (e.g., "Weight")
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: Text(
                    //     attributeValue.attribute.name,
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    
                    // Attribute values list
                    ...attributeValue.attribute.values.map((value) {
                      final quantity = _quantities[value.id] ?? 0;
                      final mrpPrice = double.tryParse(value.mrpPrice ?? '0') ?? 0.0;
                      final sellPrice = double.tryParse(value.sellPrice ?? '0') ?? 0.0;
                      final discountPercent = (value.discount ?? '0').replaceAll('%', '');
                      final hasValidPrice = sellPrice > 0;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        
                        decoration: BoxDecoration(
                          color: GroceryColorTheme().white,
                         // border: Border.all(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Product image for variant
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: widget.product.imagesUrls.isNotEmpty
                                      ? Image.network(
                                          widget.product.imagesUrls.first,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 50,
                                              width: 50,
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.image_not_supported, size: 20),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported, size: 20),
                                        ),
                                ),
                                // Discount badge positioned on image
                                if (discountPercent.isNotEmpty && discountPercent != '0')
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        '$discountPercent%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(width: 12),
                            
                            // Variant info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.value ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  
                                  if (hasValidPrice) ...[
                                    Row(
                                      children: [
                                        Text(
                                          '₹${sellPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        
                                        if (mrpPrice > sellPrice) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            '₹${mrpPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ] else ...[
                                    const Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            
                            // Add to cart controls
                            if (hasValidPrice) ...[
                              if (quantity == 0)
                                GestureDetector(
                                  onTap: value.id != null ? () => _incrementQuantity(value.id!) : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'ADD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: value.id != null ? () => _decrementQuantity(value.id!) : null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        child: Text(
                                          quantity.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: value.id != null ? () => _incrementQuantity(value.id!) : null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'UNAVAILABLE',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          
          // Bottom padding
          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }
}