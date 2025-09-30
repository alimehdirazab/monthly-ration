part of 'view.dart';

class MyWalletPage extends StatelessWidget {
  final AccountCubit accountCubit;
  const MyWalletPage({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: accountCubit,
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
  final TextEditingController _amountController = TextEditingController();
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    // Get wallet history on page load
    context.read<AccountCubit>().getWalletHistory();
    
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, authState) {
              // Handle wallet recharge success
              if (authState.walletRechargeApiState.apiCallState == APICallState.loaded) {
                final response = authState.walletRechargeApiState.model;
                if (response != null && response['order_id'] != null) {
                  _openCheckout(response);
                }
              }
              
              // Handle wallet recharge error
              if (authState.walletRechargeApiState.apiCallState == APICallState.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authState.walletRechargeApiState.errorMessage ?? 'Failed to create order'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              
              // Handle wallet verify success
              if (authState.walletVerifyApiState.apiCallState == APICallState.loaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment verified successfully! Wallet recharged.'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Refresh wallet history after successful payment
                context.read<AccountCubit>().getWalletHistory();
                _amountController.clear();
              }
              
              // Handle wallet verify error
              if (authState.walletVerifyApiState.apiCallState == APICallState.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authState.walletVerifyApiState.errorMessage ?? 'Payment verification failed'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AccountCubit, AccountState>(
          buildWhen: (previous, current) =>
              previous.walletHistoryApiState != current.walletHistoryApiState,
          builder: (context, state) {
            final walletHistory = state.walletHistoryApiState.model?.data ?? [];
            final currentBalance = walletHistory.isNotEmpty 
                ? double.tryParse(walletHistory.first.balanceAfter ?? '0') ?? 0.0
                : 0.0;
                
            // Check loading state from AuthCubit for wallet operations
            final authState = context.watch<AuthCubit>().state;
            final isLoading = authState.walletRechargeApiState.apiCallState == APICallState.loading ||
                             authState.walletVerifyApiState.apiCallState == APICallState.loading;
          
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
                              "Rs. ${currentBalance.toStringAsFixed(0)}",
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
                    child: _buildTransactionList(state, walletHistory),
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
        }),
      ),
    );
  }

  Widget _buildTransactionList(AccountState state, List<WalletHistory> walletHistory) {
    if (state.walletHistoryApiState.apiCallState == APICallState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.walletHistoryApiState.apiCallState == APICallState.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load transaction history',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<AccountCubit>().getWalletHistory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (walletHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: walletHistory.length,
      itemBuilder: (context, index) {
        final transaction = walletHistory[index];
        final isCredit = transaction.transactionType?.toLowerCase() == 'credit';
        final amount = double.tryParse(transaction.amount ?? '0') ?? 0.0;
        
        return ListTile(
          leading: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : Colors.red,
            size: 24,
          ),
          title: Text(
            "${isCredit ? '+' : '-'} Rs. ${amount.toStringAsFixed(0)}",
            style: TextStyle(
              color: isCredit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.remarks ?? transaction.source ?? 'Transaction'),
              const SizedBox(height: 2),
              Text(
                transaction.createdAt != null
                    ? '${transaction.createdAt!.day}/${transaction.createdAt!.month}/${transaction.createdAt!.year} ${transaction.createdAt!.hour}:${transaction.createdAt!.minute.toString().padLeft(2, '0')}'
                    : 'Unknown date',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing: Text(
            'Bal: Rs. ${double.tryParse(transaction.balanceAfter ?? '0')?.toStringAsFixed(0) ?? '0'}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
