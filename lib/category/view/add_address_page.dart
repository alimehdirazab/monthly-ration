part of 'view.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddAddressView();
  }
}

// Data models for clarity
enum PaymentMethod { cashOnDelivery, payLabs, midtrans }

class DeliveryDate {
  final DateTime date;
  bool isSelected;

  DeliveryDate({required this.date, this.isSelected = false});
}

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cashOnDelivery;
  int _selectedDateIndex = 0;
  final List<DeliveryDate> _deliveryDates = List.generate(
    10,
    (index) => DeliveryDate(date: DateTime.now().add(Duration(days: index))),
  );

  @override
  void initState() {
    super.initState();
    // Pre-select the first date
    if (_deliveryDates.isNotEmpty) {
      _deliveryDates[_selectedDateIndex].isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressDetails(),
            const SizedBox(height: 16),
            _buildGstInvoice(),
            const SizedBox(height: 24),
            _buildDeliveryDateSection(),
            const SizedBox(height: 24),
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),
            _buildPromoSection(),
            const SizedBox(height: 16),
            _buildSeeAllCoupons(),
            const SizedBox(height: 30), // Extra space to scroll past bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: GroceryColorTheme().primary,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: const Text(
        'Checkout',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: () {
            context.popPage();
          },
        ),
      ],
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAddressDetails() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basavaraj',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lorem ipsum Basavaraj lorem ipsum Basavaraj ruth lorem ipsum Basavaraj ruth lorem ipsum.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGstInvoice() {
    return _buildSectionContainer(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.percent, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Issue GST Invoice\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Click on the check box to get GST invoice on this order. ',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  TextSpan(
                    text: 'Edit',
                    style: TextStyle(
                      color: GroceryColorTheme().primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Checkbox(
            value: false,
            onChanged: (bool? value) {},
            activeColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Delivery Date & Time',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _deliveryDates.length,
            itemBuilder: (context, index) {
              final dateItem = _deliveryDates[index];
              final isSelected = _selectedDateIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(dateItem.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? Colors.green.shade800
                                  : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(dateItem.date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected ? Colors.green.shade800 : Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(dateItem.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? Colors.green.shade800
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            'Afternoon 3 PM to 6 PM',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _buildSectionContainer(
          child: Column(
            children: [
              _paymentOptionTile(
                title: 'Cash On Delivery',
                icon: Icons.card_membership_outlined,
                value: PaymentMethod.cashOnDelivery,
              ),
              _paymentOptionTile(
                title: 'payLabs',
                icon: Icons.credit_card,
                value: PaymentMethod.payLabs,
              ),
              _paymentOptionTile(
                title: 'Midtrans',
                icon: Icons.account_balance_wallet_outlined,
                value: PaymentMethod.midtrans,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentOptionTile({
    required String title,
    required IconData icon,
    required PaymentMethod value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: GroceryColorTheme().lightGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: RadioListTile<PaymentMethod>(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon, color: Colors.black, size: 24),
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue;
          });
        },
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timelapse,
              color: Colors.lightBlueAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You got free delivery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'No coupons needed',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllCoupons() {
    return Center(
      child: TextButton(
        onPressed: () {
          context.pushPage(FreeCouponPage());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'See all coupons',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 10,
      ).copyWith(bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Total', style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(height: 4),
              Text(
                '₹465.07',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              context.pushAndRemoveUntilPage(RootPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GroceryColorTheme().primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
            ),
            child: const Text(
              'Place order',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
