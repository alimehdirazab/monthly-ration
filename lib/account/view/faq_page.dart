part of 'view.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FaqView();
  }
}

class FaqView extends StatelessWidget {
  const FaqView({Key? key}) : super(key: key);

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to the login screen, tap on 'Forgot Password', and follow the instructions sent to your email.",
    },
    {
      "question": "How can I contact support?",
      "answer":
          "You can contact support through the Help & Support section in the app or email us at support@example.com.",
    },
    {
      "question": "How do I update my profile information?",
      "answer":
          "Navigate to the Profile tab and tap 'Edit' to update your information such as name, email, and address.",
    },
    {
      "question": "Is my data secure?",
      "answer":
          "Yes, we use industry-standard encryption to protect your data at all times.",
    },
    {
      "question": "How do I delete my account?",
      "answer":
          "Please contact support to request account deletion. We'll process it within 7 business days.",
    },
  ];

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
      body: ListView.builder(
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
                faq['question']!,
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
                    faq['answer']!,
                    style: const TextStyle(fontSize: 14),
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
