import 'package:expense_app_project/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_project/widgets/custom_text_field.dart';
import 'package:expense_app_project/widgets/custom_toggle.dart';
import 'package:expense_app_project/widgets/custom_dropdown.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedCurrency = "USD";
  String _selectedLanguage = "English";
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _securityEnabled = false;
  final TextEditingController _expenseBudgetController = TextEditingController(
    text: "1000",
  );

  final List<String> _currencies = ["USD", "EUR", "SGD", "MYR", "IDR"];
  final List<String> _languages = [
    "Afrikaans",
    "Albanian",
    "Amharic",
    "Arabic",
    "Armenian",
    "Azerbaijani",
    "Basque",
    "Belarusian",
    "Bengali",
    "Bosnian",
    "Bulgarian",
    "Burmese",
    "Catalan",
    "Cebuano",
    "Chinese (Simplified)",
    "Chinese (Traditional)",
    "Corsican",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "English",
    "Esperanto",
    "Estonian",
    "Filipino",
    "Finnish",
    "French",
    "Galician",
    "Georgian",
    "German",
    "Greek",
    "Gujarati",
    "Haitian Creole",
    "Hausa",
    "Hawaiian",
    "Hebrew",
    "Hindi",
    "Hmong",
    "Hungarian",
    "Icelandic",
    "Igbo",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Javanese",
    "Kannada",
    "Kazakh",
    "Khmer",
    "Korean",
    "Kurdish",
    "Kyrgyz",
    "Lao",
    "Latin",
    "Latvian",
    "Lithuanian",
    "Luxembourgish",
    "Macedonian",
    "Malagasy",
    "Malay",
    "Malayalam",
    "Maltese",
    "Maori",
    "Marathi",
    "Mongolian",
    "Nepali",
    "Norwegian",
    "Pashto",
    "Persian",
    "Polish",
    "Portuguese",
    "Punjabi",
    "Romanian",
    "Russian",
    "Samoan",
    "Scottish Gaelic",
    "Serbian",
    "Shona",
    "Sindhi",
    "Sinhala",
    "Slovak",
    "Slovenian",
    "Somali",
    "Spanish",
    "Sundanese",
    "Swahili",
    "Swedish",
    "Tajik",
    "Tamil",
    "Telugu",
    "Thai",
    "Turkish",
    "Ukrainian",
    "Urdu",
    "Uzbek",
    "Vietnamese",
    "Welsh",
    "Xhosa",
    "Yiddish",
    "Yoruba",
    "Zulu",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520), // Goldenrod color
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center, // ✅ Ensures the title stays centered
          children: [
            /// ✅ Back Button (Left-Aligned)
            const Positioned(
              left: 0,
              child: CustomBackButton(),
            ),

            /// ✅ Centered Title
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Currency Dropdown
            CustomDropdown(
              label: "Currency",
              items: _currencies,
              selectedItem: _selectedCurrency,
              onChanged: (value) => setState(() => _selectedCurrency = value!),
            ),
            /// Expense Budget (Using CustomTextField)
            CustomTextField(
              label: "Expense Budget",
              controller: _expenseBudgetController,
              keyboardType: TextInputType.number,
            ),

            /// Theme Toggle (Using CustomToggle)
            CustomToggle(
              title: "Dark Mode",
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
            ),

            /// Language Dropdown
            CustomDropdown(
              label: "Language",
              items: _languages,
              selectedItem: _selectedLanguage,
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),

            /// Notifications Toggle
            CustomToggle(
              title: "Notifications",
              value: _notificationsEnabled,
              onChanged:
                  (value) => setState(() => _notificationsEnabled = value),
            ),

            /// Security Toggle (PIN/Face ID)
            CustomToggle(
              title: "Security (PIN/Face ID)",
              value: _securityEnabled,
              onChanged: (value) => setState(() => _securityEnabled = value),
            ),
          ],
        ),
      ),
    );
  }
}
