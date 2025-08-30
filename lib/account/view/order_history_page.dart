part of "view.dart";

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderHistoryView();
  }
}

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  // For simplicity, we'll use a boolean to switch between active/previous orders
  bool _showActiveOrders =
      true; // Set to false to show "Previous order" initially

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroceryColorTheme().offWhiteColor,
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Order history',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab/Button Section for Active/Previous Orders
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: GroceryColorTheme().white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showActiveOrders = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            _showActiveOrders
                                ? GroceryColorTheme().primary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              _showActiveOrders
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Active orders',
                          style: TextStyle(
                            color:
                                _showActiveOrders
                                    ? Colors.black
                                    : Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showActiveOrders = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            !_showActiveOrders
                                ? GroceryColorTheme().primary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              !_showActiveOrders
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Previous order',
                          style: TextStyle(
                            color:
                                !_showActiveOrders
                                    ? Colors.black
                                    : Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of Orders
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 5, // Example: 5 orders
              itemBuilder: (context, index) {
                // You can customize order data based on _showActiveOrders
                return _buildOrderItem(
                  context,
                  orderNumber: '#7226',
                  date: '6 Jun 2025, 05:43 PM',
                  items: ['Black currant berries'],
                  totalPay: '₹465.07',
                  status: 'Cancelled', // Example status
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build an individual order item card
  Widget _buildOrderItem(
    BuildContext context, {
    required String orderNumber,
    required String date,
    required List<String> items,
    required String totalPay,
    String? status,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: GroceryColorTheme().white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order $orderNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: GroceryColorTheme().white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red, width: 0.8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            // Display items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            '• $item',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total pay',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalPay,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4CAF50), // Green color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
