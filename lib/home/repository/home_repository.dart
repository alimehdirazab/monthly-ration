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
  Future<void> addToCart({required int productId, required int quantity,String? color,String? size}) async {
    // Try simpler body first to see if attributes are causing issues
    final Map<String, dynamic> body = {
      'product_id': productId,
      'quantity': quantity,
    };
    
    // Only add attributes if they are not null
    if (color != null || size != null) {
      body['attributes'] = {
        if (color != null) 'color': color,
        if (size != null) 'size': size,
      };
    }
    
     await generalRepository.post(
      handle: GroceryApis.addToCart,
      body:  jsonEncode(body),
    );
    
   
  }

  // get cart items
  Future<CartListModel> getCartItems() async {
    final response = await generalRepository.get(
      handle: GroceryApis.getCartItems,
    );
    return CartListModel.fromJson(response);
  }

  // update cart item
  Future<void> updateCartItem({required int cartItemId, required int quantity}) async {
    final body = {
      'quantity': quantity,
    };

   await generalRepository.put(
      handle: '${GroceryApis.updateCartItem}?id=$cartItemId',
      body:  jsonEncode(body),
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
  Future<void> applyCoupon({required String couponCode, required double orderAmount}) async {
   final body = {
      "code": couponCode,
      "order_amount": orderAmount
    };

   await generalRepository.post(
      handle: GroceryApis.applyCoupon,
      body:  jsonEncode(body),
    );
  }

  // checkout
  Future<CheckoutResponse> checkout({
    required int addressId,
    required String paymentMethod,
    required List<CheckoutCartItem> cart,
  }) async {
    final checkoutRequest = CheckoutRequest(
      addressId: addressId,
      paymentMethod: paymentMethod,
      cart: cart,
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
  
  
  }