import 'package:flutter/material.dart';
import 'package:expense_app_project/widgets/curved_bottom_container.dart';
import 'package:expense_app_project/widgets/custom_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// ✅ Reusable Curved Yellow Background
          const CurvedBottomContainer(height: 240),

          /// ✅ Reusable Notification Icon
          const NotificationButton(),

          /// ✅ Greeting Text (Aligned with Notification Icon)
          Positioned(
            top: 50,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good afternoon,',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                Text(
                  'Lucius Wilbert Tjoa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          /// ✅ Total Balance Section (Balance + Eye Icon)
          Positioned(
            top: 140, // Adjusted position to move it lower
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 3),

                /// ✅ Balance + Eye Icon (Manually Positioned)
                Stack(
                  children: [
                    /// ✅ Balance (Perfectly Centered)
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'RM 2,440.00',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
