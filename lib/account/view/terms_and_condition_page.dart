part of 'view.dart';

class TermsAndConditionPage extends StatelessWidget {
  final AccountCubit accountCubit;
  const TermsAndConditionPage({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: accountCubit,
      child: const _TermsAndConditionView(),
    );
  }
}

class _TermsAndConditionView extends StatefulWidget {
  const _TermsAndConditionView();

  @override
  State<_TermsAndConditionView> createState() => _TermsAndConditionViewState();
}

class _TermsAndConditionViewState extends State<_TermsAndConditionView> {
  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().getTermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        elevation: 0,
        title: Text(
          'Terms and Conditions',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          final termsAndConditionsModel = state.termsAndConditionsApiState.model;
          if (termsAndConditionsModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final termsAndConditions = termsAndConditionsModel.data;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top image (no padding)
                if (termsAndConditions.image.isNotEmpty)
                  Image.network(
                    termsAndConditions.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                // Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    termsAndConditions.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                // HTML content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Html(
                    data: termsAndConditions.content,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
