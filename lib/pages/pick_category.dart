import './ocr.dart';
import './manual_add.dart';
import './voice_assistant.dart';
import 'package:flutter/material.dart';

class PickCategoryPage extends StatefulWidget {
  const PickCategoryPage({super.key}); // Add this
  @override
  PickCategoryPageState createState() => PickCategoryPageState();
}

class PickCategoryPageState extends State<PickCategoryPage> {
  String selectedOption = ""; // Default selected option
  bool isNavigating = false; // Prevent multiple navigations

  void navigateToPage(String option) async {
    if (isNavigating) return; // Prevent multiple taps
    isNavigating = true;

    final Map<String, Widget> pageRoutes = {
      "OCR (Scan the Receipt)": OcrPage(),
      "Manual":
          ManualAddPage(), // Change this if you have a separate ManualPage
      "AI (Voice Assistant)": VoiceAssistantPage(),
    };

    if (pageRoutes.containsKey(option)) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pageRoutes[option]!),
      );

      setState(() {
        selectedOption = ""; // Reset selection after returning
      });
    }

    isNavigating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Expense",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100, // Adjust this value to make it taller
        leading: IconButton(
          icon: Image.asset('assets/back_btn.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),

          buildOptionTile("Manual"),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ), // Controls line width
            child: Divider(thickness: 1, color: Colors.black12),
          ),
          buildOptionTile("OCR (Scan the Receipt)"),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ), // Controls line width
            child: Divider(thickness: 1, color: Colors.black12),
          ),
          buildOptionTile("AI (Voice Assistant)"),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ), // Controls line width
            child: Divider(thickness: 1, color: Colors.black12),
          ),
        ],
      ),
    );
  }

  Widget buildOptionTile(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = option;
        });

        Future.delayed(Duration(milliseconds: 300), () {
          navigateToPage(option);
        });
      },

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ), // Reduce vertical padding
        title: Text(option, style: TextStyle(fontSize: 16)),
        trailing:
            selectedOption == option
                ? Icon(Icons.check_circle, color: Color(0xFF5233FF))
                : null,
      ),
    );
  }
}
