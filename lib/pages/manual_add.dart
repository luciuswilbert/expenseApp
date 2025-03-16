import 'package:flutter/material.dart';
import 'package:ipocket/assets/curved_widgets.dart';
import 'package:ipocket/animation/squeeze_animation.dart';
import 'package:ipocket/assets/add_expenses_app_bar.dart';
import 'package:intl/intl.dart';

class ManualAddPage extends StatefulWidget {
  const ManualAddPage({super.key});

  @override
  ManualAddPageState createState() => ManualAddPageState();
}

class ManualAddPageState extends State<ManualAddPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  String _selectedCategory = "Food"; // Default category selection
  DateTime _selectedDate = DateTime.now(); // Default date

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Shopping',
    'Bills',
  ];

  // Dynamic Color Variables
  Color _amountBorderColor = Colors.grey;
  Color _amountTextColor = Colors.black;
  Color _descriptionBorderColor = Colors.grey;
  Color _descriptionTextColor = Colors.black;
  Color _dateColor = Colors.black54;

  @override
  void initState() {
    super.initState();

    _amountFocus.addListener(() {
      setState(() {
        if (_amountFocus.hasFocus) {
          _amountBorderColor = Colors.amber;
          _amountTextColor = Colors.amber;
        } else {
          _amountBorderColor = Colors.grey;
          _amountTextColor = Colors.black;
        }
      });
    });

    _descriptionFocus.addListener(() {
      setState(() {
        if (_descriptionFocus.hasFocus) {
          _descriptionBorderColor = Colors.amber;
          _descriptionTextColor = Colors.amber;
        } else {
          _descriptionBorderColor = Colors.grey;
          _descriptionTextColor = Colors.black;
        }
      });
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateColor = Colors.black; // Change color when a new date is picked
      });
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Bills':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SqueezeAnimation(
                      child: CurvedBottomContainer(
                        height: 350,
                        child: const AddExpensesAppBar(),
                      ),
                    ),
                    Positioned(
                      left: 25,
                      right: 25,
                      top: 180,
                      child: Container(
                        width: 300,
                        height: 440,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 35,
                              offset: Offset(0, 22),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),

                              // Category Dropdown
                              Text(
                                "CATEGORY",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    isExpanded: true,
                                    items:
                                        _categories.map((String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  getCategoryIcon(category),
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  category,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _categories.remove(newValue);
                                        _categories.insert(0, newValue!);
                                        _selectedCategory = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Amount Input
                              TextField(
                                controller: _amountController,
                                focusNode: _amountFocus,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter Amount",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _amountBorderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _amountBorderColor,
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.attach_money),
                                  suffixIcon:
                                      _amountController.text.isNotEmpty
                                          ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _amountController
                                                    .clear(); // Clears input
                                              });
                                            },
                                          )
                                          : null, // Hide clear button if input is empty
                                ),
                                onChanged: (text) {
                                  setState(() {}); // Force UI refresh
                                },
                                cursorColor: Colors.amber,
                                style: TextStyle(
                                  color: _amountTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Date Picker
                              Text(
                                "DATE",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: _pickDate,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'EEE, dd MMM yyyy',
                                        ).format(_selectedDate),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _dateColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Description Input
                              // Description Input Field
                              Text(
                                "DESCRIPTION",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _descriptionController,
                                focusNode: _descriptionFocus,
                                decoration: InputDecoration(
                                  hintText: "Buy a Ramen",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _descriptionBorderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _descriptionBorderColor,
                                      width: 2,
                                    ),
                                  ),
                                  suffixIcon:
                                      _descriptionController.text.isNotEmpty
                                          ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              _descriptionController
                                                  .clear(); // Clears the input
                                              setState(
                                                () {},
                                              ); // Hides clear button immediately
                                            },
                                          )
                                          : null, // Hide the clear button if input is empty
                                ),
                                onChanged: (text) {
                                  // Update the UI so the clear button appears/disappears
                                  setState(() {});
                                },

                                cursorColor: Colors.amber,
                                style: TextStyle(
                                  color: _descriptionTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Submit Button
                    Positioned(
                      top: 660,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 230,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Submit action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDAA520),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   required FocusNode focusNode,
  //   required String hintText,
  //   IconData? prefixIcon,
  //   TextInputType keyboardType = TextInputType.text,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 15,
  //           color: Colors.black54,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       TextField(
  //         controller: controller,
  //         focusNode: focusNode,
  //         keyboardType: keyboardType,
  //         decoration: InputDecoration(
  //           hintText: hintText,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(
  //               color: focusNode.hasFocus ? Colors.amber : Colors.grey,
  //             ),
  //           ),
  //           prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
