part of 'repository.dart';

class HomeRepository {
  HomeRepository(this.generalRepository);
  final GeneralRepository generalRepository;

  // get banners
  Future<BannersModel> getBanners() async {
    final response = await generalRepository.get(
      handle: GroceryApis.banners,
      );
    return BannersModel.fromJson(response);
  }


  // get categories
  Future<CategoryModel> getCategories() async {
    final response = await generalRepository.get(
      handle: GroceryApis.categories,
    );
    return CategoryModel.fromJson(response);
  }

  // get default categories
  Future<CategoryModel> getDefaultCategories() async {
    final response = await generalRepository.get(
      handle: GroceryApis.defaultCategories,
    );
    return CategoryModel.fromJson(response);
  }

  // get products
  Future<ProductModel> getProducts({int? subCategoryId, int? subSubCategoryId}) async {
 final String handle;
 if(subCategoryId != null) {
      handle = '${GroceryApis.products}?subcategory_id=$subCategoryId';
 } else if(subSubCategoryId != null) {
      handle = '${GroceryApis.products}?subsubcategory_id=$subSubCategoryId';
 }   else {
      handle = GroceryApis.products;
 }

    final response = await generalRepository.get(
      handle: handle,
    );
    return ProductModel.fromJson(response);
  }

  // get product details
  Future<ProductDetailsModel> getProductDetails(int productId) async {
    final response = await generalRepository.get(
      handle: '${GroceryApis.productDetails}?product_id=$productId',
    );
    return ProductDetailsModel.fromJson(response);
  }

  // add to cart
  Future<Map<String, dynamic>> addToCart({
    required int productId, 
    required int quantity,
    int? attributeId,        // Main attribute ID (e.g., 7 for "Weight")
    int? attributeValueId,   // Selected attribute value ID (e.g., 128)
  }) async {
    final Map<String, dynamic> body = {
      'product_id': productId,
      'quantity': quantity,
    };
    
    // Add attributes in the exact format requested if both attributeId and attributeValueId are provided
    if (attributeId != null && attributeValueId != null) {
      body['attribures'] = {
        '{attributeid}': attributeId.toString(),
        '{attributeidnext}': attributeValueId.toString(),
      };
    }

    final response = await generalRepository.post(
      handle: GroceryApis.addToCart,
      body:  jsonEncode(body),
    );
    return response;
  }

  // get cart items
  Future<CartListModel> getCartItems() async {
    final response = await generalRepository.get(
      handle: GroceryApis.getCartItems,
    );
    return CartListModel.fromJson(response);
  }

  // update cart item
  // update cart item
Future<void> updateCartItem({
  required int cartItemId, 
  required int quantity,
  int? attributeId,        // Main attribute ID (e.g., 7 for "Weight")
  int? attributeValueId,   // Selected attribute value ID (e.g., 96)
}) async {
  final Map<String, dynamic> body = {
    'product_id': cartItemId,  // 🔧 Use product_id instead of cart_item_id
    'quantity': quantity,
  };
  
  // Add attributes if both attributeId and attributeValueId are provided
  if (attributeId != null && attributeValueId != null) {
    body['attributes'] = {  // 🔧 Use attributes (with typo) to match API
      attributeId.toString(): attributeValueId,
    };
    log("body after attributes: $body");
  }
  

  await generalRepository.put(  // Keep PUT since it works in Postman
    handle: GroceryApis.updateCartItem,
    body: jsonEncode(body),
  );
}

  // delete cart item
  Future<void> deleteCartItem({required int cartItemId}) async {
    await generalRepository.delete(
      handle: '${GroceryApis.deleteCartItem}?id=$cartItemId',
    );
  }

  // clear cart
  Future<void> clearCart() async {
    await generalRepository.delete(
      handle: GroceryApis.clearCart,
    );
  }


  // get coupons
  Future<CouponsModel> getCoupons() async { 
    final response = await generalRepository.get(
      handle: GroceryApis.getCoupons,
    );
    return CouponsModel.fromJson(response);

  }

  // apply coupon
  Future<ApplyCouponModel> applyCoupon({required String couponCode, required double orderAmount}) async {
   final body = {
      "code": couponCode,
      "order_amount": orderAmount
    };

   final response = await generalRepository.post(
      handle: GroceryApis.applyCoupon,
      body:  jsonEncode(body),
    );
    return ApplyCouponModel.fromJson(response);
  }

  // checkout
  Future<CheckoutResponse> checkout({
    required int addressId,
    required String paymentMethod,
    required List<CheckoutCartItem> cart,
    String? couponId,
    double? couponDiscountAmount,
    double? shippingCharge,
    double? handlingCharge,
  }) async {
    final checkoutRequest = CheckoutRequest(
      addressId: addressId,
      paymentMethod: paymentMethod,
      cart: cart,
      couponId: couponId,
      couponDiscountAmount: couponDiscountAmount,
      shippingCharge: shippingCharge,
      handlingCharge: handlingCharge,
    );

    final response = await generalRepository.post(
      handle: GroceryApis.checkout,
      body: jsonEncode(checkoutRequest.toJson()),
    );
    
    return CheckoutResponse.fromJson(response);
  }

  // payment verify
  Future<PaymentVerifyResponse> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    final paymentVerifyRequest = PaymentVerifyRequest(
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
    );

    final response = await generalRepository.post(
      handle: GroceryApis.orderPaymentVerify,
      body: jsonEncode(paymentVerifyRequest.toJson()),
    );
    
    return PaymentVerifyResponse.fromJson(response);
  }

  // get orders
  Future<OrdersModel> getOrders() async {
    final response = await generalRepository.get(
      handle: GroceryApis.orders,
    );
    return OrdersModel.fromJson(response);
  }


  // get shipping fee
  Future<ShippingModel> getShippingFee() async {
    final response = await generalRepository.get(
      handle: GroceryApis.shippingFee,
    );
    return ShippingModel.fromJson(response);

  }


  // get handling fee
  Future<HandlingModel> getHandlingFee() async {
    final response = await generalRepository.get(
      handle: GroceryApis.handlingFee,
    );
    return HandlingModel.fromJson(response);

  }

  // submit review
  Future<Map<String, dynamic>> submitReview({
    required int orderId,
    required String review,
    required List<Map<String, dynamic>> ratings,
  }) async {
    final reviewData = {
      "review": review,
      "ratings": ratings,
    };

    final response = await generalRepository.post(
      handle: '${GroceryApis.submitReview}?order_id=$orderId',
      body: jsonEncode(reviewData),
    );
    
    return response;
  }

  // get order review
  Future<Map<String, dynamic>> getOrderReview({required int orderId}) async {
    final response = await generalRepository.get(
      handle: 'orders/reviews?order_id=$orderId',
    );
    return response;
  }


  // search products
  Future<SearchModel> searchProducts({required String query}) async {
    final response = await generalRepository.get(
      handle: '${GroceryApis.products}?search=$query',
    );
    return SearchModel.fromJson(response);
  }

  // get order invoice
  Future<OrderInvoiceModel> getOrderInvoice({required int orderId}) async {
    final response = await generalRepository.get(
      handle: '${GroceryApis.orderInvoice}?order_id=$orderId',
    );
    return OrderInvoiceModel.fromJson(response);
  }



  // get trending products
  Future<ProductModel> getTrendingProducts() async {
    final response = await generalRepository.get(
      handle: GroceryApis.trendingProducts,
    );
    return ProductModel.fromJson(response);
  }


  // get featured products
  Future<List<FeaturedProductsModel>> getFeaturedProducts() async {
    final response = await generalRepository.get(
      handle: GroceryApis.featuredProducts,
    );
    return List<FeaturedProductsModel>.from(response.map((x) => FeaturedProductsModel.fromJson(x)));
  }

  // get time slots
  Future<List<TimeSlotsModel>> getTimeSlots() async {
    final response = await generalRepository.get(
      handle: GroceryApis.timeSlots,
    );
    return List<TimeSlotsModel>.from(response.map((x) => TimeSlotsModel.fromJson(x)));
  }

  // get wallet balance
  Future<WalletBalanceModel> getWalletBalance() async {
    final response = await generalRepository.get(
      handle: "available-wallet-balance",
    );
    return WalletBalanceModel.fromJson(response);
  }

  }