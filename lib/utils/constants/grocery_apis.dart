part of 'constants.dart';

class GroceryApis {
  GroceryApis._internal();

  static final GroceryApis _instance = GroceryApis._internal();

  factory GroceryApis() {
    return _instance;
  }

  /// Production
  static const String baseUrl =
      "https://monthlyration.in";


//User Side API Endpoints
  static const String baseApiUrl = "$baseUrl/api/v1/";
  static const String sendOtp = "send-otp";
  static const String resendOtp = "resend-otp";
  // login with otp
  static const String loginWithOtp = "login-with-otp";
  // profile
  static const String profile = "profile";
  // update profile
  static const String updateProfile = "profile/update";
  // update profile image
  static const String updateProfileImage = "profile-image/update";
  // addresses
  static const String addresses = "addresses";
  // create address
  static const String createAddress = "addresses/create";
  // update address
  static const String updateAddress = "addresses/update";
  // set address as default
  static const String setDefaultAddress = "addresses/setdefault";
  // delete address
  static const String deleteAddress = "addresses/delete";
  // logout
  static const String logout = "customer/logout";
  // banners
  static const String banners = "banners";
  // categories
  static const String categories = "categories";
  // products
  static const String products = "products";
  // product details
  static const String productDetails = "products/details";
  // default categories
  static const String defaultCategories = "default-categories";
  // wallet recharge
  static const String walletRecharge = "wallet/recharge";
  //  wallet verify
  static const String walletVerify = "wallet/verify";
  // about us
  static const String aboutUs = "about-us";
  // privacy policy
  static const String privacyPolicy = "privacy-policy";
  // terms and conditions
  static const String termsAndConditions = "terms-and-conditions";
  // faqs
  static const String faqs = "faqs";
  // add to cart
  static const String addToCart = "cart/add";
  // get cart items
  static const String getCartItems = "carts";
  // update cart item
  static const String updateCartItem = "cart/update";
  // delete cart item
  static const String deleteCartItem = "cart/delete";
  // clear cart
  static const String clearCart = "cart/clear";
  // get coupons
  static const String getCoupons = "coupons";
  // apply coupon
  static const String applyCoupon = "apply-coupon";
  // checkout
  static const String checkout = "checkout";
  // order-payment-varify
  static const String orderPaymentVerify = "order-payment-varify";
  // orders
  static const String orders = "orders";
  // shipping fee
  static const String shippingFee = "settings/shipping";
  // handling fee
  static const String handlingFee = "settings/handling";
  // submit review
  static const String submitReview = "orders/review/create";
  // /wallet/history
  static const String walletHistory = "wallet/history";
  // order invoice
  static const String orderInvoice = "orders/invoice";
  // trending products
  static const String trendingProducts = "tranding-products";
  

  initBaseUrlAndAuthEndpoints() {
    ApiConfig.baseUrl = baseApiUrl;
    AuthenticationEndpoints.sendOtp = sendOtp;
    AuthenticationEndpoints.resendOtp = resendOtp;
    AuthenticationEndpoints.loginWithOtp = loginWithOtp;
    AuthenticationEndpoints.profile = profile;
    AuthenticationEndpoints.updateProfile = updateProfile;
    AuthenticationEndpoints.updateProfileImage = updateProfileImage;
    AuthenticationEndpoints.addresses = addresses;
    AuthenticationEndpoints.createAddress = createAddress;
    AuthenticationEndpoints.updateAddress = updateAddress;
    AuthenticationEndpoints.setDefaultAddress = setDefaultAddress;
    AuthenticationEndpoints.deleteAddress = deleteAddress;
    AuthenticationEndpoints.logout = logout;
  }
}
