
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAdminUser() async {
    try {
      final docRef = _firestore.collection('admin').doc('admin@gmail.com');
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({'role': 'admin'});
      }
    } catch (e) {
      log("Error adding admin: $e");
    }
  }
}
