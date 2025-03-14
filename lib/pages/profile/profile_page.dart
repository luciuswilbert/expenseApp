import 'package:flutter/material.dart';
import 'account_info_page.dart'; // Import the Account Info Page

import 'package:expense_app_project/pages/Notification/notification_page.dart';

import 'package:expense_app_project/widgets/curved_bottom_container.dart';

import 'package:expense_app_project/widgets/logout_dialog.dart';

import 'package:expense_app_project/pages/profile/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Lucius Wilbert Tjoa";
  String userEmail = "luciuswilbert@gmail.com";
  String profileImage =
      "assets/profile_placeholder.png"; // Replace with actual profile image path

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return LogoutDialog(
          onConfirm: () {
            // TODO: Implement actual logout functionality
            print("User logged out"); // Debugging
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 120), // Increased spacing to push menu down
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        /// Curved Background Container
        CurvedBottomContainer(
          height: 200, // Slightly increased height
          child: const SizedBox(), // No need for extra content inside
        ),

        /// "Profile" Title at the Top (Moved Up)
        Positioned(
          top: 60, // 🔹 Moved Up (Previously 50)
          child: const Text(
            "Profile",
            style: TextStyle(
              fontSize:
                  30, // 🔹 Slightly reduced font size for better alignment
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        /// Profile Picture, Name, and Email (Pushed Down)
        Positioned(
          top: 140, // Kept the profile image lower
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(profileImage),
                ),
              ),
              const SizedBox(height: 12), // Adjusted spacing
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),

        /// Back Button (Keeps Alignment)
        Positioned(
          top: 50,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Add back navigation logic
            },
          ),
        ),

        /// Notification Button (Keeps Alignment)
        Positioned(
          top: 50,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildOption(Icons.person, "Account Info"),
        _buildOption(Icons.settings, "Settings"),
        _buildOption(Icons.delete, "Clear Cache"),
        _buildOption(Icons.logout, "Log Out"),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
          leading: Icon(icon, color: Colors.black54),
          title: Text(title, style: const TextStyle(fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            if (title == "Account Info") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInfoPage(),
                ),
              );
            } else if (title == "Settings") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            } else if (title == "Log Out") {
              _showLogoutDialog();
            }
          },
        ),
      ),
    );
  }
}
