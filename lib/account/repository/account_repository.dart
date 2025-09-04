part of 'repository.dart';

class AccountRepository {
AccountRepository(this.generalRepository);
  final GeneralRepository generalRepository;

  // get about us
  Future<AboutUsModel> getAboutUs() async {
    final response = await generalRepository.get(
      handle: GroceryApis.aboutUs,
    );
    return AboutUsModel.fromJson(response);
  }

  // get privacy policy
  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    final response = await generalRepository.get(
      handle: GroceryApis.privacyPolicy,
    );
    return PrivacyPolicyModel.fromJson(response);
  }


  // get terms and conditions
  Future<TermsAndConditionModel> getTermsAndConditions() async {
    final response = await generalRepository.get(
      handle: GroceryApis.termsAndConditions,
    );
    return TermsAndConditionModel.fromJson(response);
  }

  // get faqs
  Future<FaqsModel> getFaqs() async {
    final response = await generalRepository.get(
      handle: GroceryApis.faqs,
    );
    return FaqsModel.fromJson(response);
  }

}