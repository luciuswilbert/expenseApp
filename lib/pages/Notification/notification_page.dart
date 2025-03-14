import 'package:flutter/material.dart';
import 'package:expense_app_project/widgets/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, String>> _notifications = [
    {
      "title": "Payment Received",
      "message": "You received \$100 from John",
      "time": "10 min ago",
    },
    {
      "title": "Reminder",
      "message": "Your bill is due tomorrow",
      "time": "1 hr ago",
    },
    {
      "title": "Discount Offer",
      "message": "Get 20% off on premium!",
      "time": "3 hrs ago",
    },
    {
      "title": "New Update",
      "message": "Version 2.0 is now available!",
      "time": "1 day ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520),
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            title: _notifications[index]["title"]!,
            message: _notifications[index]["message"]!,
            time: _notifications[index]["time"]!,
          );
        },
      ),
    );
  }
}
