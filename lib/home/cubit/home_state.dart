part of 'home_cubit.dart';
class HomeState extends Equatable {
   const HomeState({
    this.cartItems =const  [],
     // banners api State
    this.bannersApiState = const GeneralApiState<BannersModel>(),
    // categories api State
    this.categoriesApiState = const GeneralApiState<CategoryModel>(),
    // default categories api State
    this.defaultCategoriesApiState = const GeneralApiState<CategoryModel>(),
    // selected category index
    this.selectedCategoryIndex = 0,
    // products api State
    this.productsApiState = const GeneralApiState<ProductModel>(),
    // productsBySubCategory api State
    this.productsBySubCategoryApiState = const GeneralApiState<ProductModel>(),
    // product details api State
    this.productDetailsApiState = const GeneralApiState<ProductDetailsModel>(),
    // add to cart api State
    this.addToCartApiState = const GeneralApiState<void>(),
    // get cart items api State
    this.getCartItemsApiState = const GeneralApiState<CartListModel>(),
    // update cart item api State
    this.updateCartItemApiState = const GeneralApiState<void>(),
    // delete cart item api State
    this.deleteCartItemApiState = const GeneralApiState<void>(),
    // clear cart api State
    this.clearCartApiState = const GeneralApiState<void>(),
    // get coupons api State
    this.getCouponsApiState = const GeneralApiState<CouponsModel>(),
    // apply coupon api State
    this.applyCouponApiState = const GeneralApiState<void>(),
    // checkout api State
    this.checkoutApiState = const GeneralApiState<CheckoutResponse>(),
    // payment verify api State
    this.paymentVerifyApiState = const GeneralApiState<PaymentVerifyResponse>(),
    // delivery date and time selection
    this.selectedDeliveryDateIndex = 0,
    this.selectedTimeSlotIndex = 0,
    // selected address
    this.selectedAddress,
    // orders api State
    this.ordersApiState = const GeneralApiState<OrdersModel>(),
    // shipping api State
    this.shippingApiState = const GeneralApiState<ShippingModel>(),
    // handling api State
    this.handlingApiState = const GeneralApiState<HandlingModel>(),
  });
   final List<String> cartItems;
   // banners api State
   final GeneralApiState<BannersModel> bannersApiState;
   // categories api State
   final GeneralApiState<CategoryModel> categoriesApiState;
   // default categories api State
   final GeneralApiState<CategoryModel> defaultCategoriesApiState;
   // selected category index
   final int selectedCategoryIndex;
   // products api State
   final GeneralApiState<ProductModel> productsApiState;
   // productsBySubCategory api State
   final GeneralApiState<ProductModel> productsBySubCategoryApiState;
   // product details api State
   final GeneralApiState<ProductDetailsModel> productDetailsApiState;
   // add to cart api State
   final GeneralApiState<void> addToCartApiState;
   // get cart items api State
   final GeneralApiState<CartListModel> getCartItemsApiState;
   // update cart item api State
   final GeneralApiState<void> updateCartItemApiState;
   // delete cart item api State
   final GeneralApiState<void> deleteCartItemApiState;
   // clear cart api State
   final GeneralApiState<void> clearCartApiState;
   // get coupons api State
   final GeneralApiState<CouponsModel> getCouponsApiState;
   // apply coupon api State
   final GeneralApiState<void> applyCouponApiState;
   // checkout api State
   final GeneralApiState<CheckoutResponse> checkoutApiState;
   // payment verify api State
   final GeneralApiState<PaymentVerifyResponse> paymentVerifyApiState;
   // delivery date and time selection
   final int selectedDeliveryDateIndex;
   final int selectedTimeSlotIndex;
   // selected address
   final Address? selectedAddress;
   // orders api State
   final GeneralApiState<OrdersModel> ordersApiState;
   // shipping api State
    final GeneralApiState<ShippingModel> shippingApiState;
    // handling api State
    final GeneralApiState<HandlingModel> handlingApiState;

  // CopyWith
  HomeState copyWith({
    List<String>? cartItems,
    GeneralApiState<BannersModel>? bannersApiState,
    GeneralApiState<CategoryModel>? categoriesApiState,
    GeneralApiState<CategoryModel>? defaultCategoriesApiState,
    int? selectedCategoryIndex,
    GeneralApiState<ProductModel>? productsApiState,
    GeneralApiState<ProductModel>? productsBySubCategoryApiState,
    GeneralApiState<ProductDetailsModel>? productDetailsApiState,
    GeneralApiState<void>? addToCartApiState,
    GeneralApiState<CartListModel>? getCartItemsApiState,
    GeneralApiState<void>? updateCartItemApiState,
    GeneralApiState<void>? deleteCartItemApiState,
    GeneralApiState<void>? clearCartApiState,
    GeneralApiState<CouponsModel>? getCouponsApiState,
    GeneralApiState<void>? applyCouponApiState,
    GeneralApiState<CheckoutResponse>? checkoutApiState,
    GeneralApiState<PaymentVerifyResponse>? paymentVerifyApiState,
    int? selectedDeliveryDateIndex,
    int? selectedTimeSlotIndex,
    Address? selectedAddress,
    GeneralApiState<OrdersModel>? ordersApiState,
    GeneralApiState<ShippingModel>? shippingApiState,
    GeneralApiState<HandlingModel>? handlingApiState,
  }) {
    return HomeState(
      cartItems: cartItems ?? this.cartItems,
      bannersApiState: bannersApiState ?? this.bannersApiState,
      categoriesApiState: categoriesApiState ?? this.categoriesApiState,
      defaultCategoriesApiState: defaultCategoriesApiState ?? this.defaultCategoriesApiState,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      productsApiState: productsApiState ?? this.productsApiState,
      productsBySubCategoryApiState: productsBySubCategoryApiState ?? this.productsBySubCategoryApiState,
      productDetailsApiState: productDetailsApiState ?? this.productDetailsApiState,
      addToCartApiState: addToCartApiState ?? this.addToCartApiState,
      getCartItemsApiState: getCartItemsApiState ?? this.getCartItemsApiState,
      updateCartItemApiState: updateCartItemApiState ?? this.updateCartItemApiState,
      deleteCartItemApiState: deleteCartItemApiState ?? this.deleteCartItemApiState,
      clearCartApiState: clearCartApiState ?? this.clearCartApiState,
      getCouponsApiState: getCouponsApiState ?? this.getCouponsApiState,
      applyCouponApiState: applyCouponApiState ?? this.applyCouponApiState,
      checkoutApiState: checkoutApiState ?? this.checkoutApiState,
      paymentVerifyApiState: paymentVerifyApiState ?? this.paymentVerifyApiState,
      selectedDeliveryDateIndex: selectedDeliveryDateIndex ?? this.selectedDeliveryDateIndex,
      selectedTimeSlotIndex: selectedTimeSlotIndex ?? this.selectedTimeSlotIndex,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      ordersApiState: ordersApiState ?? this.ordersApiState,
      shippingApiState: shippingApiState ?? this.shippingApiState,
      handlingApiState: handlingApiState ?? this.handlingApiState,

    );
  }
  
  @override
  List<Object?> get props => [
    cartItems,
    bannersApiState,
    categoriesApiState,
    defaultCategoriesApiState,
    selectedCategoryIndex,
    productsApiState,
    productsBySubCategoryApiState,
    productDetailsApiState,
    addToCartApiState,
    getCartItemsApiState,
    updateCartItemApiState,
    deleteCartItemApiState,
    clearCartApiState,
    getCouponsApiState,
    applyCouponApiState,
    checkoutApiState,
    paymentVerifyApiState,
    selectedDeliveryDateIndex,
    selectedTimeSlotIndex,
    selectedAddress,
    ordersApiState,
    shippingApiState,
    handlingApiState,
    ];
}