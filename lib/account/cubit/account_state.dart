part of 'account_cubit.dart';

class AccountState extends Equatable {
  const AccountState({
    // about us Api State
    this.aboutUsApiState = const GeneralApiState<AboutUsModel>(),
    // privacy policy Api State
    this.privacyPolicyApiState = const GeneralApiState<PrivacyPolicyModel>(),
    // terms and conditions Api State
    this.termsAndConditionsApiState = const GeneralApiState<TermsAndConditionModel>(),
    // faqs Api State
    this.faqsApiState = const GeneralApiState<FaqsModel>(),
  });
  // about us Api State
  final GeneralApiState<AboutUsModel> aboutUsApiState;
  // privacy policy Api State
  final GeneralApiState<PrivacyPolicyModel> privacyPolicyApiState;
  // terms and conditions Api State
  final GeneralApiState<TermsAndConditionModel> termsAndConditionsApiState;
  // faqs Api State
  final GeneralApiState<FaqsModel> faqsApiState;


  AccountState copyWith({
    // about us Api State
    GeneralApiState<AboutUsModel>? aboutUsApiState,
    // privacy policy Api State
    GeneralApiState<PrivacyPolicyModel>? privacyPolicyApiState,
    // terms and conditions Api State
    GeneralApiState<TermsAndConditionModel>? termsAndConditionsApiState,
    // faqs Api State
    GeneralApiState<FaqsModel>? faqsApiState,
  }) {
    return AccountState(
      // about us Api State
      aboutUsApiState: aboutUsApiState ?? this.aboutUsApiState,
      // privacy policy Api State
      privacyPolicyApiState: privacyPolicyApiState ?? this.privacyPolicyApiState,
      // terms and conditions Api State
      termsAndConditionsApiState: termsAndConditionsApiState ?? this.termsAndConditionsApiState,
      // faqs Api State
      faqsApiState: faqsApiState ?? this.faqsApiState,
    );
  }

  @override
  List<Object?> get props => [
        // about us Api State
        aboutUsApiState,
        // privacy policy Api State
        privacyPolicyApiState,
        // terms and conditions Api State
        termsAndConditionsApiState,
        // faqs Api State
        faqsApiState,
      ];
}