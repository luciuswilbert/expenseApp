import 'package:expense_app_project/pages/add_expense/add_expense.dart';
import 'package:expense_app_project/pages/add_expense/ocr_add_expense.dart';
import 'package:expense_app_project/pages/add_expense/voice_assistant_add_expense.dart';
import 'package:flutter/material.dart';

class CustomThreeDotMenu extends StatelessWidget {
  final BuildContext context; // Pass context for navigation

  const CustomThreeDotMenu({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black, size: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white, // ✅ White background for the menu
      onSelected: (String value) {
        String? currentRoute =
            ModalRoute.of(context)?.settings.name; // ✅ Get current route

        if (value == "Manual" && currentRoute != '/add_expense') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpensePage(),
              settings: const RouteSettings(
                name: '/add_expense',
              ), // ✅ Assign route name
            ),
          );
        } else if (value == "OCR (Scan the Receipt)" &&
            currentRoute != '/ocr_add_expense') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OCRAddExpensePage(),
              settings: const RouteSettings(name: '/ocr_add_expense'),
            ),
          );
        } else if (value == "AI (Voice Assistant)" &&
            currentRoute != '/ai_voice_assistant') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RecorderScreen(),
              settings: const RouteSettings(name: '/ai_voice_assistant'),
            ),
          );
        }
      },
      itemBuilder:
          (BuildContext context) => [
            _buildMenuItem("Manual", Icons.edit, Colors.blue),
            _buildMenuItem(
              "OCR (Scan the Receipt)",
              Icons.camera_alt,
              Colors.green,
            ),
            _buildMenuItem("AI (Voice Assistant)", Icons.mic, Colors.purple),
          ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String title,
    IconData icon,
    Color iconColor,
  ) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
