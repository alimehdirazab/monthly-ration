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
