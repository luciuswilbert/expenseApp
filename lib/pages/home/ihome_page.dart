import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/providers/gemini_img2img_provider.dart';
import 'package:iPocket/user_preferences/save_img.dart';
import 'package:image_picker/image_picker.dart';

class IHomePage extends StatefulWidget {
  const IHomePage({super.key});

  @override
  State<IHomePage> createState() => _IHomePageState();
}

class _IHomePageState extends State<IHomePage> {
  List<File?> stageImages = List.filled(5, null);
  int currentStage = 0;
  bool loading = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    loadStageImages().then((images) {
      setState(() {
        stageImages = images;
        selectedImage = stageImages[0];
      });
      _fetchUserBudgetAndUpdateImage();
    });
  }

  /// Map budget percentage (0.0 - 1.0) to stage (0-4)
  int determineStage(double percentLeft) {
    if (percentLeft < 0.05) return 4;
    if (percentLeft < 0.10) return 3;
    if (percentLeft < 0.20) return 2;
    if (percentLeft < 0.30) return 1;
    return 0;
  }

  String promptForStage(int stage) {
    switch (stage) {
      case 1:
        return """
        Draw a slightly damaged version of the house based on the uploaded image:
        - Add light wear like minor cracks, faded paint, and a few missing shingles.
        - Keep the house’s overall appearance and color scheme intact.
        """;

      case 2:
        return """
        Draw a moderately aged version of the house based on the original image:
        - Add broken windows, moldy walls, and wall stains.
        - Make the house appear weathered but still functional.
        """;

      case 3:
        return """
        Draw a heavily damaged version of the house from the original image:
        - Large wall cracks, broken windows, collapsed sections of roof.
        - Add visible signs of decay and destruction while keeping the structure identifiable.
        """;

      case 4:
        return """
        Draw a severely ruined and abandoned version of the house using the uploaded image:
        - Broken walls, missing roof, overgrown vegetation, shattered glass, and debris.
        - The house should look on the verge of collapse but remain recognizable in form.
        """;

      default:
        return "";
    }
  }

  Future<void> _handleUploadNewHome() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;

    await clearAllStageImages(); // 🔴 CHANGE HERE: reset before save
    File newImage = File(picker.path);
    final bytes = await newImage.readAsBytes();
    final saved = await saveStageImageToFile(bytes, 0);

    setState(() {
      stageImages = List.filled(5, null);
      stageImages[0] = saved;
      selectedImage = saved;
      currentStage = 0;
    });

    _fetchUserBudgetAndUpdateImage();
  }

  Future<void> _updateImageForBudget(double budgetPercentLeft) async {
    int newStage = determineStage(budgetPercentLeft);

    if (stageImages[0] == null) return;

    // 🛑 Already showing current stage
    if (currentStage == newStage) return;

    // ✅ Use cached image if already generated
    if (stageImages[newStage] != null) {
      setState(() {
        currentStage = newStage;
        selectedImage =
            stageImages[newStage]; // 🔴 FIX: make sure image updates
      });
      return;
    }

    // ✅ No need to generate stage 0
    if (newStage == 0) {
      setState(() {
        currentStage = 0;
        selectedImage = stageImages[0];
      });
      return;
    }

    setState(() => loading = true);

    // 🌟 Gemini call
    final generatedBytes = await GeminiImg2ImgService.generateImageFromFile(
      prompt: promptForStage(newStage),
      imageFile: stageImages[0]!,
    );

    if (generatedBytes != null) {
      final saved = await saveStageImageToFile(generatedBytes, newStage);
      setState(() {
        stageImages[newStage] = saved;
        selectedImage = saved; // 🔴 FIX: show newly saved stage image
        currentStage = newStage;
        loading = false;
      });
    } else {
      setState(() => loading = false);

      // 🔴 CHANGE HERE: Add error dialog (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ Failed to generate image for stage $newStage (Budget left: ${(budgetPercentLeft * 100).toStringAsFixed(1)}%)",
          ),
        ),
      );
    }
  }

  Future<void> _fetchUserBudgetAndUpdateImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();

    if (!userDoc.exists || userDoc.data() == null) return;

    final data = userDoc.data()!;
    final budgetStr = data['budget'];
    if (budgetStr == null) return;

    final double budget = double.tryParse(budgetStr) ?? 0;
    if (budget <= 0) return;

    final transactionsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('transactions')
            .get();

    double totalSpent = 0;
    for (final doc in transactionsSnapshot.docs) {
      final amount = doc.data()['amount'];
      if (amount != null) {
        totalSpent += (amount as num).toDouble();
      }
    }

    final percentLeft = (budget - totalSpent) / budget;
    print(
      "📊 Budget: $budget | Spent: $totalSpent | Left: ${percentLeft * 100}%",
    );

    _updateImageForBudget(percentLeft.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: const Text(
          'iHome',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xffDAA520),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton:
          selectedImage != null
              ? FloatingActionButton(
                onPressed: _handleUploadNewHome,
                backgroundColor: const Color(0xffDAA520),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Home Now: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _handleUploadNewHome,
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child:
                            selectedImage == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    Text(
                                      'Add Home Image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    selectedImage!,
                                    width: double.infinity,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Stage $currentStage",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
