part of 'view.dart';

class MyWalletPage extends StatelessWidget {
  final AccountCubit accountCubit;
  const MyWalletPage({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthCubit>(),
      child: const MyWalletView(),
    );
  }
}

class MyWalletView extends StatefulWidget {
  const MyWalletView({super.key});

  @override
  _MyWalletViewState createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> {
  double walletBalance = 5000.0;
  final TextEditingController _amountController = TextEditingController();
  Razorpay? _razorpay;

  List<Map<String, dynamic>> transactions = [
    {'amount': 500, 'type': 'credit', 'description': 'Added to Wallet'},
    {'amount': 200, 'type': 'debit', 'description': 'Purchase'},
    {'amount': 300, 'type': 'credit', 'description': 'Refund'},
  ];

  @override
  void initState() {
    super.initState();
    try {
      _razorpay = Razorpay();
      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      debugPrint('Error initializing Razorpay: $e');
      // Continue without Razorpay if initialization fails
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _razorpay?.clear();
    } catch (e) {
      debugPrint('Error disposing Razorpay: $e');
    }
    _amountController.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Verify payment with backend
    context.read<AuthCubit>().walletVerify(
      razorpayPaymentId: response.paymentId!,
      razorpayOrderId: response.orderId!,
      razorpaySignature: response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openCheckout(Map<String, dynamic> orderData) {
    final orderId = orderData['order_id'];
    final razorpayKey = orderData['razorpayKey'];
    final amount = orderData['amount'];
    final customerName = orderData['name'] ?? context.read<AppCubit>().state.user.customer?.name ?? 'Customer';
    final customerEmail = orderData['email'] ?? context.read<AppCubit>().state.user.customer?.email ?? '';
    final customerContact = orderData['contact'] ?? context.read<AppCubit>().state.user.customer?.phone ?? '';

    var options = {
      'key': razorpayKey,
      'amount': (double.parse(amount) * 100).toInt(), // amount in the smallest currency unit
      'name': 'Monthly Ration',
      'order_id': orderId,
      'description': 'Wallet Recharge',
      // 'timeout': 300, // in seconds
      'prefill': {
        'contact': customerContact,
        'email': customerEmail,
        'name': customerName,
      }
    };

    try {
      if (_razorpay != null) {
        _razorpay!.open(options);
      } else {
        throw Exception('Razorpay not initialized');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening Razorpay: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddCashDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Cash to Wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Minimum amount: ₹10\nMaximum amount: ₹50,000',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = _amountController.text.trim();
                if (amount.isNotEmpty && double.tryParse(amount) != null) {
                  final amountValue = double.parse(amount);
                  if (amountValue >= 10 && amountValue <= 50000) {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().walletRecharge(amount);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Amount should be between ₹10 and ₹50,000'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GroceryColorTheme().primary,
              ),
              child: const Text('Add Cash', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        elevation: 0,
        title: Text(
          'My Wallet',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCashDialog,
        backgroundColor: GroceryColorTheme().primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Add Cash'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle wallet recharge success
          if (state.walletRechargeApiState.apiCallState == APICallState.loaded) {
            final response = state.walletRechargeApiState.model;
            if (response != null && response['order_id'] != null) {
              _openCheckout(response);
            }
          }
          
          // Handle wallet recharge error
          if (state.walletRechargeApiState.apiCallState == APICallState.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.walletRechargeApiState.errorMessage ?? 'Failed to create order'),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          // Handle wallet verify success
          if (state.walletVerifyApiState.apiCallState == APICallState.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment verified successfully! Wallet recharged.'),
                backgroundColor: Colors.green,
              ),
            );
            // Update local balance and transactions
            setState(() {
              final amount = double.tryParse(_amountController.text) ?? 0;
              walletBalance += amount;
              transactions.insert(0, {
                'amount': amount.toInt(),
                'type': 'credit',
                'description': 'Wallet Recharge via Razorpay',
              });
            });
            _amountController.clear();
          }
          
          // Handle wallet verify error
          if (state.walletVerifyApiState.apiCallState == APICallState.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.walletVerifyApiState.errorMessage ?? 'Payment verification failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.walletRechargeApiState.apiCallState == APICallState.loading ||
                           state.walletVerifyApiState.apiCallState == APICallState.loading;
          
          return Stack(
            children: [
              Column(
                children: [
                  // Wallet Balance Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Wallet Balance",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                Icon(
                                  GroceryIcons().accountBalance,
                                  color: GroceryColorTheme().primary,
                                  size: 30,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rs. ${walletBalance.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Transaction History Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Transaction History",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Transaction List
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final isCredit = tx['type'] == 'credit';
                        return ListTile(
                          leading: Icon(
                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isCredit ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          title: Text(
                            "${isCredit ? '+' : '-'} Rs. ${tx['amount']}",
                            style: TextStyle(
                              color: isCredit ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(tx['description']),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              // Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
