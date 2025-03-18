
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot adminDoc = 
          await _firestore.collection("admin").doc(email).get();

      if (adminDoc.exists && adminDoc.get("role") == "admin") {
        return userCredential.user;
      } else {
        await _auth.signOut();
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
