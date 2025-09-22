
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
  Future<void> addToCart({required int productId, required int quantity,String? color,String? size, int? attributeValueId}) async {
    emit(state.copyWith(addToCartApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.addToCart(productId: productId, quantity: quantity,color: color,size: size, attributeValueId: attributeValueId).then((_) {
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
    emit(state.copyWith(applyCouponApiState: GeneralApiState<void>(
      apiCallState: APICallState.loading,
    )));

    await homeRepository.applyCoupon(couponCode: couponCode, orderAmount: orderAmount).then((_) {
      emit(state.copyWith(applyCouponApiState: GeneralApiState<void>(
        apiCallState: APICallState.loaded,
      )));
    }).catchError((error) {
      emit(state.copyWith(applyCouponApiState: GeneralApiState<void>(
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

    await homeRepository.checkout(
      addressId: addressId,
      paymentMethod: paymentMethod,
      cart: cart,
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

}
