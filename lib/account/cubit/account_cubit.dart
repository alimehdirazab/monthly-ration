import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_flutter_app/account/repository/repository.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.accountRepository) : super(const AccountState());
  final AccountRepository accountRepository;

  // get about us
  Future<void> getAboutUs() async {
    emit(state.copyWith(aboutUsApiState: const GeneralApiState<AboutUsModel>(
      apiCallState: APICallState.loading,
    )));

    await accountRepository.getAboutUs().then((aboutUsModel) {
      emit(state.copyWith(aboutUsApiState: GeneralApiState<AboutUsModel>(
        apiCallState: APICallState.loaded,
        model: aboutUsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(aboutUsApiState: GeneralApiState<AboutUsModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get privacy policy
  Future<void> getPrivacyPolicy() async {
    emit(state.copyWith(privacyPolicyApiState: const GeneralApiState<PrivacyPolicyModel>(
      apiCallState: APICallState.loading,
    )));

    await accountRepository.getPrivacyPolicy().then((privacyPolicyModel) {
      emit(state.copyWith(privacyPolicyApiState: GeneralApiState<PrivacyPolicyModel>(
        apiCallState: APICallState.loaded,
        model: privacyPolicyModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(privacyPolicyApiState: GeneralApiState<PrivacyPolicyModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get terms and conditions
  Future<void> getTermsAndConditions() async {
    emit(state.copyWith(termsAndConditionsApiState: const GeneralApiState<TermsAndConditionModel>(
      apiCallState: APICallState.loading,
    )));

    await accountRepository.getTermsAndConditions().then((termsAndConditionsModel) {
      emit(state.copyWith(termsAndConditionsApiState: GeneralApiState<TermsAndConditionModel>(
        apiCallState: APICallState.loaded,
        model: termsAndConditionsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(termsAndConditionsApiState: GeneralApiState<TermsAndConditionModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

  // get faqs
  Future<void> getFaqs() async {
    emit(state.copyWith(faqsApiState: const GeneralApiState<FaqsModel>(
      apiCallState: APICallState.loading,
    )));

    await accountRepository.getFaqs().then((faqsModel) {
      emit(state.copyWith(faqsApiState: GeneralApiState<FaqsModel>(
        apiCallState: APICallState.loaded,
        model: faqsModel,
      )));
    }).catchError((error) {
      emit(state.copyWith(faqsApiState: GeneralApiState<FaqsModel>(
        apiCallState: APICallState.failure,
        errorMessage: error.toString(),
      )));
    });
  }

}