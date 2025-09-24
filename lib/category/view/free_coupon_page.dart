part of 'view.dart';

class FreeCouponPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const FreeCouponPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: FreeCouponView(),
    );
  }
}

class FreeCouponView extends StatefulWidget {
  const FreeCouponView({super.key});

  @override
  State<FreeCouponView> createState() => _FreeCouponViewState();
}

class _FreeCouponViewState extends State<FreeCouponView> {
  final _couponCodeController = TextEditingController();
  String _inputText = "";
  String? _loadingCouponCode; // Track which coupon is currently being applied

  @override
  void initState() {
    super.initState();
    // Load coupons from API
    context.read<HomeCubit>().getCoupons();
    
    _couponCodeController.addListener(() {
      setState(() {
        _inputText = _couponCodeController.text;
      });
    });
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GroceryColorTheme().primary,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Coupon',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) => 
            previous.applyCouponApiState != current.applyCouponApiState,
        listener: (context, state) {
          if (state.applyCouponApiState.apiCallState == APICallState.loaded) {
            setState(() {
              _loadingCouponCode = null; // Reset loading state
            });
            _showCouponDialog(context);
          } else if (state.applyCouponApiState.apiCallState == APICallState.failure) {
            setState(() {
              _loadingCouponCode = null; // Reset loading state
            });
            context.showSnacbar(state.applyCouponApiState.errorMessage ?? 'Failed to apply coupon');
          }
        },
        buildWhen: (previous, current) => 
            previous.getCouponsApiState != current.getCouponsApiState ||
            previous.applyCouponApiState != current.applyCouponApiState,
        builder: (context, state) {
          if (state.getCouponsApiState.apiCallState == APICallState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.getCouponsApiState.apiCallState == APICallState.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load coupons',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().getCoupons();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final coupons = state.getCouponsApiState.model?.data ?? [];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildApplyCouponCard(state),
                const SizedBox(height: 16),
                if (coupons.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'No coupons available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: coupons
                        .map((coupon) => _buildCouponOfferCard(coupon, state))
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildApplyCouponCard(HomeState state) {
    bool isButtonEnabled = _inputText.isNotEmpty;
    bool isLoading = _loadingCouponCode == _inputText && state.applyCouponApiState.apiCallState == APICallState.loading;
    
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponCodeController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'Type coupon code here',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (isButtonEnabled && !isLoading)
                  ? () {
                      setState(() {
                        _loadingCouponCode = _inputText; // Set loading for this specific coupon
                      });
                      // Apply coupon with dummy order amount - you may want to pass this as parameter
                      context.read<HomeCubit>().applyCoupon(
                        couponCode: _inputText,
                        orderAmount: 500.0, // Replace with actual order amount
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (isButtonEnabled && !isLoading)
                    ? Colors.amber.shade600
                    : Colors.grey.shade300,
                foregroundColor: (isButtonEnabled && !isLoading)
                    ? Colors.black 
                    : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Apply now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponOfferCard(CouponsList coupon, HomeState state) {
    bool isLoading = _loadingCouponCode == coupon.code && state.applyCouponApiState.apiCallState == APICallState.loading;
    
    // Create a display title based on coupon type and value
    String getDisplayTitle() {
      if (coupon.type == 'percentage') {
        return 'Get ${coupon.value}% off';
      } else if (coupon.type == 'fixed') {
        return 'Get ₹${coupon.value} off';
      } else {
        return 'Special Offer';
      }
    }
    
    // Create terms list from coupon data
    List<String> getTerms() {
      List<String> terms = [];
      if (coupon.minPurchase != null && coupon.minPurchase!.isNotEmpty) {
        terms.add('Minimum purchase of ₹${coupon.minPurchase} required.');
      }
      if (coupon.maxUses != null) {
        terms.add('Limited to ${coupon.maxUses} uses only.');
      }
      if (coupon.endDate != null) {
        final dateFormat = DateFormat('dd MMM yyyy');
        terms.add('Valid till ${dateFormat.format(coupon.endDate!)}.');
      }
      if (terms.isEmpty) {
        terms.add('Terms and conditions apply.');
      }
      return terms;
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: GroceryColorTheme().statusBlueColor.withValues(
                      alpha: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: coupon.image?.isNotEmpty == true
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            coupon.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                coupon.code?.substring(0, 3).toUpperCase() ?? 'CPN',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            coupon.code?.substring(0, 3).toUpperCase() ?? 'CPN',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                // Offer Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Text(
                          'Avail Offer Now',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getDisplayTitle(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Use code ${coupon.code ?? ''}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Apply Button
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    if (coupon.code != null) {
                      setState(() {
                        _loadingCouponCode = coupon.code; // Set loading for this specific coupon
                      });
                      context.read<HomeCubit>().applyCoupon(
                        couponCode: coupon.code!,
                        orderAmount: 500.0, // Replace with actual order amount
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading 
                        ? Colors.grey[400] 
                        : GroceryColorTheme().primary,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Apply now'),
                ),
              ],
            ),
            const Divider(height: 24),
            // Terms and Conditions
            _ExpandableTermsSection(terms: getTerms()),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: CircleAvatar(
              radius: 2,
              backgroundColor: Colors.grey.shade500,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Expandable Terms Section Widget
class _ExpandableTermsSection extends StatefulWidget {
  final List<String> terms;
  
  const _ExpandableTermsSection({required this.terms});

  @override
  State<_ExpandableTermsSection> createState() => _ExpandableTermsSectionState();
}

class _ExpandableTermsSectionState extends State<_ExpandableTermsSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isExpanded)
                ...widget.terms
                    .map((term) => _buildTermItem(term))
                    .toList(),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.remove : Icons.add,
                size: 16,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                isExpanded ? 'Read less' : 'Read more.....',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: CircleAvatar(
              radius: 2,
              backgroundColor: Colors.grey.shade500,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

void _showCouponDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ), // Rounded corners for the dialog
        ),
        elevation: 0,
        backgroundColor:
            Colors
                .transparent, // Make background transparent to show custom shape
        child: _buildDialogContent(context),
      );
    },
  );
}

Widget _buildDialogContent(BuildContext context) {
  return
  // Main dialog content area
  Stack(
    children: [
      // 🎯 Dialog content
      Center(
        child: Container(
          margin: const EdgeInsets.only(top: 80),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(GroceryImages.dialog),
              const SizedBox(height: 20),
              Text(
                'Congratulations! You\'ve Applied a coupon voucher.',
                textAlign: TextAlign.center,
                style: GroceryTextTheme().boldText.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 24),
              const Text(
                'code applied',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                'Successfully applied',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black38),
              ),
              const SizedBox(height: 12),
              CustomElevatedButton(
                backgrondColor: GroceryColorTheme().primary,
                width: double.infinity,
                onPressed: () {
                  // Pop dialog first, then pop the coupon page to go back to checkout
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to checkout page
                },
                buttonText: Text(
                  "Got it",
                  style: GroceryTextTheme().boldText.copyWith(
                    fontSize: 14,
                    color: GroceryColorTheme().black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🎉 Lottie animation on top, but doesn't block taps
      IgnorePointer(
        child: Center(
          child: Lottie.asset(
            GroceryImages.partyLottie,
            repeat: false,
            onLoaded: (composition) {
              Future.delayed(composition.duration, () {
                // animation ends — do nothing or hide it if needed
              });
            },
          ),
        ),
      ),
    ],
  );

  // Top banner and percentage icon
  // Positioned(
  //   top: 0,
  //   child: Column(
  //     children: [
  //       // The patterned banner (simplified with a gradient for demonstration)
  //       Container(
  //         width: 200, // Adjust width as needed
  //         height: 100, // Adjust height as needed
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(
  //             20.0,
  //           ), // Rounded corners for the banner
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               const Color(0xFF4CAF50), // Green
  //               const Color(0xFFFFEB3B), // Yellow
  //               const Color(0xFFFF9800), // Orange
  //             ],
  //             stops: const [0.0, 0.5, 1.0],
  //             transform: const GradientRotation(
  //               0.785,
  //             ), // Rotate for diagonal stripes effect
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 10,
  //               offset: const Offset(0, 5),
  //             ),
  //           ],
  //         ),
  //         // This is a simplified representation. For exact pattern,
  //         // you might need custom painter or more complex widgets.
  //       ),
  //       // Percentage icon
  //       Transform.translate(
  //         offset: const Offset(
  //           0,
  //           -50,
  //         ), // Move icon up to overlap banner and dialog
  //         child: Container(
  //           width: 80,
  //           height: 80,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFFFD700), // Yellow
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 5),
  //               ),
  //             ],
  //           ),
  //           child: const Center(
  //             child: Text(
  //               '%',
  //               style: TextStyle(
  //                 fontSize: 40,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
}
