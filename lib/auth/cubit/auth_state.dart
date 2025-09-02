part of "auth_cubit.dart";

class AuthState extends Equatable {
  const AuthState({
    // Mobile Number Input
    this.mobileNumberStatus = const GeneralApiState<void>(),
    this.mobileNumber = const InvalidValidationInput.pure(phoneNumberPattern),
    this.isMobileNumberValid = false,
    // OTP Input
    this.otpStatus = const GeneralApiState<void>(),
    this.otp = const InvalidValidationInput.pure(fourLimitPattern),
    this.isOtpValid = false,
    // Resend OTP
    this.otpResendStatus = const GeneralApiState<void>(),
    this.otpResendCountdown = 30,
    this.canResendOtp = false,
    // update profile Api State
    this.updateProfileApiState = const GeneralApiState<void>(),
    // update profile image Api State
    this.updateProfileImageApiState = const GeneralApiState<void>(),
    // get Address Api State
    this.getAddressApiState = const GeneralApiState<AddressesResponse>(),
    // create Address Api State
    this.createAddressApiState = const GeneralApiState<void>(),
    // update Address Api State
    this.updateAddressApiState = const GeneralApiState<void>(),
    // set Address Api State
    this.setAddressApiState = const GeneralApiState<void>(),
    // delete Address Api State
    this.deleteAddressApiState = const GeneralApiState<void>(),
  });

  // Mobile Number Input
  final GeneralApiState<void> mobileNumberStatus;
  final InvalidValidationInput mobileNumber;
  final bool isMobileNumberValid;

  /// OTP Input
  final GeneralApiState<void> otpStatus;
  final InvalidValidationInput otp;
  final bool isOtpValid;

  //  Resend OTP
  final GeneralApiState<void> otpResendStatus;
  final int otpResendCountdown;
  final bool canResendOtp;
  // update profile Api State
  final GeneralApiState<void> updateProfileApiState;
  // update profile image Api State
  final GeneralApiState<void> updateProfileImageApiState;
  // get Address Api State
  final GeneralApiState<AddressesResponse> getAddressApiState;
  // create Address Api State
  final GeneralApiState<void> createAddressApiState;
  // update Address Api State
  final GeneralApiState<void> updateAddressApiState;
  // set Address Api State
  final GeneralApiState<void> setAddressApiState;
  // delete Address Api State
  final GeneralApiState<void> deleteAddressApiState;

  AuthState copyWith({
   // Mobile Number Input
   GeneralApiState<void>? mobileNumberStatus,
   InvalidValidationInput? mobileNumber,
   bool? isMobileNumberValid,
   // OTP Input
   GeneralApiState<void>? otpStatus,
   InvalidValidationInput? otp,
   bool? isOtpValid,
   // Resend OTP
   GeneralApiState<void>? otpResendStatus,
   int? otpResendCountdown,
   bool? canResendOtp,
   // update profile Api State
   GeneralApiState<void>? updateProfileApiState,
   // update profile image Api State
   GeneralApiState<void>? updateProfileImageApiState,
   // get Address Api State
   GeneralApiState<AddressesResponse>? getAddressApiState,
   // create Address Api State
   GeneralApiState<void>? createAddressApiState,
   // update Address Api State
   GeneralApiState<void>? updateAddressApiState,
   // set Address Api State
   GeneralApiState<void>? setAddressApiState,
   // delete Address Api State
   GeneralApiState<void>? deleteAddressApiState,
  }) {
    return AuthState(
     // Mobile Number Input
     mobileNumberStatus: mobileNumberStatus ?? this.mobileNumberStatus,
     mobileNumber: mobileNumber ?? this.mobileNumber,
     isMobileNumberValid: isMobileNumberValid ?? this.isMobileNumberValid,
     // OTP Input
     otpStatus: otpStatus ?? this.otpStatus,
     otp: otp ?? this.otp,
     isOtpValid: isOtpValid ?? this.isOtpValid,
     // Resend OTP
     otpResendStatus: otpResendStatus ?? this.otpResendStatus,
     otpResendCountdown: otpResendCountdown ?? this.otpResendCountdown,
     canResendOtp: canResendOtp ?? this.canResendOtp,
     // update profile Api State
     updateProfileApiState: updateProfileApiState ?? this.updateProfileApiState,
     // update profile image Api State
     updateProfileImageApiState: updateProfileImageApiState ?? this.updateProfileImageApiState,
     // get Address Api State
     getAddressApiState: getAddressApiState ?? this.getAddressApiState,
     // create Address Api State
     createAddressApiState: createAddressApiState ?? this.createAddressApiState,
     // update Address Api State
     updateAddressApiState: updateAddressApiState ?? this.updateAddressApiState,
     // set Address Api State
     setAddressApiState: setAddressApiState ?? this.setAddressApiState,
     // delete Address Api State
     deleteAddressApiState: deleteAddressApiState ?? this.deleteAddressApiState,
    );
  }

  @override
  List<Object> get props => [
      // Mobile Number Input
      mobileNumberStatus,
      mobileNumber,
      isMobileNumberValid,
      // OTP Input
      otpStatus,
      otp,
      isOtpValid,
      // Resend OTP
      otpResendStatus,
      otpResendCountdown,
      canResendOtp,
      // update profile Api State
      updateProfileApiState,
      // update profile image Api State
      updateProfileImageApiState,
      // get Address Api State
      getAddressApiState,
      // create Address Api State
      createAddressApiState,
      // update Address Api State
      updateAddressApiState,
      // set Address Api State
      setAddressApiState,
      // delete Address Api State
      deleteAddressApiState,
    ];
}
