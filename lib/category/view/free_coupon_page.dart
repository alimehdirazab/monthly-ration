part of 'view.dart';

// Data model for a coupon offer
class Coupon {
  final String logoText;
  final String title;
  final String code;
  final List<String> terms;
  bool isExpanded;

  Coupon({
    required this.logoText,
    required this.title,
    required this.code,
    required this.terms,
    this.isExpanded = false,
  });
}

class FreeCouponPage extends StatelessWidget {
  const FreeCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FreeCouponView();
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

  // Dummy data for the coupon list
  final List<Coupon> _coupons = [
    Coupon(
      logoText: 'DIGIsmart',
      title: 'Get 10% off',
      code: 'DIGISMART',
      terms: [
        'Applicable only on transactions using Standard Chartered Digismart card.',
        'Maximum discount of ₹150.',
        'Offer valid once per user during the offer period.',
      ],
    ),
    Coupon(
      logoText: 'FREEDEL',
      title: 'Free Delivery',
      code: 'FREEDEL',
      terms: [
        'Applicable on all orders above ₹500.',
        'This is a limited period offer.',
      ],
    ),
    Coupon(
      logoText: 'SAVEBIG',
      title: 'Get 20% off',
      code: 'SAVEBIG',
      terms: [
        'Applicable only on transactions using HDFC Bank credit cards.',
        'Not valid on grocery items.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
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
        // leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildApplyCouponCard(),
            const SizedBox(height: 16),
            // Using Column instead of ListView.builder since the list is small
            // and we are in a SingleChildScrollView.
            Column(
              children:
                  _coupons
                      .map((coupon) => _buildCouponOfferCard(coupon))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildApplyCouponCard() {
    bool isButtonEnabled = _inputText.isNotEmpty;
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponCodeController,

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
              onPressed:
                  isButtonEnabled
                      ? () {
                        /* Apply coupon logic */
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isButtonEnabled
                        ? Colors.amber.shade600
                        : Colors.grey.shade300,
                foregroundColor:
                    isButtonEnabled ? Colors.black : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Apply now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponOfferCard(Coupon coupon) {
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
                  child: Center(
                    child: Text(
                      coupon.logoText,
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
                        coupon.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Use code ${coupon.code}',
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
                  onPressed: () {
                    _showCouponDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GroceryColorTheme().primary,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Apply now'),
                ),
              ],
            ),
            const Divider(height: 24),
            // Terms and Conditions
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coupon.isExpanded)
                    ...coupon.terms
                        .map((term) => _buildTermItem(term))
                        .toList(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  coupon.isExpanded = !coupon.isExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(
                    coupon.isExpanded ? Icons.remove : Icons.add,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    coupon.isExpanded ? 'Read less' : 'Read more.....',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
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
                'Congratulations! You\'ve won a coupon voucher. Redeem it using the code sent to your WhatsApp.',
                textAlign: TextAlign.center,
                style: GroceryTextTheme().boldText.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 24),
              const Text(
                'Monthlyratio code applied',
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
                  context.popPage(); // Should work now
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
