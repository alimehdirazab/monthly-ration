part of 'view.dart';

class FaqPage extends StatelessWidget {
  final AccountCubit accountCubit;
  const FaqPage({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: accountCubit,
      child: const _FaqView(),
    );
  }
}

class _FaqView extends StatefulWidget {
  const _FaqView();

  @override
  State<_FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<_FaqView> {
  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,
        title: Text(
          'FAQs',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          final faqsModel = state.faqsApiState.model;
          
          if (faqsModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final faqs = faqsModel.data;
          
          if (faqs.isEmpty) {
            return const Center(
              child: Text(
                'No FAQs available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    faq.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        faq.answer,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
