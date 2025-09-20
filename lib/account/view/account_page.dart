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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Header Section with Profile
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    GroceryColorTheme().primary,
                    GroceryColorTheme().primary.withOpacity(0.8),
                    GroceryColorTheme().primary.withOpacity(0.4),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Profile Avatar (Clickable for edit)
                      GestureDetector(
                        onTap: () {
                          context.pushPage(EditProfilePage());
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 37,
                                backgroundImage: (appState.user.customer?.profileImage ?? '').startsWith('http')
                                  ? NetworkImage(appState.user.customer?.profileImage ?? '')
                                  : (appState.user.customer?.profileImage != null && appState.user.customer!.profileImage!.isNotEmpty)
                                    ? FileImage(File(appState.user.customer!.profileImage!))
                                    : null,
                                child: (appState.user.customer?.profileImage == null || appState.user.customer!.profileImage!.isEmpty)
                                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                                  : null,
                              ),
                            ),
                            // Edit icon overlay
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: GroceryColorTheme().primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // "Your account" title
                      Text(
                        'Your account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      
                      // Phone number (also clickable for edit)
                      GestureDetector(
                        onTap: () {
                          context.pushPage(EditProfilePage());
                        },
                        child: Text(
                          appState.user.customer?.phone ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Top 3 Action Cards (Smaller)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTopActionCard(
                            context,
                            Icons.shopping_bag_outlined,
                            'Your orders',
                            () => context.pushPage(OrderHistoryPage()),
                          ),
                          _buildTopActionCard(
                            context,
                            Icons.location_on_outlined,
                            'Addresses',
                            () => context.pushPage(AddressPage()),
                          ),
                          _buildTopActionCard(
                            context,
                            Icons.help_outline,
                            'Need help?',
                            () => context.pushPage(FaqPage(accountCubit: context.read<AccountCubit>())),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),

            // Appearance (Light/Dark Theme) Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.brightness_6_outlined, color: Colors.orange, size: 20),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Appearance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LIGHT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Your Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // // Address book
                  // InkWell(
                  //   onTap: () => context.pushPage(AddressPage()),
                  //   child: _buildInfoItem(
                  //     context,
                  //     Icons.book_outlined,
                  //     'Address book',
                  //   ),
                  // ),
                  
                
                  
                  // My wallet
                  InkWell(
                    onTap: () => context.pushPage(MyWalletPage(accountCubit: context.read<AccountCubit>())),
                    child: _buildInfoItem(
                      context,
                      Icons.account_balance_wallet_outlined,
                      'My wallet',
                    ),
                  ),
                  
                  // Notification
                  InkWell(
                    onTap: () => context.pushPage(NotificationPage()),
                    child: _buildInfoItem(
                      context,
                      Icons.notifications_none_rounded,
                      'Notification',
                    ),
                  ),
                  
                  // Transaction History
                  InkWell(
                    onTap: () => context.pushPage(TransactionHistryPage()),
                    child: _buildInfoItem(
                      context,
                      Icons.history,
                      'Transaction History',
                    ),
                  ),

                    // GST Details (New)
                  InkWell(
                    onTap: () {
                      // Handle GST details navigation
                      // You can create a GST details page
                    },
                    child: _buildInfoItem(
                      context,
                      Icons.receipt_outlined,
                      'GST details',
                    ),
                  ),
                  
                  // Share the App (New)
                  InkWell(
                    onTap: () {
                      // Handle share app functionality
                      // You can implement share functionality here
                    },
                    child: _buildInfoItem(
                      context,
                      Icons.share_outlined,
                      'Share the App',
                    ),
                  ),
                  
                  // Privacy Policy
                  InkWell(
                    onTap: () => context.pushPage(PrivacyPolicyPage(accountCubit: context.read<AccountCubit>())),
                    child: _buildInfoItem(
                      context,
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                    ),
                  ),
                  
                  // Terms and Conditions
                  InkWell(
                    onTap: () => context.pushPage(TermsAndConditionPage(accountCubit: context.read<AccountCubit>())),
                    child: _buildInfoItem(
                      context,
                      Icons.gavel_outlined,
                      'Terms and Conditions',
                    ),
                  ),
                  
                  // About Us
                  InkWell(
                    onTap: () => context.pushPage(AboutusPage(accountCubit: context.read<AccountCubit>())),
                    child: _buildInfoItem(
                      context,
                      Icons.help_outline,
                      'About Us',
                    ),
                  ),
                  
                  // Logout
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<AuthCubit>().logout().then((_){
                                    context.pushAndRemoveUntilPage(AuthLoginPage());
                                  });
                                  context.popPage();
                                },
                                child: Text('Yes',
                                  style: GroceryTextTheme().bodyText.copyWith(
                                    fontSize: 16,
                                    color: GroceryColorTheme().black
                                  )
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.popPage();
                                },
                                child: Text('No',
                                  style: GroceryTextTheme().bodyText.copyWith(
                                    fontSize: 16,
                                    color: GroceryColorTheme().black
                                  )
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: _buildInfoItem(
                      context,
                      Icons.logout,
                      'Logout',
                      showArrow: false,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Top action cards (Your orders, Addresses, Need help?) - Smaller size
  Widget _buildTopActionCard(
    BuildContext context,
    IconData icon,
    String label,
    Function()? onTap,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          elevation: 1,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Information items (smaller design like in the reference)
  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black87, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }

  // Helper method for quick action buttons (kept for compatibility)
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

  // Helper method for personal data items (original method kept unchanged)
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
