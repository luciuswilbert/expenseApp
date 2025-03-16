import "package:cloud_firestore/cloud_firestore.dart";

import "dart:developer";

class DatabaseService {
  final _fire = FirebaseFirestore.instance;

  void create() async {
    try {
      await _fire.collection("records").add({
        "amount": 20,
        "category": "Entertainment",
        "date": Timestamp.fromDate(DateTime(2025, 2, 22)),
      });
      log("Record added successfully.");
    } catch (e) {
      log("Error adding record: $e");
    }
  }
}
