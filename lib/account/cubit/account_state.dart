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
    // wallet History Api State
    this.walletHistoryApiState = const GeneralApiState<WalletModel>(),
  });
  // about us Api State
  final GeneralApiState<AboutUsModel> aboutUsApiState;
  // privacy policy Api State
  final GeneralApiState<PrivacyPolicyModel> privacyPolicyApiState;
  // terms and conditions Api State
  final GeneralApiState<TermsAndConditionModel> termsAndConditionsApiState;
  // faqs Api State
  final GeneralApiState<FaqsModel> faqsApiState;
  // Wallet History Api State
  final GeneralApiState<WalletModel>  walletHistoryApiState;


  AccountState copyWith({
    // about us Api State
    GeneralApiState<AboutUsModel>? aboutUsApiState,
    // privacy policy Api State
    GeneralApiState<PrivacyPolicyModel>? privacyPolicyApiState,
    // terms and conditions Api State
    GeneralApiState<TermsAndConditionModel>? termsAndConditionsApiState,
    // faqs Api State
    GeneralApiState<FaqsModel>? faqsApiState,
    // Wallet History Api State
    GeneralApiState<WalletModel>?  walletHistoryApiState,
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
       // Wallet History Api State
       walletHistoryApiState: walletHistoryApiState ?? this.walletHistoryApiState
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
         // Wallet History Api State
        walletHistoryApiState
      ];
}