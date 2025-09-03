import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:general_repository/general_repository.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository(
    this.generalRepository, {
    CacheClient? cache,
  }) : _cache = cache ?? CacheClient();

  final GeneralRepository generalRepository;
  final CacheClient _cache;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  @visibleForTesting
  final StreamController<UserAuthentication> userAuth =
      StreamController<UserAuthentication>();

  /// Stream of [Customer] which will emit the current customer when
  /// the authentication state changes.
  ///
  /// Emits [UserAuthentication.empty] if the customer is not authenticated.
  Stream<UserAuthentication> get user async* {
    var userJson = _cache.read<String>(key: userCacheKey);
    yield userJson == null
        ? UserAuthentication.empty
        : UserAuthentication.fromJson(jsonDecode(userJson));
    yield* userAuth.stream.map((user) {
      _cache.write<String>(
        key: userCacheKey,
        value: jsonEncode(user.toJson()),
      );
      return user;
    });
  }

  /// Returns the current cached customer.
  /// Defaults to [UserAuthentication.empty] if there is no cached customer.
  UserAuthentication get currentUser {
    var userJson = _cache.read<String>(key: userCacheKey);
    return userJson == null
        ? UserAuthentication.empty
        : UserAuthentication.fromJson(jsonDecode(userJson));
  }


  // send otp
  Future<void> sendOtp(String mobile) async {
    String encodedBody = jsonEncode({
      "mobile": mobile,
    });

     await generalRepository.post(
      handle: AuthenticationEndpoints.sendOtp,
      body: encodedBody,
    );
  }

  // resend otp
  Future<void> resendOtp(String mobile) async {
    String encodedBody = jsonEncode({
      "mobile": mobile,
    });

    await generalRepository.post(
      handle: AuthenticationEndpoints.resendOtp,
      body: encodedBody,
    );
  }

  // login with otp
  Future<void> loginWithOtp(String mobile, String otp) async {
    String encodedBody = jsonEncode({
      "mobile": mobile,
      "otp": otp,
    });

   var responseJson = await generalRepository.post(
      handle: AuthenticationEndpoints.loginWithOtp,
      body: encodedBody,
    );

   userAuth.add(UserAuthentication.fromJson(responseJson));
  }

  // update Profile
  Future<void> updateProfile(String? name, String? email, String? phone) async {

    // update if params have data
    Map<String, String> fields = {};

    if (name != null && name.isNotEmpty && name != currentUser.customer?.name) {
      fields["name"] = name;
    }
    if (email != null && email.isNotEmpty && email != currentUser.customer?.email) {
      fields["email"] = email;
    }
    if (phone != null && phone.isNotEmpty && phone != currentUser.customer?.phone) {
      fields["phone"] = phone;
    }

    if (fields.isNotEmpty) {
       await generalRepository.post(
        handle: AuthenticationEndpoints.updateProfile,
        body: jsonEncode(fields),
      );

      var updatedUserAuth = currentUser.copyWith(
        customer: currentUser.customer?.copyWith(
          name: name ?? currentUser.customer?.name,
          email: email ?? currentUser.customer?.email,
          phone: phone ?? currentUser.customer?.phone,
        ),
      );

      userAuth.add(UserAuthentication.empty);
      userAuth.add(updatedUserAuth);
    } else {
      throw Exception("No fields to update. Please provide valid data.");
    } 
  }

  // Update Profile Image
  Future<void> updateProfileImage(File image) async {
    // Prepare file info for multipart upload
    List<Map<String, dynamic>> files = [
      {
        'fieldName': 'profile_image',
        'filePath': image.path,
        'fileName': image.path.split('/').last,
      }
    ];

    await generalRepository.multipartPost(
      handle: AuthenticationEndpoints.updateProfileImage,
      files: files,
      apiMethod: 'POST',
    );

    // update in cache
    var updatedUserAuth = currentUser.copyWith(
      customer: currentUser.customer?.copyWith(
        profileImage: image.path,
      ),
    );
    userAuth.add(updatedUserAuth);
  }

  Future<AddressesResponse> getAddresses() async {
    var responseJson = await generalRepository.get(
      handle: AuthenticationEndpoints.addresses,
    );

    return AddressesResponse.fromJson(responseJson);
  }

  // Create Address
  Future<void> createAddress({
    required String name,
    required String phone,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required bool isDefault,
  }) async {
    String encodedBody = jsonEncode({
      "name": name,
      "phone": phone,
      "address_line1": addressLine1,
      "address_line2": addressLine2,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "is_default": isDefault,
    });

    var responseJson = await generalRepository.post(
      handle: AuthenticationEndpoints.createAddress,
      body: encodedBody,
    );

    // if is_default update it in cache
    if (isDefault == true && responseJson["address"] != null) {
      var addr = responseJson["address"];
      var updatedUserAuth = currentUser.copyWith(
        customer: currentUser.customer?.copyWith(
          addressLine1: addr["address_line1"],
          addressLine2: addr["address_line2"],
          city: addr["city"],
          state: addr["state"],
          country: addr["country"],
          postalCode: addr["pincode"],
        ),
      );
      userAuth.add(updatedUserAuth);
    }
  }

  // Address Update
  Future<void> updateAddress({
    required int id,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? pincode,
    bool? isDefault,
  }) async {
    Map<String, dynamic> fields = {};

    if (name != null && name.isNotEmpty) {
      fields["name"] = name;
    }
    if (phone != null && phone.isNotEmpty) {
      fields["phone"] = phone;
    }
    if (addressLine1 != null && addressLine1.isNotEmpty) {
      fields["address_line1"] = addressLine1;
    }
    if (addressLine2 != null && addressLine2.isNotEmpty) {
      fields["address_line2"] = addressLine2;
    }
    if (city != null && city.isNotEmpty) {
      fields["city"] = city;
    }
    if (state != null && state.isNotEmpty) {
      fields["state"] = state;
    }
    if (country != null && country.isNotEmpty) {
      fields["country"] = country;
    }
    if (pincode != null && pincode.isNotEmpty) {
      fields["pincode"] = pincode;
    }
    if (isDefault != null) {
      fields["is_default"] = isDefault;
    }

    if (fields.isNotEmpty) {
      var responseJson = await generalRepository.put(
        handle: '${AuthenticationEndpoints.updateAddress}?address_id=$id',
        body: jsonEncode(fields),
      );

      // if is_default update it in cache
      if (isDefault == true && responseJson["address"] != null) {
        var addr = responseJson["address"];
        var updatedUserAuth = currentUser.copyWith(
          customer: currentUser.customer?.copyWith(
            addressLine1: addr["address_line1"],
            addressLine2: addr["address_line2"],
            city: addr["city"],
            state: addr["state"],
            country: addr["country"],
            postalCode: addr["pincode"],
          ),
        );
        userAuth.add(updatedUserAuth);
      }
    } else {
      throw Exception("No fields to update. Please provide valid data.");
    }
  }

  // Address Set Default
  Future<void> setDefaultAddress(int id) async {
    var responseJson = await generalRepository.post(
      handle: '${AuthenticationEndpoints.setDefaultAddress}?address_id=$id',
    );

    if (responseJson["address"] != null) {
      var addr = responseJson["address"];
      var updatedUserAuth = currentUser.copyWith(
        customer: currentUser.customer?.copyWith(
          addressLine1: addr["address_line1"],
          addressLine2: addr["address_line2"],
          city: addr["city"],
          state: addr["state"],
          country: addr["country"],
          postalCode: addr["pincode"],
        ),
      );
      userAuth.add(updatedUserAuth);
    }
  }

  // delete address
  Future<void> deleteAddress(int id) async {
   await generalRepository.delete(
      handle: '${AuthenticationEndpoints.deleteAddress}?address_id=$id',
    );
  }

  // Wallet Recharge - Step 1
  Future<Map<String, dynamic>> walletRecharge(String amount) async {
    String encodedBody = jsonEncode({
      "amount": amount,
    });

    var responseJson = await generalRepository.post(
      handle: AuthenticationEndpoints.walletRecharge,
      body: encodedBody,
    );

    return responseJson;
  }

  // Wallet Recharge Verify - Step 2
  Future<void> walletVerify({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    String encodedBody = jsonEncode({
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_order_id": razorpayOrderId,
      "razorpay_signature": razorpaySignature,
    });

    await generalRepository.put(
      handle: AuthenticationEndpoints.walletVerify,
      body: encodedBody,
    );

    // Note: You might want to update the user's wallet balance here
    // depending on your API response structure
  }


  /// Starts the Sign In Flow.
  // Future<void> login(String email, String password, String fcmToken,
  //     double latitude, double longitude) async {
  //   String encodedBody = jsonEncode({
  //     "email": email,
  //     "password": password,
  //     "fcmToken": fcmToken,
  //     "longitude": longitude,
  //     "latitude": latitude
  //   });

  //   var responseJson = await generalRepository.post(
  //     handle: AuthenticationEndpoints.login,
  //     body: encodedBody,
  //   );

  //   userAuth.add(UserAuthentication.fromJson(responseJson));
  // }

  void updateTokens(String token, String refreshToken) async {
    var updatedUserAuth = currentUser.copyWith(
      token: token,
      // refreshToken: refreshToken,
    );

    userAuth.add(updatedUserAuth);
  }

  // Future<void> register(
  //     String photo,
  //     String name,
  //     String email,
  //     String phone,
  //     String password,
  //     String fcmToken,
  //     double latitude,
  //     double longitude) async {
  //   Map<String, String> fields = {
  //     "name": name,
  //     "role_name": "user",
  //     "email": email,
  //     "phone_number": phone,
  //     "password": password,
  //     "social_type": 'email',
  //     "fcmToken": fcmToken,
  //     "longitude": longitude.toString(),
  //     "latitude": latitude.toString()
  //   };

  //   List<Map<String, dynamic>> files = [];
  //   files.add({
  //     'fieldName': 'image',
  //     'filePath': photo,
  //     'fileName': photo.split('/').last,
  //   });

  //   if (photo.isNotEmpty) {
  //     var responseJson = await generalRepository.multipartPost(
  //       handle: AuthenticationEndpoints.register,
  //       fields: fields,
  //       files: files,
  //       apiMethod: 'POST',
  //     );
  //     userAuth.add(UserAuthentication.fromJson(responseJson));
  //   } else {
  //     var responseJson = await generalRepository.multipartPost(
  //       handle: AuthenticationEndpoints.register,
  //       fields: fields, apiMethod: 'POST',
  //       // files: files,
  //     );
  //     userAuth.add(UserAuthentication.fromJson(responseJson));
  //   }
  // }

  // Future<void> guestRegister(
  //   String roleName,
  //   String email,
  // ) async {
  //   String encodedBody = jsonEncode({
  //     "role_name": roleName,
  //     "email": email,
  //   });

  //   var responseJson = await generalRepository.post(
  //     handle: AuthenticationEndpoints.register,
  //     body: encodedBody,
  //     // files: files,
  //   );

  //   userAuth.add(UserAuthentication.fromJson(responseJson));
  // }

  // Future<void> updateProfileInfo(
  //     String? name, String? photo, String? phone, bool? notification) async {
  //   Map<String, String> fields = {};
  //   List<Map<String, dynamic>> files = [];

  //   if (photo!.isNotEmpty) {
  //     files.add({
  //       'fieldName': 'image',
  //       'filePath': photo,
  //       'fileName': photo.split('/').last,
  //     });
  //   }

  //   if (name != null && name != currentUser.user?.name && name.isNotEmpty) {
  //     fields["name"] = name;
  //   }

  //   if (phone != null &&
  //       phone != currentUser.user?.phoneNumber &&
  //       phone.isNotEmpty) {
  //     fields["phoneNumber"] = phone;
  //   }

  //   if (fields.isNotEmpty || files.isNotEmpty) {
  //     // ignore: no_leading_underscores_for_local_identifiers
  //     var _response = await generalRepository.multipartPost(
  //       handle: AuthenticationEndpoints.updateProfile,
  //       fields: fields,
  //       files: files,
  //       apiMethod: 'PUT',
  //     );
  //     print(_response);
  //     var updatedUserAuth = currentUser.copyWith(
  //       user: currentUser.user?.copyWith(
  //           name: _response["data"]["name"] ?? currentUser.user?.name,
  //           phoneNumber: _response["data"]["phone_number"] ??
  //               currentUser.user?.phoneNumber,
  //           profilePicture: _response["data"]["profile_picture"] ??
  //               currentUser.user?.profilePicture,
  //           notification: notification),
  //       // token: responseJson["data"]["access_token"] ?? currentUser.token,
  //       // refreshToken:
  //       //     responseJson["data"]["refresh_token"] ?? currentUser.refreshToken,
  //     );

  //     userAuth.add(UserAuthentication.empty);
  //     userAuth.add(updatedUserAuth);
  //   } else {
  //     throw Exception("No fields to update. Please provide valid data.");
  //   }
  // }

  // Future<void> changeNotification(bool? notification) async {
  //   String encodedBody = jsonEncode({
  //     "notification": notification,
  //   });
  //   if (kDebugMode) {
  //     print("Encoded body $encodedBody");
  //   }
  //   var response = await generalRepository.put(
  //     handle: AuthenticationEndpoints.updateProfile,
  //     body: encodedBody,
  //   );
  //   // header: {'Content-Type': 'multipart/form-data'});
  //   if (kDebugMode) {
  //     print(response);
  //   }

  //   var updatedUserAuth = currentUser.copyWith(
  //     user: currentUser.user?.copyWith(
  //       notification: notification ?? currentUser.user?.notification,
  //     ),
  //   );

  //   userAuth.add(UserAuthentication.empty);
  //   userAuth.add(updatedUserAuth);
  // }

  // Future<void> updateProfileInfo(
  //     String name, String phone, String? photo) async {
  //   Map<String, String> fields = {
  //     "name": name,
  //     "phoneNumber": phone,
  //   };

  //   List<Map<String, dynamic>> files = [];
  //   if (photo != null) {
  //     files.add({
  //       'fieldName': 'image',
  //       'filePath': photo,
  //       'fileName': photo.split('/').last,
  //     });
  //   }

  //   var responseJson = await generalRepository.multipartPost(
  //     handle: AuthenticationEndpoints.updateProfile,
  //     fields: fields,
  //     files: files,
  //   );

  //   var updatedUserAuth = currentUser.copyWith(
  //     user: currentUser.user?.copyWith(
  //       name: responseJson["user"]["name"],
  //       // dateofbirth: responseJson["user"]["dateofbirth"],
  //       // profilePic: responseJson["user"]["profile_pic"],
  //     ),
  //   );

  //   userAuth.add(UserAuthentication.empty);
  //   userAuth.add(updatedUserAuth);
  // }

  // Future<void> changePassword(
  //   String email,
  //   String oldPassword,
  //   String newPassword,
  // ) async {
  //   String encodedBody = jsonEncode({
  //     "email": email,
  //     "old_password": oldPassword,
  //     "new_password": newPassword,
  //   });

  //   await generalRepository.post(
  //     handle: AuthenticationEndpoints.changePassword,
  //     body: encodedBody,
  //   );
  // }

  // Future<void> forgotPasswordEmailSent(String email) async {
  //   String encodedBody = jsonEncode({
  //     "email": email,
  //   });

  //   await generalRepository.post(
  //     handle: AuthenticationEndpoints.forgotPassword,
  //     body: encodedBody,
  //   );
  // }

  // Future<void> forgotPasswordOtpVerified(String email, String otp) async {
  //   String encodedBody = jsonEncode({"email": email, "otp": otp});

  //   await generalRepository.post(
  //     handle: AuthenticationEndpoints.verifyOtp,
  //     body: encodedBody,
  //   );
  // }

  // Future<void> forgotPassword(
  //     String email, String password, String confirmPassword) async {
  //   String encodedBody = jsonEncode({
  //     "email": email,
  //     "newPassword": password,
  //     "confirmPassword": confirmPassword
  //   });
  //   await generalRepository.post(
  //     handle: AuthenticationEndpoints.resetPassword,
  //     body: encodedBody,
  //   );
  // }

  // Future<void> deleteAccount() async {
  //   await generalRepository
  //       .delete(
  //     handle: AuthenticationEndpoints.deleteAccount,
  //   )
  //       .then((_) {
  //     userAuth.add(UserAuthentication.empty);
  //   });
  // }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  Future<void> logout() async {
    await generalRepository
        .post(
      handle: AuthenticationEndpoints.logout,
    )
        .then((_) {
      userAuth.add(UserAuthentication.empty);
    });
  }

  void clearUser() {
    userAuth.add(UserAuthentication.empty);
  }

  // Future<void> signInWithGoogle(String fcmToken) async {
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn();

  //     await googleSignIn.signOut();

  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //     if (googleUser == null) {
  //       throw Exception('Google Sign-In was canceled by the user.');
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final String? idToken = googleAuth.idToken;

  //     if (idToken != null) {
  //       print("Google ID Token: $idToken");

  //       var responseJson = await generalRepository.post(
  //         handle: AuthenticationEndpoints.login,
  //         header: {'Content-Type': 'application/json'},
  //         body: jsonEncode({
  //           "authToken": idToken,
  //           "social_type": "google",
  //           "roleName": "user",
  //           "fcmToken": fcmToken,
  //         }),
  //       );

  //       userAuth.add(UserAuthentication.fromJson(responseJson));
  //     }
  //   } catch (e) {
  //     throw Exception('Error signing in with Google: $e');
  //   }
  // }

  // Future<void> signInWithApple(String fcmToken) async {
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final String? idToken = appleCredential.identityToken;

  //     if (idToken == null || idToken.isEmpty) {
  //       throw Exception('Apple Sign-In failed to retrieve identity token.');
  //     }

  //     var responseJson = await generalRepository.post(
  //       handle: 'social-signup',
  //       header: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "authToken": idToken,
  //         "social_type": "apple",
  //         "type": "user",
  //         "fcm": fcmToken,
  //       }),
  //     );

  //     userAuth.add(UserAuthentication.fromJson(responseJson));
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     if (e.code == AuthorizationErrorCode.canceled) {
  //       throw Exception('Apple Sign-In was canceled by the user.');
  //     } else {
  //       throw Exception('Apple Sign-In authorization error: ${e.message}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error signing in with Apple: $e');
  //   }
  // }

  /// disposes the userAuth stream
  void dispose() => userAuth.close();
}
