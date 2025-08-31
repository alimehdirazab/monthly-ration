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

  // Update profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    emit(state.copyWith(updateProfileApiState: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.updateProfile(name, email, phone).then((_) {
      emit(state.copyWith(updateProfileApiState: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(updateProfileApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Get Address
  Future<void> getAddress() async {
    emit(state.copyWith(getAddressApiState: GeneralApiState(
      apiCallState: APICallState.loading
    ),
    setAddressApiState: GeneralApiState(),
    deleteAddressApiState: GeneralApiState(),
    createAddressApiState: GeneralApiState(),
    updateAddressApiState: GeneralApiState(),
    ));

    await authenticationRepository.getAddresses().then((address) {
      emit(state.copyWith(getAddressApiState: GeneralApiState(
        apiCallState: APICallState.loaded,
        model: address
      )));
    }).catchError((error) {
      emit(state.copyWith(getAddressApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Create Address
  Future<void> createAddress({
  required String name,
  required String phone,
  required String addressLine1,
  required String addressLine2,
  required String city,
  required String statee,
  required String country,
  required String pincode,
  required bool isDefault,
}) async {
    emit(state.copyWith(createAddressApiState: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.createAddress(
      name: name,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: statee,
      country: country,
      pincode: pincode,
      isDefault: isDefault,
    ).then((_) {
      emit(state.copyWith(createAddressApiState: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(createAddressApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // Update Address
  Future<void> updateAddress({
    required int id,
    required String name,
    required String phone,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String statee,
    required String country,
    required String pincode,
    required bool isDefault,
  }) async {
    emit(state.copyWith(updateAddressApiState: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.updateAddress(
      id: id,
      name: name,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: statee,
      country: country,
      pincode: pincode,
      isDefault: isDefault,
    ).then((_) {
      emit(state.copyWith(updateAddressApiState: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(updateAddressApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // set Address
  Future<void> setAddress({required int id}) async {
    emit(state.copyWith(setAddressApiState: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.setDefaultAddress(id).then((_) {
      emit(state.copyWith(setAddressApiState: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(setAddressApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // delete Address
  Future<void> deleteAddress({required int id}) async {
    emit(state.copyWith(deleteAddressApiState: GeneralApiState(
      apiCallState: APICallState.loading
    )));

    await authenticationRepository.deleteAddress(id).then((_) {
      emit(state.copyWith(deleteAddressApiState: GeneralApiState(
        apiCallState: APICallState.loaded
      )));
    }).catchError((error) {
      emit(state.copyWith(deleteAddressApiState: GeneralApiState(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
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
