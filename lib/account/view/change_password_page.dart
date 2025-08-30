part of 'view.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangePasswordView();
  }
}

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,

        title: Text(
          'Change Password',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            // Current Password
            CustomTextField(
              hintText: "Current Password",
              controller: currentPasswordController,
              obscureText: !showCurrent,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  showCurrent ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // New Password
            CustomTextField(
              hintText: "New Password",
              controller: currentPasswordController,
              obscureText: !showCurrent,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  showCurrent ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm New Password
            CustomTextField(
              hintText: "Confirm Password",
              controller: currentPasswordController,
              obscureText: !showCurrent,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  showCurrent ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Change Password Button
            CustomElevatedButton(
              backgrondColor: GroceryColorTheme().primary,
              width: double.infinity,
              onPressed: () {
                context.popPage();
              },
              buttonText: Text(
                "Change Password",
                style: GroceryTextTheme().bodyText.copyWith(
                  fontSize: 14,
                  color: GroceryColorTheme().black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
