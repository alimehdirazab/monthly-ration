// ignore_for_file: always_specify_types
import "dart:async";

import "package:authentication_repository/authentication_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:formz/formz.dart";
import "package:grocery_flutter_app/utils/utils.dart";
import "package:grocery_flutter_app/utils/validators/validators.dart";

part "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authenticationRepository) : super(AuthState());

  final AuthenticationRepository authenticationRepository;
  Timer? _timer;

  // Mobile number validation
  void mobileNumberChanged(String mobile) {
    final InvalidValidationInput dirtyMobile = InvalidValidationInput.dirty(phoneNumberPattern, mobile);
    emit(state.copyWith(
      mobileNumber: dirtyMobile,
      isMobileNumberValid: Formz.validate([dirtyMobile]),
    ));
  }

  // send OTP
  Future<void> sendOtp() async {
    if (!state.isMobileNumberValid) return;
    emit(state.copyWith(mobileNumberStatus: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.sendOtp(state.mobileNumber.value).then((_) {
      emit(state.copyWith(mobileNumberStatus: GeneralApiState<void>(
        apiCallState: APICallState.loaded
      )));
      _startResendOtpTimer();
    }).catchError((error) {
      emit(state.copyWith(mobileNumberStatus: GeneralApiState<void>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });

  }

  // OTP validation
  void otpChanged(String otp) {
    final InvalidValidationInput dirtyOtp = InvalidValidationInput.dirty(fourLimitPattern, otp);
    emit(state.copyWith(
      otp: dirtyOtp,
      isOtpValid: Formz.validate([dirtyOtp]),
    ));
  }

  // Resend OTP
  Future<void> resendOtp() async {
    emit(state.copyWith(otpStatus: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.resendOtp(state.mobileNumber.value).then((_) {
      emit(state.copyWith(otpStatus: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
      _startResendOtpTimer();
    }).catchError((error) {
      emit(state.copyWith(otpStatus: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Login with OTP (This will authenticate the user)
  Future<void> loginWithOtp() async {
    emit(state.copyWith(otpStatus: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.loginWithOtp(state.mobileNumber.value, state.otp.value).then((_) {
      emit(state.copyWith(otpStatus: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(otpStatus: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Start OTP resend timer
  void _startResendOtpTimer() {
    emit(state.copyWith(otpResendCountdown: 30, canResendOtp: false));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.otpResendCountdown > 0) {
        emit(state.copyWith(otpResendCountdown: state.otpResendCountdown - 1));
      } else {
        emit(state.copyWith(canResendOtp: true));
        _timer?.cancel();
      }
    });
  }

  // Logout
  void logout() {
    authenticationRepository.logout();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
