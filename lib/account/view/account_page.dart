part of 'view.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountView();
  }
}

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.select((AppCubit cubit) => cubit.state);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  // Profile Picture
                   CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                     appState.user.customer?.profileImage??''
                    ),
                  ),
                  const SizedBox(width: 15),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appState.user.customer?.name??'',
                              style: GroceryTextTheme().boldText.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushPage(EditProfilePage());
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4CAF50), // Green color
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Color(0xFF4CAF50),
                                  ), // Green edit icon
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          appState.user.customer?.email??'',
                          style: GroceryTextTheme().bodyText,
                        ),
                        Text(appState.user.customer?.phone??'', style: GroceryTextTheme().bodyText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quick Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(context, Icons.menu, 'All Orders', () {
                    context.pushPage(OrderHistoryPage());
                  }),
                  _buildActionButton(
                    context,
                    Icons.location_on_outlined,
                    'Address',
                    () {
                      context.pushPage(AddressPage());
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.add_shopping_cart_outlined,
                    'Cart',
                    () {
                      context.pushPage(CheckoutPage());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Personal Data Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      context.pushPage(MyWalletPage());
                    },
                    child: _buildPersonalDataItem(
                      context,
                      Icons.account_balance_wallet_outlined,
                      'My wallet',
                      'You have successfully purchased a tour ticket...',
                      '2 hours ago',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.pushPage(NotificationPage());
                    },
                    child: _buildPersonalDataItem(
                      context,
                      Icons.notifications_none_rounded,
                      'Notification',
                      'Additional discount for all BCA debit user, lets...',
                      '10 minutes ago',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.pushPage(TransactionHistryPage());
                    },
                    child: _buildPersonalDataItem(
                      context,
                      Icons.history,
                      'Transaction History',
                      'Get a big discount in this month!',
                      '8 hours ago',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Bottom padding

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      context.pushPage(ChangePasswordPage());
                    },
                    child: _buildPersonalDataItem(
                      context,
                      Icons.settings_outlined,
                      'Change Password',
                      'Change your password',
                      '',
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pushPage(PrivacyPolicyPage()),
                    child: _buildPersonalDataItem(
                      context,
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                      'Check out our privacy policy',
                      '',
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pushPage(FaqPage()),
                    child: _buildPersonalDataItem(
                      context,
                      Icons.info_outline,
                      'FAQs',
                      'Read Faqs',
                      '',
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pushPage(AboutUsView()),
                    child: _buildPersonalDataItem(
                      context,
                      Icons.help_outline,
                      'About Us',
                      'Read App\'s Mission',
                      '',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  // Helper method for quick action buttons
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Function()? onTap,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        color: GroceryColorTheme().white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
            child: Column(
              children: [
                Icon(icon, size: 25, color: Colors.black),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GroceryTextTheme().bodyText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for personal data items
  Widget _buildPersonalDataItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: GroceryColorTheme().white,
      elevation: 0,
      // margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(
                  0.1,
                ), // Light blue background for icon
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
