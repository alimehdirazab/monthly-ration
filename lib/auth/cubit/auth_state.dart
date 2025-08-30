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
    ];
}
