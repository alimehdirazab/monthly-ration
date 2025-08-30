part of "view.dart";

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationView();
  }
}

class NotificationView extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.local_offer,
      "title": "New Offer!",
      "subtitle": "Get 20% off on your next order.",
      "time": "2 hrs ago",
    },
    {
      "icon": Icons.local_shipping,
      "title": "Order Shipped",
      "subtitle": "Your order #1234 is on its way.",
      "time": "1 day ago",
    },
    {
      "icon": Icons.payment,
      "title": "Payment Received",
      "subtitle": "We received your payment of Rs. 2500.",
      "time": "2 days ago",
    },
    {
      "icon": Icons.card_giftcard,
      "title": "Voucher Applied",
      "subtitle": "Rs. 100 voucher applied to your wallet.",
      "time": "3 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: GroceryColorTheme().primary,
        elevation: 0,
      ),
      body:
          notifications.isEmpty
              ? Center(
                child: Text(
                  "No notifications yet.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
              : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: GroceryColorTheme().primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Icon(
                        item['icon'],
                        color: GroceryColorTheme().primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(item['subtitle']),
                    trailing: Text(
                      item['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      // You can navigate to detailed screen here
                    },
                  );
                },
              ),
    );
  }
}
