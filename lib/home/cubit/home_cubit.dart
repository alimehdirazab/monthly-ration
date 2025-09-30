
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_flutter_app/home/repository/models/models.dart';
import 'package:grocery_flutter_app/home/repository/repository.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

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

  // reset PDF generation state
  void resetPdfGenerationState() {
    emit(state.copyWith(
      pdfGenerationApiState: GeneralApiState<String>(
        apiCallState: APICallState.initial,
      ),
    ));
  }

  // reset order invoice state
  void resetOrderInvoiceState() {
    emit(state.copyWith(
      orderInvoiceApiState: GeneralApiState<OrderInvoiceModel>(
        apiCallState: APICallState.initial,
      ),
    ));
  }

  // reset all invoice and PDF states
  void resetAllInvoiceStates() {
    emit(state.copyWith(
      orderInvoiceApiState: GeneralApiState<OrderInvoiceModel>(
        apiCallState: APICallState.initial,
      ),
      pdfGenerationApiState: GeneralApiState<String>(
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

  Future<void> getOrderInvoice(int orderId) async {
    emit(state.copyWith(orderInvoiceApiState: GeneralApiState<OrderInvoiceModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getOrderInvoice(orderId: orderId).then((orderInvoiceModel) {
      emit(state.copyWith(orderInvoiceApiState: GeneralApiState<OrderInvoiceModel>(
        apiCallState: APICallState.loaded,
        model: orderInvoiceModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(orderInvoiceApiState: GeneralApiState<OrderInvoiceModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  Future<void> generateInvoicePdf(OrderInvoiceModel invoiceData) async {
    emit(state.copyWith(pdfGenerationApiState: GeneralApiState<String>(
      apiCallState: APICallState.loading,
    )));

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) => [
            // Company Header with QR Code
            _buildCompanyHeader(invoiceData),
            pw.SizedBox(height: 15),
            
            // Tax Invoice Title with Invoice Details
            _buildInvoiceHeaderSection(invoiceData),
            pw.SizedBox(height: 15),
            
            // Bill To and Ship To Section
            _buildBillToShipToSection(invoiceData),
            pw.SizedBox(height: 15),
            
            // Items Table
            _buildInvoiceItemsTable(invoiceData),
            pw.SizedBox(height: 15),
            
            // Summary Section
            _buildInvoiceSummarySection(invoiceData),
            pw.SizedBox(height: 20),
            
            // Footer Notes
            _buildInvoiceFooter(),
          ],
        ),
      );

      // Save and share PDF
      final bytes = await pdf.save();
      final filePath = await _savePdfToDevice(bytes, 'invoice_${invoiceData.invoice?.orderNo ?? 'unknown'}.pdf');
      
      // Emit success state with file path
      emit(state.copyWith(pdfGenerationApiState: GeneralApiState<String>(
        apiCallState: APICallState.loaded,
        model: filePath,
      )));
      
    } catch (e) {
      print('Error generating PDF: $e');
      emit(state.copyWith(pdfGenerationApiState: GeneralApiState<String>(
        apiCallState: APICallState.failure,
        errorMessage: 'Failed to generate PDF: ${e.toString()}',
      )));
    }
  }

  // Professional Invoice Header
  // Company Header with QR Code
  pw.Widget _buildCompanyHeader(OrderInvoiceModel invoiceData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                invoiceData.seller?.name ?? '',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              if (invoiceData.seller?.address != null) ...[
                pw.SizedBox(height: 5),
                pw.Text(invoiceData.seller!.address!, style: const pw.TextStyle(fontSize: 9)),
              ] else ...[
                pw.SizedBox(height: 5),
                pw.Text('GF, MIRCHAI MANDI,GOLA ROAD,MUFAZARPUR,BIHAR,842001', style: const pw.TextStyle(fontSize: 9)),
              ],
              pw.SizedBox(height: 8),
              if (invoiceData.seller?.gstin != null) 
                pw.Text('GSTIN: ${invoiceData.seller!.gstin}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))
              else 
                pw.Text('GSTIN: ', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              if (invoiceData.seller?.fssai != null) 
                pw.Text('FSSAI: ${invoiceData.seller!.fssai}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))
              else
                pw.Text('FSSAI: ', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
        // QR Code placeholder
        // pw.Container(
        //   width: 70, 
        //   height: 70,
        //   decoration: pw.BoxDecoration(border: pw.Border.all()),
        //   child: pw.Center(
        //     child: pw.Text('QR CODE', 
        //       style: const pw.TextStyle(fontSize: 8),
        //       textAlign: pw.TextAlign.center
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Tax Invoice Header Section
  pw.Widget _buildInvoiceHeaderSection(OrderInvoiceModel invoiceData) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        children: [
          // Title
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Center(
              child: pw.Text(
                'TAX INVOICE/BILL OF SUPPLY', 
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
          // Invoice Details
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide()),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide())),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (invoiceData.invoice?.invoiceNo != null)
                          pw.Text('Invoice No.: ${invoiceData.invoice!.invoiceNo}', 
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        if (invoiceData.invoice?.orderNo != null)
                          pw.Text('Order No.: ${invoiceData.invoice!.orderNo}', 
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (invoiceData.invoice?.placeOfSupply != null)
                          pw.Text('Place Of Supply : ${invoiceData.invoice!.placeOfSupply}', 
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        if (invoiceData.invoice?.date != null)
                          pw.Text('Date : ${invoiceData.invoice!.date}', 
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bill To and Ship To Section  
  pw.Widget _buildBillToShipToSection(OrderInvoiceModel invoiceData) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        children: [
          // Bill To
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide())),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bill To', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  if (invoiceData.customer?.name != null) ...[
                    pw.Text(invoiceData.customer!.name!, 
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                  ],
                  if (invoiceData.customer?.billingAddress != null)
                    pw.Text(invoiceData.customer!.billingAddress!, 
                      style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            ),
          ),
          // Ship To
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Ship To', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  if (invoiceData.customer?.name != null) ...[
                    pw.Text(invoiceData.customer!.name!, 
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                  ],
                  if (invoiceData.customer?.shippingAddress != null)
                    pw.Text(invoiceData.customer!.shippingAddress!, 
                      style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Invoice Items Table
  pw.Widget _buildInvoiceItemsTable(OrderInvoiceModel invoiceData) {
    final items = invoiceData.items ?? [];
    
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FixedColumnWidth(20),   // SR No
        1: const pw.FlexColumnWidth(3.5),  // Item & Description  
        2: const pw.FixedColumnWidth(35),  // HSN
        3: const pw.FixedColumnWidth(20),  // Qty
        4: const pw.FixedColumnWidth(35),  // Product Rate
        5: const pw.FixedColumnWidth(25),  // Disc.
        6: const pw.FixedColumnWidth(40),  // Taxable Amt.
        7: const pw.FixedColumnWidth(30),  // CGST
        8: const pw.FixedColumnWidth(40),  // SGST/IGST
        9: const pw.FixedColumnWidth(30),  // Cess
        10: const pw.FixedColumnWidth(30), // Cess Amt.
        11: const pw.FixedColumnWidth(40), // Total Amt.
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableHeader('SR\nNo'),
            _buildTableHeader('Item &\nDescription'),
            _buildTableHeader('HSN'),
            _buildTableHeader('Qty'),
            _buildTableHeader('Product\nRate'),
            _buildTableHeader('Disc.'),
            _buildTableHeader('Taxable\nAmt.'),
            _buildTableHeader('CGST'),
            _buildTableHeader('S/UT\nGST\nAmt.'),
            _buildTableHeader('Cess'),
            _buildTableHeader('Cess\nAmt.'),
            _buildTableHeader('Total\nAmt.'),
          ],
        ),
        // Data Rows
        ...items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return pw.TableRow(children: [
            _buildTableCell('$index'),
            _buildTableCell(item.productName ?? '', isLeft: true),
            _buildTableCell(item.hsn ?? ''),
            _buildTableCell('${item.qty ?? 1}'),
            _buildTableCell(item.rate ?? '0.00'),
            _buildTableCell(item.discount ?? '0.00%'),
            _buildTableCell('${item.taxableAmt?.toStringAsFixed(2) ?? '0.00'}'),
            _buildTableCell('${item.cgstRate ?? '0.00'}%\n${item.cgstAmt?.toStringAsFixed(2) ?? '0.00'}'),
            _buildTableCell('${item.sgstRate ?? item.igstRate ?? '0.00'}%\n${item.sgstAmt ?? item.igstAmt ?? '0.00'}'),
            _buildTableCell('0.00%\n+ 0.00'), // Cess - not in model
            _buildTableCell('0.00'), // Cess Amt - not in model
            _buildTableCell('${item.totalAmt?.toStringAsFixed(2) ?? '0.00'}'),
          ]);
        }),
      ],
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text, 
        style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold), 
        textAlign: pw.TextAlign.center
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isLeft = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text, 
        style: const pw.TextStyle(fontSize: 7), 
        textAlign: isLeft ? pw.TextAlign.left : pw.TextAlign.center
      ),
    );
  }

  // Invoice Summary Section
  pw.Widget _buildInvoiceSummarySection(OrderInvoiceModel invoiceData) {
    final summary = invoiceData.summary;
    if (summary == null) return pw.SizedBox();
    
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              width: 150,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                children: [
                  if (summary.itemTotal != null)
                    _buildSummaryRow('Item Total', '${summary.itemTotal!.toStringAsFixed(2)}'),
                  if (summary.handlingCharge != null && summary.handlingCharge! > 0)
                    _buildSummaryRow('Handling Fee (Inclusive of Taxes)', '${summary.handlingCharge}.45'),
                  _buildSummaryRow('Invoice Value', '${summary.invoiceValue ?? '0'}', isBold: true),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        // Additional invoice info
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Whether GST is payable on reverse charge - No', 
                    style: const pw.TextStyle(fontSize: 8)),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Charges for supplementary above (for instance, Delivery Charges, Surge Fee, Packaging Charges, etc.) are apportioned to each product included in this invoice in the ratio of taxable value for computation of applicable Goods and Services Tax and/or Compensation Cess, and accordingly, Goods and Services Tax and/or Compensation Cess as computed, are levied. (Items wise tax is amounts are disclosed with invoice)',
                    style: const pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Invoice Footer
  pw.Widget _buildInvoiceFooter() {
    return pw.Column(
      children: [
        // Annexure section
        pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Center(
                  child: pw.Text('Annexure', 
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ),
              ),
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide())),
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                    5: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    // Header
                    pw.TableRow(children: [
                      _buildAnnexureHeader('Tax Rate'),
                      _buildAnnexureHeader('Cess Rate'),
                      _buildAnnexureHeader('Taxable Value'),
                      _buildAnnexureHeader('CGST'),
                      _buildAnnexureHeader('S/UT GST'),
                      _buildAnnexureHeader('Cess'),
                    ]),
                    // Sample data rows - you can customize based on your needs
                    pw.TableRow(children: [
                      _buildAnnexureCell('0.00%'),
                      _buildAnnexureCell('0.00%'),
                      _buildAnnexureCell('1.76'),
                      _buildAnnexureCell('0.00'),
                      _buildAnnexureCell('0.00'),
                      _buildAnnexureCell('0.00'),
                    ]),
                    pw.TableRow(children: [
                      _buildAnnexureCell('12.00%'),
                      _buildAnnexureCell('0.00%'),
                      _buildAnnexureCell('7.25'),
                      _buildAnnexureCell('0.44'),
                      _buildAnnexureCell('0.44'),
                      _buildAnnexureCell('0.00'),
                    ]),
                    pw.TableRow(children: [
                      _buildAnnexureCell('18.00%'),
                      _buildAnnexureCell('0.00%'),
                      _buildAnnexureCell('0.99'),
                      _buildAnnexureCell('0.09'),
                      _buildAnnexureCell('0.09'),
                      _buildAnnexureCell('0.00'),
                    ]),
                    pw.TableRow(children: [
                      _buildAnnexureCell('28.00%'),
                      _buildAnnexureCell('12.00%'),
                      _buildAnnexureCell('0.99'),
                      _buildAnnexureCell('0.14'),
                      _buildAnnexureCell('0.14'),
                      _buildAnnexureCell('0.12'),
                    ]),
                    // Total row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _buildAnnexureCell('Total', isBold: true),
                        _buildAnnexureCell(''),
                        _buildAnnexureCell('10.99', isBold: true),
                        _buildAnnexureCell('0.67', isBold: true),
                        _buildAnnexureCell('0.67', isBold: true),
                        _buildAnnexureCell('0.12', isBold: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 15),
        // Company footer info
        pw.Container(
          width: double.infinity,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Order Delivered from :', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.Text('SAGAR KUMAR CHAUDHARY (M/S GAURAV KIRANA)', 
                style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 5),
              pw.Text('E-commerce Platform (FBO) Information :', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.Text('M/S GAURAV KIRANA', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('GF, MIRCHAI MANDI,GOLA ROAD,MUFAZARPUR,BIHAR,842001', 
                style: const pw.TextStyle(fontSize: 8)),
             // pw.Text('Bihar', style: const pw.TextStyle(fontSize: 8)),
              // pw.Text('FSSAI Lic. No. ', style: const pw.TextStyle(fontSize: 8)),
              // pw.Text('Email: support@zeptopow.com', style: const pw.TextStyle(fontSize: 8)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildAnnexureHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, 
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), 
        textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _buildAnnexureCell(String text, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, 
        style: pw.TextStyle(
          fontSize: 8, 
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal
        ), 
        textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }



  Future<String> _savePdfToDevice(Uint8List bytes, String fileName) async {
    try {
      if (Platform.isAndroid) {
        // Storage permissions should already be checked in UI, but double-check here
        var storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          throw Exception('Storage permission required but not granted');
        }

        // Try different approaches to save to Downloads
        Directory? downloadsDirectory;
        String finalPath = '';
        
        // Method 1: Try direct Downloads directory access
        try {
          if (await Directory('/storage/emulated/0/Download').exists()) {
            downloadsDirectory = Directory('/storage/emulated/0/Download');
            finalPath = '${downloadsDirectory.path}/$fileName';
          } else if (await Directory('/storage/emulated/0/Downloads').exists()) {
            downloadsDirectory = Directory('/storage/emulated/0/Downloads');  
            finalPath = '${downloadsDirectory.path}/$fileName';
          }
          
          if (finalPath.isNotEmpty) {
            final file = File(finalPath);
            await file.writeAsBytes(bytes);
            print('PDF saved to Downloads: $finalPath');
            return finalPath;
          }
        } catch (e) {
          print('Could not save to Downloads directory: $e');
        }
        
        // Method 2: Fallback to external storage directory with clear naming
        try {
          final directory = await getExternalStorageDirectory();
          if (directory != null) {
            // Create a "Downloads" subfolder in the app's external directory
            final appDownloadsDir = Directory('${directory.path}/Downloads');
            if (!await appDownloadsDir.exists()) {
              await appDownloadsDir.create(recursive: true);
            }
            
            final file = File('${appDownloadsDir.path}/$fileName');
            await file.writeAsBytes(bytes);
            
            print('PDF saved to app Downloads: ${file.path}');
            return file.path;
          }
        } catch (e) {
          print('Could not save to app external directory: $e');
        }
        
        throw Exception('Unable to save file to device storage');
        
      } else if (Platform.isIOS) {
        // For iOS - save to Documents directory (iOS doesn't have direct Downloads access)
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);
        
        print('PDF saved to: ${file.path}');
        return file.path;
        
      } else {
        throw Exception('Platform not supported for file saving');
      }
    } catch (e) {
      print('Error saving PDF: $e');
      throw Exception('Failed to save PDF: $e');
    }
  }

   // trending products Method
  Future<void> getTrendingProducts() async {
    emit(state.copyWith(trendingProductsApiState: GeneralApiState<ProductModel>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.getTrendingProducts().then((productModel) {
      emit(state.copyWith(trendingProductsApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.loaded,
        model: productModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(trendingProductsApiState: GeneralApiState<ProductModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });

  }

}