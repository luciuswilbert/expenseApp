import 'package:flutter/material.dart';
import 'transaction_page.dart';
import 'main.dart';
// Define a custom widget for the bottom navigation bar
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // To track the currently selected tab
  final Function(int) onItemTapped; // Callback for handling taps

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color.fromARGB(64, 0, 0, 0),
            blurRadius: 15,
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        color: Colors.white, // You can change this color as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              icon: Icons.home,
              label: 'Home',
              selectedColor: const Color(0xffDAA520),
              unselectedColor: Colors.grey,
            ),
            _buildNavItem(
              context: context,
              index: 1,
              icon: Icons.receipt,
              label: 'Transaction',
              selectedColor: const Color(0xffDAA520),
              unselectedColor: Colors.grey,
            ),
            const SizedBox(width: 80), // Space for FAB
            _buildNavItem(
              context: context,
              index: 2,
              icon: Icons.pie_chart,
              label: 'Summary',
              selectedColor: const Color(0xffDAA520),
              unselectedColor: Colors.grey,
            ),
            _buildNavItem(
              context: context,
              index: 3,
              icon: Icons.person,
              label: 'Profile',
              selectedColor: const Color(0xffDAA520),
              unselectedColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each navigation item
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        onItemTapped(index); // Notify the parent widget of the tap
        // Navigation logic based on the index
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            print("Home tapped");
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionPage()),
            );
            print("Transaction tapped");
            break;
          case 2:
            print("Summary tapped");
            break;
          case 3:
            print("Profile tapped");
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? selectedColor : unselectedColor,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }
}



