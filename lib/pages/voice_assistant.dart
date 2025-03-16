import 'package:flutter/material.dart';
import 'package:ipocket/assets/curved_widgets.dart';
import 'package:ipocket/animation/squeeze_animation.dart';
import 'package:ipocket/assets/add_expenses_app_bar.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  VoiceAssistantPageState createState() => VoiceAssistantPageState();
}

class VoiceAssistantPageState extends State<VoiceAssistantPage> {
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
                          alignment: Alignment(-0.6, 0),
                          child: Text(
                            "AI Voice Assistant",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
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
                                width: 150,
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
                                      padding: EdgeInsets.only(left: 60),
                                      child: Image.asset(
                                        'assets/microphone.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Tips: Speak clearly and avoid background noise to ensure accurate voice recognition by the AI Voice Assistant."
                                "Maintain a steady pace and pronounce words distinctly for the best results",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
