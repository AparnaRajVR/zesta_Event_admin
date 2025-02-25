import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAdminCredentials() async {
    try {
      final docRef = _firestore.collection('admin').doc('credentials');
      final docSnapshot = await docRef.get();

     
      if (!docSnapshot.exists) {
        await docRef.set({
          'username': 'admin',
          'password': '123456', 
        });
        print("Admin credentials created successfully!");
      } else {
        print("Admin credentials already exist.");
      }
    } catch (e) {
      print("Error adding admin credentials: $e");
    }
  }
}
