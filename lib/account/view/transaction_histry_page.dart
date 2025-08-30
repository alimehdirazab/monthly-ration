part of 'view.dart';

class TransactionHistryPage extends StatelessWidget {
  const TransactionHistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionHistoryView();
  }
}

class TransactionHistoryView extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "amount": 1000,
      "type": "credit",
      "description": "Wallet Top-up",
      "time": "2 hrs ago",
    },
    {
      "amount": 250,
      "type": "debit",
      "description": "Order Payment",
      "time": "Yesterday",
    },
    {
      "amount": 500,
      "type": "credit",
      "description": "Refund Received",
      "time": "2 days ago",
    },
    {
      "amount": 300,
      "type": "debit",
      "description": "Subscription Fee",
      "time": "3 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: GroceryColorTheme().primary,
        elevation: 0,
      ),
      body:
          transactions.isEmpty
              ? Center(
                child: Text(
                  "No transactions yet.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
              : ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final isCredit = tx['type'] == 'credit';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isCredit ? Colors.green[100] : Colors.red[100],
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "${isCredit ? '+' : '-'} Rs. ${tx['amount']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    subtitle: Text(tx['description']),
                    trailing: Text(
                      tx['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  );
                },
              ),
    );
  }
}
