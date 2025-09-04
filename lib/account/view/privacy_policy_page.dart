part of 'view.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final AccountCubit accountCubit;
  const PrivacyPolicyPage({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: accountCubit,
      child: const _PrivacyPolicyView(),
    );
  }
}

class _PrivacyPolicyView extends StatefulWidget {
  const _PrivacyPolicyView();

  @override
  State<_PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<_PrivacyPolicyView> {


  @override
  initState() {
    super.initState();
    context.read<AccountCubit>().getPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,

        title: Text(
          'Privacy Policy',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          final privacyPolicyModel = state.privacyPolicyApiState.model;
          if (privacyPolicyModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final privacyPolicy = privacyPolicyModel.data;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top image (no padding)
                if (privacyPolicy.image.isNotEmpty)
                  Image.network(
                    privacyPolicy.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                // Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                      privacyPolicy.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                // HTML content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Html(
                    data: privacyPolicy.content,
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
