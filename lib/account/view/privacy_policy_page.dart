part of 'view.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyView();
  }
}

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Last updated: July 22, 2025",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Introduction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We value your privacy and are committed to protecting your personal data. "
              "This Privacy Policy explains how we collect, use, and share your information.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Text(
              "What Data We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- Personal identification information (Name, email address, etc.)\n"
              "- Device information\n"
              "- Usage data (how you interact with the app)",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Text(
              "How We Use Your Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- To provide and maintain our services\n"
              "- To notify you about changes\n"
              "- To improve user experience",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Text(
              "Your Rights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You have the right to access, modify, or delete your personal data. "
              "You may also opt-out of certain data collection features at any time.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Text(
              "Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "If you have any questions or concerns about our Privacy Policy, "
              "please contact us at support@example.com.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 24),
            Text(
              "© 2025 Your App Name. All rights reserved.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
