import 'package:flutter/material.dart';
import 'package:ipocket/assets/curved_widgets.dart';
import 'package:ipocket/animation/squeeze_animation.dart';
import 'package:ipocket/assets/add_expenses_app_bar.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  OcrPageState createState() => OcrPageState();
}

class OcrPageState extends State<OcrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SqueezeAnimation(
                  child: CurvedBottomContainer(
                    height: 350,
                    child: AddExpensesAppBar(),
                  ),
                ),
                Positioned(
                  left: 25,
                  right: 25,
                  top: 180,
                  child: Container(
                    width: 300,
                    height: 325,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment(-0.85, 0),
                          child: Text(
                            "OCR",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment(-0.85, 0),
                          child: Text(
                            "INVOICE",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Submitted Successfully!"),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 50,
                                width: 275,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 70),
                                      child: Image.asset(
                                        'assets/plus_circle.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Add Invoice",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Tips: Ensure the receipt is in good condition, free from stains, folds, "
                                "or any damage, to allow for accurate OCR processing and proper scanning.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 550, // Controls vertical positioning only
                  child: SizedBox(
                    width:
                        MediaQuery.of(
                          context,
                        ).size.width, // Ensures full width for centering

                    child: Center(
                      // Ensures horizontal centering without affecting width
                      child: SizedBox(
                        width: 230,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Submit action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDAA520),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
