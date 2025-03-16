import 'package:ipocket/pages/pick_category.dart';
import 'package:flutter/material.dart';

class AddExpensesAppBar extends StatelessWidget {
  const AddExpensesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image.asset('assets/back_btn.png', width: 24, height: 24),
              onPressed: () {
                Navigator.pop(context); // Go back
              },
            ),
            Text(
              "Add Expense",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Image.asset('assets/3_dot.png', width: 24, height: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PickCategoryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
