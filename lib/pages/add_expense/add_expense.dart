import 'package:expense_app_project/utils/transaction_helpers.dart';
import 'package:expense_app_project/widgets/custom_three_dot_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final String? expenseCategory;
  final double? totalAmount;
  final String? description;

  const AddExpensePage({
    this.expenseCategory,
    this.totalAmount,
    this.description,
    Key? key,
  }) : super(key: key);
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill if AI values are provided
    if (widget.totalAmount != null) {
      _amountController.text = widget.totalAmount!.toStringAsFixed(2);
    }
    if (widget.description != null) {
      _descriptionController.text = widget.description!;
    }
    if (widget.expenseCategory != null) {
      _selectedCategory = widget.expenseCategory!;
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // ✅ Makes background white
            colorScheme: const ColorScheme.light(
              primary: Color(0xffDAA520), // ✅ Goldenrod for selected date
              onPrimary: Colors.white, // ✅ Ensures selected date text is visible
              onSurface: Colors.black, // ✅ Black text for dates
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // ✅ Black text for buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Add Expense',
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  ),
  backgroundColor: const Color(0xffDAA520), // Goldenrod
  centerTitle: true,
  actions: [
    CustomThreeDotMenu(context: context), // ✅ Now handles navigation inside the widget
  ],
),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category'),
              _buildDropdown(),

              const SizedBox(height: 12),
              _buildLabel('Amount'),
              _buildTextField(
                _amountController,
                TextInputType.number,
                prefixText: '\$',
              ),

              const SizedBox(height: 12),
              _buildLabel('Date'),
              _buildDateField(),

              const SizedBox(height: 12),
              _buildLabel('Description'),
              _buildTextField(
                _descriptionController,
                TextInputType.text,
                maxLines: 3,
                hintText: 'Buying a Ramen',
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("submit pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffDAA520), // Goldenrod
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable label widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// Custom dropdown to prevent automatic scrolling and ensure consistent styling
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(color: Colors.grey),
        color: Colors.white, // Ensures a white background
      ),
      child: PopupMenuButton<String>(
        color: Colors.white, // ✅ Ensures the dropdown background is white
        onSelected: (String value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        itemBuilder:
            (BuildContext context) =>
                [
                  'Groceries',
                  'Subscription',
                  'Food',
                  'Shopping',
                  'Miscellaneous',
                  'Healthcare',
                  'Transportation',
                  'Utilities',
                  'Housing',
                ].map((String category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          getCategoryIcon(category),
                          color: getCategoryColor(category),
                        ), // ✅ Icons shown
                        const SizedBox(width: 10),
                        Text(
                          category,
                          style: const TextStyle(
                            color: Colors.black,
                          ), // ✅ Ensures text visibility
                        ),
                      ],
                    ),
                  );
                }).toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedCategory == null
                  ? const Text(
                    'Select a category',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                  : Row(
                    children: [
                      Icon(
                        getCategoryIcon(_selectedCategory!),
                        color: getCategoryColor(_selectedCategory!),
                      ), // ✅ Show selected icon
                      const SizedBox(width: 10),
                      Text(
                        _selectedCategory!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ), // ✅ Keeps selected text visible
                      ),
                    ],
                  ),
              const Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable text field with optional prefix (e.g., "$" for amount) and hint text
  Widget _buildTextField(
    TextEditingController controller,
    TextInputType keyboardType, {
    int maxLines = 1,
    String? prefixText,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon:
            prefixText != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 6),
                  child: Text(
                    prefixText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText, // ✅ Placeholder text
        hintStyle: const TextStyle(
          color: Colors.grey,
        ), // ✅ Light grey text to match placeholder styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
    );
  }

  /// Date picker field
  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Select a date'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: const TextStyle(color: Colors.black87),
            ),
            const Icon(Icons.calendar_today, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
