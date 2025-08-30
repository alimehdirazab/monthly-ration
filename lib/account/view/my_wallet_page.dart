part of 'view.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyWalletView();
  }
}

class MyWalletView extends StatefulWidget {
  @override
  _MyWalletViewState createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> {
  double walletBalance = 5000.0;

  List<Map<String, dynamic>> transactions = [
    {'amount': 500, 'type': 'credit', 'description': 'Added to Wallet'},
    {'amount': 200, 'type': 'debit', 'description': 'Purchase'},
    {'amount': 300, 'type': 'credit', 'description': 'Refund'},
  ];

  void _addMoney() {
    setState(() {
      walletBalance += 1000;
      transactions.insert(0, {
        'amount': 1000,
        'type': 'credit',
        'description': 'Added to Wallet',
      });
    });
  }

  void _withdrawMoney() {
    setState(() {
      if (walletBalance >= 500) {
        walletBalance -= 500;
        transactions.insert(0, {
          'amount': 500,
          'type': 'debit',
          'description': 'Withdrawal',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,

        title: Text(
          'My Wallet',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
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
    );
  }
}
