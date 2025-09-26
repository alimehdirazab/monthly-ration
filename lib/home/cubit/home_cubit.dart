
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_flutter_app/home/repository/models/models.dart';
import 'package:grocery_flutter_app/home/repository/repository.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepository) : super(HomeState());
  final HomeRepository homeRepository;

  // void addToCart(String itemName) {
  //   final updatedList = List<String>.from(state.cartItems)..add(itemName);
  //   emit(state.copyWith(cartItems: updatedList));
  // }

  // void clearCart() {
  //   final List<String> updatedList = [];
  //   emit(state.copyWith(cartItems: updatedList));
  // }

  int get cartCount => state.cartItems.length;

  // Set selected category index
  void setSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  // Set selected delivery date index
  void setSelectedDeliveryDateIndex(int index) {
    emit(state.copyWith(selectedDeliveryDateIndex: index));
  }

  // Set selected time slot index
  void setSelectedTimeSlotIndex(int index) {
    emit(state.copyWith(selectedTimeSlotIndex: index));
  }

  // Set selected address
  void setSelectedAddress(Address? address) {
    emit(state.copyWith(selectedAddress: address));
  }

  // get banners Method
  Future<void> getBanners() async {
    emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
      apiCallState: APICallState.loading
    )));

    await homeRepository.getBanners().then((bannersModel) {
      emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
        apiCallState: APICallState.loaded,
        model: bannersModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(bannersApiState: GeneralApiState<BannersModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get categories Method
  Future<void> getCategories() async {
    emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getCategories().then((categoriesModel) {
      emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.loaded,
        model: categoriesModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(categoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get default categories Method
  Future<void> getDefaultCategories() async {
    emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getDefaultCategories().then((categoriesModel) {
      emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.loaded,
        model: categoriesModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(defaultCategoriesApiState: GeneralApiState<CategoryModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // //  get All products Method
  // Future<void> getProducts({int? categoryId}) async {
  //   emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
  //     apiCallState: APICallState.loading,
  //   )));

  //   await homeRepository.getProducts(categoryId: categoryId).then((productsModel) {
  //     emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
  //       apiCallState: APICallState.loaded,
  //       model: productsModel,
  //     )));
  //   }).catchError((error) {
  //     emit(state.copyWith(productsApiState: GeneralApiState<ProductModel>(
  //       apiCallState: APICallState.failure,
  //       errorMessage: error.toString(),
  //     )));
  //   });
  // }

  // get products by sub category Method
  Future<void> getProductsBySubCategory({int? subCategoryId, int? subSubCategoryId}) async {
    emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getProducts(subCategoryId: subCategoryId, subSubCategoryId: subSubCategoryId).then((productsModel) {
      emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.loaded,
        model: productsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get product details Method
  Future<void> getProductDetails(int productId) async {
    emit(state.copyWith(productDetailsApiState: GeneralApiState<ProductDetailsModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getProductDetails(productId).then((productDetailsModel) {
      emit(state.copyWith(productDetailsApiState: GeneralApiState<ProductDetailsModel>(
        apiCallState: APICallState.loaded,
        model: productDetailsModel,
      )));
    });
  }

  // add to cart Method
  Future<void> addToCart({
    required int productId, 
    required int quantity,
    int? attributeId,        // Main attribute ID (e.g., 7 for "Weight")
    int? attributeValueId,   // Selected attribute value ID (e.g., 128)
  }) async {
    emit(state.copyWith(addToCartApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.addToCart(productId: productId, quantity: quantity, attributeId: attributeId, attributeValueId: attributeValueId).then((_) {
      // Update cart items quantity in cartItems list for particular product
      List<CartItem> updatedCartItems = List.from(state.getCartItemsApiState.model?.data ?? []);
      
      // Check if product already exists in cart
      int existingItemIndex = updatedCartItems.indexWhere((item) => item.productId == productId);
      
      if (existingItemIndex != -1) {
        // Product already in cart, update its quantity
        CartItem existingItem = updatedCartItems[existingItemIndex];
        updatedCartItems[existingItemIndex] = CartItem(
          id: existingItem.id,
          customerId: existingItem.customerId,
          productId: existingItem.productId,
          quantity: (existingItem.quantity ?? 0) + quantity,
          attributes: existingItem.attributes,
          createdAt: existingItem.createdAt,
          updatedAt: existingItem.updatedAt,
          product: existingItem.product,
        );
        
        emit(state.copyWith(
          addToCartApiState: GeneralApiState<void>(
            apiCallState: APICallState.loaded,
          ),
          getCartItemsApiState: GeneralApiState<CartListModel>(
            apiCallState: APICallState.loaded,
            model: CartListModel(data: updatedCartItems),
          ),
        ));
      } else {
        // Product not in cart, do not add it - just emit success state
        emit(state.copyWith(
          addToCartApiState: GeneralApiState<void>(
            apiCallState: APICallState.loaded,
          ),
        ));
      }
    }).catchError((error) {
      emit(state.copyWith(addToCartApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get cart items Method
  Future<void> getCartItems() async {
    emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
      apiCallState: APICallState.loading,
    ),
    clearCartApiState: GeneralApiState<void>(
      apiCallState: APICallState.initial,
    ),
  ));

    await homeRepository.getCartItems().then((cartListModel) {
      emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
        apiCallState: APICallState.loaded,
        model: cartListModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }
  // update cart item Method
  Future<void> updateCartItem({required int cartItemId, required int quantity}) async {
    emit(state.copyWith(updateCartItemApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.updateCartItem(cartItemId: cartItemId, quantity: quantity).then((_) {
      // Update cart items quantity in cartItems list for particular cart item
      List<CartItem> updatedCartItems = List.from(state.getCartItemsApiState.model?.data ?? []);
      
      // Find the cart item by ID and update its quantity
      int existingItemIndex = updatedCartItems.indexWhere((item) => item.id == cartItemId);
      
      if (existingItemIndex != -1) {
        CartItem existingItem = updatedCartItems[existingItemIndex];
        updatedCartItems[existingItemIndex] = CartItem(
          id: existingItem.id,
          customerId: existingItem.customerId,
          productId: existingItem.productId,
          quantity: quantity,
          attributes: existingItem.attributes,
          createdAt: existingItem.createdAt,
          updatedAt: DateTime.now(), // Update the timestamp
          product: existingItem.product,
        );
      }
      
      emit(state.copyWith(
        updateCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.loaded,
        ),
        getCartItemsApiState: GeneralApiState<CartListModel>(
          apiCallState: APICallState.loaded,
          model: CartListModel(data: updatedCartItems),
        ),
      ));
    }).catchError((error) {
      emit(state.copyWith(updateCartItemApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // delete cart item Method
  Future<void> deleteCartItem({required int cartItemId}) async {
    emit(state.copyWith(deleteCartItemApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.deleteCartItem(cartItemId: cartItemId).then((_) {
      // Remove item from cartItems list immediately
      List<CartItem> updatedCartItems = List.from(state.getCartItemsApiState.model?.data ?? []);
      updatedCartItems.removeWhere((item) => item.id == cartItemId);
      
      emit(state.copyWith(
        deleteCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.loaded,
        ),
        getCartItemsApiState: GeneralApiState<CartListModel>(
          apiCallState: APICallState.loaded,
          model: CartListModel(data: updatedCartItems),
        ),
      ));
    }).catchError((error) {
      emit(state.copyWith(deleteCartItemApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // clear cart Method
  Future<void> clearCart() async {
    emit(state.copyWith(clearCartApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.clearCart().then((_) {
      emit(state.copyWith(clearCartApiState: GeneralApiState<void>(
        apiCallState: APICallState.loaded,
      )));
    }).catchError((error) {
      emit(state.copyWith(clearCartApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get coupons Method
  Future<void> getCoupons() async {
    emit(state.copyWith(getCouponsApiState: GeneralApiState<CouponsModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getCoupons().then((couponsModel) {
      emit(state.copyWith(getCouponsApiState: GeneralApiState<CouponsModel>(
        apiCallState: APICallState.loaded,
        model: couponsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(getCouponsApiState: GeneralApiState<CouponsModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // apply coupon Method
  Future<void> applyCoupon({required String couponCode, required double orderAmount}) async {
    emit(state.copyWith(applyCouponApiState: GeneralApiState<ApplyCouponModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.applyCoupon(couponCode: couponCode, orderAmount: orderAmount).then((applyCouponModel) {
      emit(state.copyWith(applyCouponApiState: GeneralApiState<ApplyCouponModel>(
        apiCallState: APICallState.loaded,
        model: applyCouponModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(applyCouponApiState: GeneralApiState<ApplyCouponModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // checkout Method
  Future<void> checkout({
    required int addressId,
    required String paymentMethod,
    required List<CheckoutCartItem> cart,
  }) async {
    emit(state.copyWith(checkoutApiState: GeneralApiState<CheckoutResponse>(
      apiCallState: APICallState.loading,
    )));

    // Get coupon data if applied
    String? couponId;
    double? couponDiscountAmount;
    if (state.applyCouponApiState.apiCallState == APICallState.loaded && 
        state.applyCouponApiState.model != null) {
      couponId = state.applyCouponApiState.model!.coupon;
      couponDiscountAmount = state.applyCouponApiState.model!.discount?.toDouble();
    }

    // Get shipping and handling charges
    double? shippingCharge;
    double? handlingCharge;
    if (state.shippingApiState.apiCallState == APICallState.loaded && 
        state.shippingApiState.model != null &&
        state.shippingApiState.model!.data != null) {
      shippingCharge = state.shippingApiState.model!.data!.shippingAmount?.toDouble();
    }
    if (state.handlingApiState.apiCallState == APICallState.loaded && 
        state.handlingApiState.model != null &&
        state.handlingApiState.model!.data != null) {
      handlingCharge = state.handlingApiState.model!.data!.handlingAmount?.toDouble();
    }

    await homeRepository.checkout(
      addressId: addressId,
      paymentMethod: paymentMethod,
      cart: cart,
      couponId: couponId,
      couponDiscountAmount: couponDiscountAmount,
      shippingCharge: shippingCharge,
      handlingCharge: handlingCharge,
    ).then((checkoutResponse) {
      emit(state.copyWith(checkoutApiState: GeneralApiState<CheckoutResponse>(
        apiCallState: APICallState.loaded,
        model: checkoutResponse,
      )));
    }).catchError((error) {
      emit(state.copyWith(checkoutApiState: GeneralApiState<CheckoutResponse>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // payment verify Method
  Future<void> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    emit(state.copyWith(paymentVerifyApiState: GeneralApiState<PaymentVerifyResponse>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.verifyPayment(
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
    ).then((paymentVerifyResponse) {
      emit(state.copyWith(paymentVerifyApiState: GeneralApiState<PaymentVerifyResponse>(
        apiCallState: APICallState.loaded,
        model: paymentVerifyResponse,
      )));
    }).catchError((error) {
      emit(state.copyWith(paymentVerifyApiState: GeneralApiState<PaymentVerifyResponse>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // reset checkout state
  void resetCheckoutState() {
    emit(state.copyWith(
      checkoutApiState: GeneralApiState<CheckoutResponse>(
        apiCallState: APICallState.initial,
      ),
      paymentVerifyApiState: GeneralApiState<PaymentVerifyResponse>(
        apiCallState: APICallState.initial,
      ),
    ));
  }

  // get orders Method
  Future<void> getOrders() async {
    emit(state.copyWith(ordersApiState: GeneralApiState<OrdersModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getOrders().then((ordersModel) {
      emit(state.copyWith(ordersApiState: GeneralApiState<OrdersModel>(
        apiCallState: APICallState.loaded,
        model: ordersModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(ordersApiState: GeneralApiState<OrdersModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get shipping Method
  Future<void> getShippingFee() async {
    emit(state.copyWith(shippingApiState: GeneralApiState<ShippingModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getShippingFee().then((shippingModel) {
      emit(state.copyWith(shippingApiState: GeneralApiState<ShippingModel>(
        apiCallState: APICallState.loaded,
        model: shippingModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(shippingApiState: GeneralApiState<ShippingModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }


  // get handling Method
  Future<void> getHandlingFee() async {
    emit(state.copyWith(handlingApiState: GeneralApiState<HandlingModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getHandlingFee().then((handlingModel) {
      emit(state.copyWith(handlingApiState: GeneralApiState<HandlingModel>(
        apiCallState: APICallState.loaded,
        model: handlingModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(handlingApiState: GeneralApiState<HandlingModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // submit review Method
  Future<void> submitReview({
    required int orderId,
    required String review,
    required List<Map<String, dynamic>> ratings,
  }) async {
    emit(state.copyWith(submitReviewApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.submitReview(
      orderId: orderId,
      review: review,
      ratings: ratings,
    ).then((response) {
      emit(state.copyWith(submitReviewApiState: GeneralApiState<void>(
        apiCallState: APICallState.loaded,
      )));
    }).catchError((error) {
      emit(state.copyWith(submitReviewApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Optimistic Add to Cart - Updates UI immediately, then calls API
  Future<void> optimisticAddToCart({
    required int productId,
    required int quantity,
    required Product product,
    int? attributeId,
    int? attributeValueId,
    bool isIncrement = false,  // New parameter to indicate if this is an increment operation
  }) async {
    // 1. Add/Update item in cart items list first
    _updateCartItemsOptimistically(productId, quantity, product, attributeValueId, isIncrement: isIncrement);
    
    // 2. Update product's cartQuantity in the products list (calculated from cart total)
    _updateProductCartQuantity(productId, null);
    
    // 3. Call the actual API
    try {
      await homeRepository.addToCart(
        productId: productId, 
        quantity: quantity, 
        attributeId: attributeId, 
        attributeValueId: attributeValueId
      );
      
      // API Success - emit success state
      emit(state.copyWith(addToCartApiState: GeneralApiState<void>(
        apiCallState: APICallState.loaded,
      )));
      
    } catch (error) {
      // API Failed - rollback the optimistic changes
      _rollbackCartItemsOptimistically(productId, quantity, attributeValueId);
      _updateProductCartQuantity(productId, null);
      
      emit(state.copyWith(addToCartApiState: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
      
      rethrow; // Re-throw to handle in UI
    }
  }

  // Optimistic Update Cart - Updates UI immediately, then calls API
  Future<void> optimisticUpdateCart({
    required int productId,
    required int quantity,
    required Product product,
    int? attributeValueId,
  }) async {
    // Store previous cart state for rollback
    final previousCartItems = List<CartItem>.from(state.getCartItemsApiState.model?.data ?? []);
    
    // 1. Update cart items list first
    _updateCartItemsOptimistically(productId, quantity, product, attributeValueId);
    
    // 2. Update product's cartQuantity (calculated from cart total)
    _updateProductCartQuantity(productId, null);
    
    // 3. Find cart item ID and call update API
    try {
      final cartItems = state.getCartItemsApiState.model?.data ?? [];
      final cartItem = cartItems.firstWhere(
        (item) => item.productId == productId && 
                  (attributeValueId == null || item.attributeValueId == attributeValueId),
        orElse: () => CartItem(),
      );
      
      if (cartItem.id != null) {
        await homeRepository.updateCartItem(cartItemId: cartItem.id!, quantity: quantity);
        
        // API Success
        emit(state.copyWith(updateCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.loaded,
        )));
      }
      
    } catch (error) {
      // API Failed - rollback changes
      final rollbackCartModel = CartListModel(success: true, data: previousCartItems);
      emit(state.copyWith(
        getCartItemsApiState: GeneralApiState<CartListModel>(
          apiCallState: APICallState.loaded,
          model: rollbackCartModel,
        ),
        updateCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.failure,
          errorMessage: error.toString(),
        ),
      ));
      _updateProductCartQuantity(productId, null);
      
      rethrow;
    }
  }

  // Optimistic Remove from Cart - Updates UI immediately, then calls API
  Future<void> optimisticRemoveFromCart({
    required int productId,
    required Product product,
    int? attributeValueId,
  }) async {
    // Store previous cart state for rollback
    final previousCartItems = List<CartItem>.from(state.getCartItemsApiState.model?.data ?? []);
    
    // 1. Remove from cart items list first
    _removeCartItemOptimistically(productId, attributeValueId);
    
    // 2. Update product's cartQuantity (calculated from remaining cart total)
    _updateProductCartQuantity(productId, null);
    
    // 3. Find cart item ID and call delete API
    try {
      final cartItem = previousCartItems.firstWhere(
        (item) => item.productId == productId && 
                  (attributeValueId == null || item.attributeValueId == attributeValueId),
        orElse: () => CartItem(),
      );
      
      if (cartItem.id != null) {
        await homeRepository.deleteCartItem(cartItemId: cartItem.id!);
        
        // API Success
        emit(state.copyWith(deleteCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.loaded,
        )));
      }
      
    } catch (error) {
      // API Failed - rollback changes
      final rollbackCartModel = CartListModel(success: true, data: previousCartItems);
      emit(state.copyWith(
        getCartItemsApiState: GeneralApiState<CartListModel>(
          apiCallState: APICallState.loaded,
          model: rollbackCartModel,
        ),
        deleteCartItemApiState: GeneralApiState<void>(
          apiCallState: APICallState.failure,
          errorMessage: error.toString(),
        ),
      ));
      _updateProductCartQuantity(productId, null);
      
      rethrow;
    }
  }

  // Helper methods for optimistic updates
  void _updateProductCartQuantity(int productId, int? quantity) {
    // For variant products, calculate total quantity from cart items
    // For single variant products, use the provided quantity
    if (state.productsBySubCategoryApiState.model != null) {
      final products = List<Product>.from(state.productsBySubCategoryApiState.model!.data);
      final productIndex = products.indexWhere((p) => p.id == productId);
      
      if (productIndex != -1) {
        final product = products[productIndex];
        int totalCartQuantity;
        
        // For both variant and single variant products, calculate total from all cart items
        // This ensures we always have the most up-to-date quantity after cart operations
        final cartItems = state.getCartItemsApiState.model?.data ?? [];
        totalCartQuantity = cartItems
            .where((item) => item.productId == productId)
            .fold(0, (sum, item) => sum + (item.quantity ?? 0));
        
        final updatedProduct = Product(
          id: product.id,
          name: product.name,
          description: product.description,
          category: product.category,
          subcategory: product.subcategory,
          brand: product.brand,
          mrpPrice: product.mrpPrice,
          discount: product.discount,
          salePrice: product.salePrice,
          weight: product.weight,
          imagesUrls: product.imagesUrls,
          tax: product.tax,
          cartQuantity: totalCartQuantity, // Update cart quantity
          attributeValues: product.attributeValues,
        );
        
        products[productIndex] = updatedProduct;
        
        final updatedModel = ProductModel(data: products);
        emit(state.copyWith(productsBySubCategoryApiState: GeneralApiState<ProductModel>(
          apiCallState: APICallState.loaded,
          model: updatedModel,
        )));
      }
    }
  }



  void _updateCartItemsOptimistically(int productId, int quantity, Product product, int? attributeValueId, {bool isIncrement = false}) {
    final cartItems = List<CartItem>.from(state.getCartItemsApiState.model?.data ?? []);
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.productId == productId && 
                (attributeValueId == null || item.attributeValueId == attributeValueId),
    );
    
    if (existingItemIndex != -1) {
      // Update existing item
      final existingItem = cartItems[existingItemIndex];
      final newQuantity = isIncrement 
          ? (existingItem.quantity ?? 0) + quantity  // Add to existing quantity for increments
          : quantity;  // Set to new quantity for regular updates
          
      cartItems[existingItemIndex] = CartItem(
        id: existingItem.id,
        customerId: existingItem.customerId,
        productId: existingItem.productId,
        quantity: newQuantity,
        attributes: existingItem.attributes,
        attributeValueId: existingItem.attributeValueId,
        createdAt: existingItem.createdAt,
        updatedAt: existingItem.updatedAt,
        product: existingItem.product,
        attributesValues: existingItem.attributesValues,
      );
    } else {
      // Add new item
      cartItems.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
        customerId: null,
        productId: productId,
        quantity: quantity,
        attributes: null,
        attributeValueId: attributeValueId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        product: Produc(
          id: product.id,
          name: product.name,
          slug: null,
          description: product.description,
          categoryIds: null,
          subCategory: null,
          subsubCategoryId: null,
          brandId: null,
          mrpPrice: product.mrpPrice,
          salePrice: product.salePrice,
          purchasePrice: null,
          tax: product.tax,
          discount: product.discount,
          shippingCost: null,
          stock: null,
          tagIds: null,
          unit: null,
          published: null,
          weight: product.weight,
          pieces: null,
          colorsIds: null,
          imagesUrls: product.imagesUrls,
          extraFields: null,
          isTranding: null,
          status: null,
          createdAt: null,
          updatedAt: null,
        ),
        attributesValues: null,
      ));
    }
    
    final updatedCartModel = CartListModel(success: true, data: cartItems);
    emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
      apiCallState: APICallState.loaded,
      model: updatedCartModel,
    )));
  }

  void _removeCartItemOptimistically(int productId, int? attributeValueId) {
    final cartItems = List<CartItem>.from(state.getCartItemsApiState.model?.data ?? []);
    cartItems.removeWhere(
      (item) => item.productId == productId && 
                (attributeValueId == null || item.attributeValueId == attributeValueId),
    );
    
    final updatedCartModel = CartListModel(success: true, data: cartItems);
    emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
      apiCallState: APICallState.loaded,
      model: updatedCartModel,
    )));
  }

  void _rollbackCartItemsOptimistically(int productId, int quantityToSubtract, int? attributeValueId) {
    final cartItems = List<CartItem>.from(state.getCartItemsApiState.model?.data ?? []);
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.productId == productId && 
                (attributeValueId == null || item.attributeValueId == attributeValueId),
    );
    
    if (existingItemIndex != -1) {
      final existingItem = cartItems[existingItemIndex];
      final newQuantity = (existingItem.quantity ?? 0) - quantityToSubtract;
      
      if (newQuantity <= 0) {
        cartItems.removeAt(existingItemIndex);
      } else {
        cartItems[existingItemIndex] = CartItem(
          id: existingItem.id,
          customerId: existingItem.customerId,
          productId: existingItem.productId,
          quantity: newQuantity,
          attributes: existingItem.attributes,
          attributeValueId: existingItem.attributeValueId,
          createdAt: existingItem.createdAt,
          updatedAt: existingItem.updatedAt,
          product: existingItem.product,
          attributesValues: existingItem.attributesValues,
        );
      }
      
      final updatedCartModel = CartListModel(success: true, data: cartItems);
      emit(state.copyWith(getCartItemsApiState: GeneralApiState<CartListModel>(
        apiCallState: APICallState.loaded,
        model: updatedCartModel,
      )));
    }
  }


  // search products Method
  Future<void> searchProducts(String query) async {
    emit(state.copyWith(searchProductsApiState: GeneralApiState<SearchModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.searchProducts(query: query).then((searchModel) {
      emit(state.copyWith(searchProductsApiState: GeneralApiState<SearchModel>(
        apiCallState: APICallState.loaded,
        model: searchModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(searchProductsApiState: GeneralApiState<SearchModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }


}
